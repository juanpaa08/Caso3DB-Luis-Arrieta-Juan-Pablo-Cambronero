USE [Caso3DB];
GO

DROP PROCEDURE IF EXISTS [dbo].[sp_CreateUpdateProposal];
GO

-- Definición de tipos de tabla para TVPs
CREATE TYPE [dbo].[TargetGroupsType] AS TABLE
(
    groupID INT NOT NULL
);
GO

CREATE TYPE [dbo].[DocumentsType] AS TABLE
(
    fileName NVARCHAR(50),
    size NVARCHAR(10),
    format NVARCHAR(10),
    uploadDate NVARCHAR(20),
    validationStatusID NVARCHAR(10),
    userID NVARCHAR(10),
    institutionID NVARCHAR(10),
    mediaTypeID NVARCHAR(10),
    documentTypeID NVARCHAR(10)
);
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_CreateUpdateProposal]
    @ProposalID INT = NULL OUTPUT,
    @Name NVARCHAR(150),
    @UserID INT,
    @ProposalTypeID INT,
    @IntegrityHash VARBINARY(512) = NULL,
    @TargetGroups [dbo].[TargetGroupsType] READONLY,
    @Documents [dbo].[DocumentsType] READONLY,
    @Status NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TransactionCountOnEntry INT = @@TRANCOUNT;
    
    BEGIN TRY
        SET NOCOUNT OFF; -- Asegurar que el recordset se devuelva

        IF @TransactionCountOnEntry = 0
            BEGIN TRANSACTION;
        ELSE
            SAVE TRANSACTION sp_CreateUpdateProposal;

        DECLARE @CurrentDate DATETIME = GETDATE();
        DECLARE @NewIntegrityHash VARBINARY(512);

        -- Calcular integrityHash antes de la inserción si es una nueva propuesta
        IF @ProposalID IS NULL
        BEGIN
            SELECT @NewIntegrityHash = HASHBYTES('SHA2_256', 
                CAST(@ProposalTypeID AS NVARCHAR(10)) + 
                @Name + 
                CAST(@UserID AS NVARCHAR(10)) + 
                CAST(@CurrentDate AS NVARCHAR(50)) + 
                CAST(@CurrentDate AS NVARCHAR(50)) + 
                COALESCE(CAST(@IntegrityHash AS NVARCHAR(512)), ''));
        END

        -- Validar permisos del usuario
        IF NOT EXISTS (SELECT 1 FROM [dbo].[pv_users] WHERE userID = @UserID AND accountStatusID = 1)
        BEGIN
            SET @Status = 'Error: Usuario no autorizado o inactivo';
            IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            SELECT @ProposalID AS proposalID, @Status AS status;
            RETURN;
        END

        -- Crear o actualizar la propuesta
        IF @ProposalID IS NULL
        BEGIN
            INSERT INTO [dbo].[pv_propposals] (proposalTypeID, name, userID, createdAt, lastUpdate, integrityHash)
            VALUES (@ProposalTypeID, @Name, @UserID, @CurrentDate, @CurrentDate, @NewIntegrityHash);
            SET @ProposalID = SCOPE_IDENTITY();
            SET @Status = 'Creado';
        END
        ELSE
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM [dbo].[pv_propposals] WHERE proposalID = @ProposalID AND userID = @UserID)
            BEGIN
                SET @Status = 'Error: No tienes permisos para actualizar esta propuesta';
                IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                SELECT @ProposalID AS proposalID, @Status AS status;
                RETURN;
            END

            UPDATE [dbo].[pv_propposals]
            SET proposalTypeID = @ProposalTypeID,
                name = @Name,
                lastUpdate = @CurrentDate
            WHERE proposalID = @ProposalID;
            SET @Status = 'Actualizado';

            -- Calcular y actualizar integrityHash para actualización
            SELECT @NewIntegrityHash = HASHBYTES('SHA2_256', 
                CAST(@ProposalID AS NVARCHAR(10)) + 
                CAST(@ProposalTypeID AS NVARCHAR(10)) + 
                @Name + 
                CAST(@UserID AS NVARCHAR(10)) + 
                CAST(@CurrentDate AS NVARCHAR(50)) + 
                CAST(@CurrentDate AS NVARCHAR(50)) + 
                COALESCE(CAST((SELECT integrityHash FROM [dbo].[pv_propposals] WHERE proposalID = @ProposalID) AS NVARCHAR(512)), ''));
            UPDATE [dbo].[pv_propposals]
            SET integrityHash = @NewIntegrityHash
            WHERE proposalID = @ProposalID;
        END

        -- Asociar grupos objetivo
        IF EXISTS (SELECT 1 FROM @TargetGroups)
        BEGIN
            DELETE FROM [dbo].[pv_proposalTargetGroups] WHERE proposalID = @ProposalID;
            INSERT INTO [dbo].[pv_proposalTargetGroups] (proposalID, groupID, createdAt, deleted)
            SELECT @ProposalID, groupID, @CurrentDate, 0
            FROM @TargetGroups;
        END

        -- Manejar archivos adjuntos con preprocesamiento
        IF EXISTS (SELECT 1 FROM @Documents)
        BEGIN
            CREATE TABLE #DebugDocuments (
                fileName NVARCHAR(50),
                fileHash VARBINARY(250),
                rawSize NVARCHAR(10),
                size INT,
                format NVARCHAR(10),
                rawUploadDate NVARCHAR(20),
                uploadDate DATETIME,
                rawValidationStatusID NVARCHAR(10),
                validationStatusID INT,
                storageLocation VARBINARY(250),
                rawUserID NVARCHAR(10),
                userID INT,
                rawInstitutionID NVARCHAR(10),
                institutionID INT,
                rawMediaTypeID NVARCHAR(10),
                mediaTypeID INT,
                rawDocumentTypeID NVARCHAR(10),
                documentTypeID INT,
                ErrorMessage NVARCHAR(255),
                RowNum INT
            );

            INSERT INTO #DebugDocuments (fileName, rawSize, format, rawUploadDate, rawValidationStatusID, rawUserID, rawInstitutionID, rawMediaTypeID, rawDocumentTypeID, ErrorMessage, RowNum)
            SELECT 
                fileName,
                size,
                format,
                uploadDate,
                validationStatusID,
                userID,
                institutionID,
                mediaTypeID,
                documentTypeID,
                NULL,
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
            FROM @Documents;

            UPDATE d
            SET fileHash = CONVERT(VARBINARY(250), HASHBYTES('SHA2_256', 'DOC_' + RIGHT('000' + CAST(d.RowNum AS VARCHAR(3)), 3))),
                storageLocation = CONVERT(VARBINARY(250), 'STOR_LOC_' + RIGHT('000' + CAST(d.RowNum AS VARCHAR(3)), 3)),
                size = CASE WHEN d.rawSize IS NOT NULL AND TRY_CAST(d.rawSize AS INT) IS NOT NULL THEN CAST(d.rawSize AS INT) ELSE NULL END,
                uploadDate = CASE WHEN d.rawUploadDate IS NOT NULL AND TRY_CAST(d.rawUploadDate AS DATETIME) IS NOT NULL THEN CONVERT(DATETIME, d.rawUploadDate, 120) ELSE NULL END,
                validationStatusID = CASE WHEN d.rawValidationStatusID IS NOT NULL AND TRY_CAST(d.rawValidationStatusID AS INT) IS NOT NULL THEN CAST(d.rawValidationStatusID AS INT) ELSE NULL END,
                userID = CASE WHEN d.rawUserID IS NOT NULL AND TRY_CAST(d.rawUserID AS INT) IS NOT NULL THEN CAST(d.rawUserID AS INT) ELSE NULL END,
                institutionID = CASE WHEN d.rawInstitutionID IS NOT NULL AND TRY_CAST(d.rawInstitutionID AS INT) IS NOT NULL THEN CAST(d.rawInstitutionID AS INT) ELSE 0 END,
                mediaTypeID = CASE WHEN d.rawMediaTypeID IS NOT NULL AND TRY_CAST(d.rawMediaTypeID AS INT) IS NOT NULL THEN CAST(d.rawMediaTypeID AS INT) ELSE NULL END,
                documentTypeID = CASE WHEN d.rawDocumentTypeID IS NOT NULL AND TRY_CAST(d.rawDocumentTypeID AS INT) IS NOT NULL THEN CAST(d.rawDocumentTypeID AS INT) ELSE NULL END
            FROM #DebugDocuments d;

            UPDATE d
            SET ErrorMessage = CASE 
                               WHEN d.fileName IS NULL THEN 'Invalid fileName'
                               WHEN d.fileHash IS NULL THEN 'Invalid fileHash'
                               WHEN d.rawSize IS NULL OR d.size IS NULL THEN 'Invalid size'
                               WHEN d.format IS NULL THEN 'Invalid format'
                               WHEN d.rawUploadDate IS NULL OR d.uploadDate IS NULL THEN 'Invalid uploadDate'
                               WHEN d.rawValidationStatusID IS NULL OR d.validationStatusID IS NULL THEN 'Invalid validationStatusID'
                               WHEN d.storageLocation IS NULL THEN 'Invalid storageLocation'
                               WHEN d.rawUserID IS NULL OR d.userID IS NULL THEN 'Invalid userID'
                               WHEN d.rawInstitutionID IS NULL OR d.institutionID IS NULL THEN 'Invalid institutionID'
                               WHEN d.rawMediaTypeID IS NULL OR d.mediaTypeID IS NULL THEN 'Invalid mediaTypeID'
                               WHEN d.rawDocumentTypeID IS NULL OR d.documentTypeID IS NULL THEN 'Invalid documentTypeID'
                               ELSE NULL
                               END
            FROM #DebugDocuments d;

            IF EXISTS (SELECT 1 FROM #DebugDocuments WHERE ErrorMessage IS NOT NULL)
            BEGIN
                SET @Status = 'Error: ' + (SELECT TOP 1 ErrorMessage FROM #DebugDocuments WHERE ErrorMessage IS NOT NULL);
                IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                DROP TABLE #DebugDocuments;
                SELECT @ProposalID AS proposalID, @Status AS status;
                RETURN;
            END

            CREATE TABLE #TempDocuments (
                fileName NVARCHAR(50) NOT NULL,
                fileHash VARBINARY(250) NOT NULL,
                size INT NOT NULL,
                format NVARCHAR(10) NOT NULL,
                uploadDate DATETIME NOT NULL,
                validationStatusID INT NOT NULL,
                storageLocation VARBINARY(250) NOT NULL,
                userID INT NOT NULL,
                institutionID INT NOT NULL,
                mediaTypeID INT NOT NULL,
                documentTypeID INT NOT NULL
            );

            INSERT INTO #TempDocuments (fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID)
            SELECT fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, 
                   COALESCE(institutionID, 0),
                   mediaTypeID, documentTypeID
            FROM #DebugDocuments
            WHERE fileName IS NOT NULL AND size IS NOT NULL AND format IS NOT NULL AND uploadDate IS NOT NULL 
                  AND validationStatusID IS NOT NULL AND storageLocation IS NOT NULL AND userID IS NOT NULL 
                  AND institutionID IS NOT NULL AND mediaTypeID IS NOT NULL AND documentTypeID IS NOT NULL;

            IF @@ROWCOUNT = 0
            BEGIN
                SET @Status = 'Error: No se proporcionaron documentos válidos';
                IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                DROP TABLE #DebugDocuments;
                SELECT @ProposalID AS proposalID, @Status AS status;
                RETURN;
            END

            INSERT INTO [dbo].[pv_proposalDocument] (proposalID, proposalVersionID, fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID)
            SELECT @ProposalID, COALESCE((SELECT MAX(proposalVersionID) FROM [dbo].[pv_proposalVersion] WHERE proposalID = @ProposalID), 1),
                   fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID
            FROM #TempDocuments;

            IF EXISTS (SELECT 1 FROM [dbo].[pv_proposalDocument] WHERE proposalID = @ProposalID)
            BEGIN
                INSERT INTO [dbo].[pv_workFlowsInstances] (proposalDocumentID, dagRunID, dagURL, payload, bucketOrigin, validationStatusID, startedAt, finishedAt, createdAt, updatedAt, workflowsDefinitionID)
                SELECT COALESCE(MAX(proposalDocumentID), (SELECT MAX(proposalDocumentID) FROM [dbo].[pv_proposalDocument])),
                       'RUN_' + CAST(@ProposalID AS NVARCHAR(10)),
                       'http://workflow.local/run' + CAST(@ProposalID AS NVARCHAR(10)),
                       '{"title": "' + @Name + '"}',
                       'BUCKET_PROPOSAL_' + CAST(@ProposalID AS NVARCHAR(10)),
                       1,
                       @CurrentDate,
                       @CurrentDate,
                       @CurrentDate,
                       @CurrentDate,
                       1
                FROM [dbo].[pv_proposalDocument] WHERE proposalID = @ProposalID;
            END

            DROP TABLE #TempDocuments;
            DROP TABLE #DebugDocuments;
        END

        DECLARE @VersionNumber DECIMAL(5,2) = 1.0;
        DECLARE @ExistingVersionCount INT;

        SELECT @ExistingVersionCount = COUNT(*) FROM [dbo].[pv_proposalVersion] WHERE proposalID = @ProposalID;
        IF @ExistingVersionCount > 0
            SET @VersionNumber = (SELECT MAX(versionNumber) + 0.1 FROM [dbo].[pv_proposalVersion] WHERE proposalID = @ProposalID);

        INSERT INTO [dbo].[pv_proposalVersion] (proposalID, versionNumber, createdAt, madeChanges, versionStatus, contentHash, revisionComments)
        VALUES (@ProposalID, @VersionNumber, @CurrentDate, 'Actualización de propuesta', 'Pendiente', @NewIntegrityHash, 'En revisión por IA');

        SELECT @ProposalID AS proposalID, @Status AS status;

        IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        ELSE IF @TransactionCountOnEntry > 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION sp_CreateUpdateProposal;
            
        SET @Status = 'Error: ' + ERROR_MESSAGE();
        SET NOCOUNT OFF;
        SELECT @ProposalID AS proposalID, @Status AS status;
    END CATCH
END;
GO

-- Prueba para actualizar propuesta con usuario válido para propuesta asignada y que tenga accountStatus = 1
DECLARE @Status NVARCHAR(50);
DECLARE @TargetGroupsTable [dbo].[TargetGroupsType];
DECLARE @DocumentsTable [dbo].[DocumentsType];

-- Insertar datos en la tabla temporal para @TargetGroups
INSERT INTO @TargetGroupsTable (groupID)
VALUES (1), (2);

-- Insertar datos en la tabla temporal para @Documents
INSERT INTO @DocumentsTable (fileName, size, format, uploadDate, validationStatusID, userID, institutionID, mediaTypeID, documentTypeID)
VALUES 
    ('Propuesta_Tecnica_V1.pdf', '1024', 'PDF', '2025-06-11 01:27:00', '2', '2', '1', '2', '1');

-- Ejecutar el SP con las tablas temporales
EXEC [dbo].[sp_CreateUpdateProposal]
    @ProposalID = 1,
    @Name = 'Prueba Simple',
    @UserID = 2,
    @ProposalTypeID = 1,
    @TargetGroups = @TargetGroupsTable,
    @Documents = @DocumentsTable,
    @Status = @Status OUTPUT;

SELECT @Status AS Status;

DECLARE @TargetGroupsTest [dbo].[TargetGroupsType];
INSERT INTO @TargetGroupsTest (groupID) VALUES (1), (2); -- ← Así espera recibir los datos
