USE [Caso3DB];
GO

DROP PROCEDURE IF EXISTS [dbo].[sp_CreateUpdateProposal];
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_CreateUpdateProposal]
    @ProposalID INT = NULL,
    @Name NVARCHAR(150),
    @UserID INT,
    @ProposalTypeID INT,
    @IntegrityHash VARBINARY(512) = NULL,
    @TargetGroups NVARCHAR(MAX) = NULL,
    @Documents NVARCHAR(MAX) = NULL,
    @Status NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TransactionCountOnEntry INT = @@TRANCOUNT;
    
    BEGIN TRY
        -- Solo comenzar transacción si no estamos dentro de una existente
        IF @TransactionCountOnEntry = 0
            BEGIN TRANSACTION;
        ELSE
            SAVE TRANSACTION sp_CreateUpdateProposal; -- Usar punto de guardado para transacciones anidadas

        DECLARE @CurrentDate DATETIME = GETDATE(); -- 2025-06-11 01:27:00 CST
        DECLARE @NewIntegrityHash VARBINARY(512);
        DECLARE @VersionNumber DECIMAL(5,2) = 1.0;
        DECLARE @ExistingVersionCount INT;

        -- Validar permisos del usuario
        IF NOT EXISTS (SELECT 1 FROM [dbo].[pv_users] WHERE userID = @UserID AND accountStatusID = 1)
        BEGIN
            SET @Status = 'Error: Usuario no autorizado o inactivo';
            IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Generar o actualizar IntegrityHash
        IF @IntegrityHash IS NULL
            SET @NewIntegrityHash = HASHBYTES('SHA2_256', @Name + CAST(@CurrentDate AS NVARCHAR(50)));
        ELSE
            SET @NewIntegrityHash = @IntegrityHash;

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
                RETURN;
            END

            UPDATE [dbo].[pv_propposals]
            SET proposalTypeID = @ProposalTypeID,
                name = @Name,
                lastUpdate = @CurrentDate,
                integrityHash = @NewIntegrityHash
            WHERE proposalID = @ProposalID;
            SET @Status = 'Actualizado';
        END

        -- Registrar versión del historial
        SELECT @ExistingVersionCount = COUNT(*) FROM [dbo].[pv_proposalVersion] WHERE proposalID = @ProposalID;
        IF @ExistingVersionCount > 0
            SET @VersionNumber = (SELECT MAX(versionNumber) + 0.1 FROM [dbo].[pv_proposalVersion] WHERE proposalID = @ProposalID);

        INSERT INTO [dbo].[pv_proposalVersion] (proposalID, versionNumber, createdAt, madeChanges, versionStatus, contentHash, revisionComments)
        VALUES (@ProposalID, @VersionNumber, @CurrentDate, 'Actualización de propuesta', 'Pendiente', @NewIntegrityHash, 'En revisión por IA');

        -- Asociar grupos objetivo
        IF @TargetGroups IS NOT NULL
        BEGIN
            DELETE FROM [dbo].[pv_proposalTargetGroups] WHERE proposalID = @ProposalID;
            INSERT INTO [dbo].[pv_proposalTargetGroups] (proposalID, groupID, createdAt, deleted)
            SELECT @ProposalID, JSON_VALUE(value, '$.groupID'), @CurrentDate, 0
            FROM OPENJSON(@TargetGroups);
        END

        -- Manejar archivos adjuntos con preprocesamiento
        IF @Documents IS NOT NULL
        BEGIN
            -- Crear tabla temporal para depuración
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

            -- Insertar datos crudos con un número de fila
            INSERT INTO #DebugDocuments (fileName, rawSize, format, rawUploadDate, rawValidationStatusID, rawUserID, rawInstitutionID, rawMediaTypeID, rawDocumentTypeID, ErrorMessage, RowNum)
            SELECT 
                JSON_VALUE(d.value, '$.fileName'),
                JSON_VALUE(d.value, '$.size'),
                JSON_VALUE(d.value, '$.format'),
                JSON_VALUE(d.value, '$.uploadDate'),
                JSON_VALUE(d.value, '$.validationStatusID'),
                JSON_VALUE(d.value, '$.userID'),
                JSON_VALUE(d.value, '$.institutionID'),
                JSON_VALUE(d.value, '$.mediaTypeID'),
                JSON_VALUE(d.value, '$.documentTypeID'),
                NULL,
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
            FROM OPENJSON(@Documents) d;

            -- Depuración: Verificar datos iniciales
            -- SELECT * FROM #DebugDocuments; -- Descomenta para inspeccionar

            -- Actualizar con conversiones
            -- Paso 1: Actualizar fileHash, storageLocation y otras conversiones
            UPDATE d
            SET fileHash = CONVERT(VARBINARY(250), HASHBYTES('SHA2_256', 'DOC_' + RIGHT('000' + CAST(d.RowNum AS VARCHAR(3)), 3))),
                storageLocation = CONVERT(VARBINARY(250), 'STOR_LOC_' + RIGHT('000' + CAST(d.RowNum AS VARCHAR(3)), 3)),
                size = CASE 
                       WHEN d.rawSize IS NOT NULL AND TRY_CAST(d.rawSize AS INT) IS NOT NULL 
                       THEN CAST(d.rawSize AS INT)
                       ELSE NULL 
                       END,
                uploadDate = CASE 
                             WHEN d.rawUploadDate IS NOT NULL AND TRY_CAST(d.rawUploadDate AS DATETIME) IS NOT NULL 
                             THEN CONVERT(DATETIME, d.rawUploadDate, 120)
                             ELSE NULL 
                             END,
                validationStatusID = CASE 
                                     WHEN d.rawValidationStatusID IS NOT NULL AND TRY_CAST(d.rawValidationStatusID AS INT) IS NOT NULL 
                                     THEN CAST(d.rawValidationStatusID AS INT)
                                     ELSE NULL 
                                     END,
                userID = CASE 
                         WHEN d.rawUserID IS NOT NULL AND TRY_CAST(d.rawUserID AS INT) IS NOT NULL 
                         THEN CAST(d.rawUserID AS INT)
                         ELSE NULL 
                         END,
                institutionID = CASE 
                                WHEN d.rawInstitutionID IS NULL OR (d.rawInstitutionID IS NOT NULL AND TRY_CAST(d.rawInstitutionID AS INT) IS NOT NULL) 
                                THEN CAST(NULLIF(d.rawInstitutionID, '') AS INT)
                                ELSE NULL 
                                END,
                mediaTypeID = CASE 
                              WHEN d.rawMediaTypeID IS NOT NULL AND TRY_CAST(d.rawMediaTypeID AS INT) IS NOT NULL 
                              THEN CAST(d.rawMediaTypeID AS INT)
                              ELSE NULL 
                              END,
                documentTypeID = CASE 
                                 WHEN d.rawDocumentTypeID IS NOT NULL AND TRY_CAST(d.rawDocumentTypeID AS INT) IS NOT NULL 
                                 THEN CAST(d.rawDocumentTypeID AS INT)
                                 ELSE NULL 
                                 END
            FROM #DebugDocuments d;

            -- Depuración: Verificar datos después del primer UPDATE
            -- SELECT fileName, rawSize, size, uploadDate, validationStatusID, userID, institutionID, mediaTypeID, documentTypeID, RowNum FROM #DebugDocuments; -- Descomenta para inspeccionar

            -- Paso 2: Actualizar el ErrorMessage
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
                               WHEN d.rawMediaTypeID IS NULL OR d.mediaTypeID IS NULL THEN 'Invalid mediaTypeID'
                               WHEN d.rawDocumentTypeID IS NULL OR d.documentTypeID IS NULL THEN 'Invalid documentTypeID'
                               ELSE NULL
                               END
            FROM #DebugDocuments d;

            -- Depuración: Verificar datos después del segundo UPDATE
            -- SELECT fileName, size, ErrorMessage FROM #DebugDocuments; -- Descomenta para inspeccionar

            -- Verificar si hay errores
            IF EXISTS (SELECT 1 FROM #DebugDocuments WHERE ErrorMessage IS NOT NULL)
            BEGIN
                SET @Status = 'Error: ' + (SELECT TOP 1 ErrorMessage FROM #DebugDocuments WHERE ErrorMessage IS NOT NULL);
                IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                ELSE IF @TransactionCountOnEntry > 0
                    ROLLBACK TRANSACTION sp_CreateUpdateProposal;
                DROP TABLE IF EXISTS #DebugDocuments;
                RETURN;
            END

            -- Crear tabla temporal final con restricciones
            CREATE TABLE #TempDocuments (
                fileName NVARCHAR(50) NOT NULL,
                fileHash VARBINARY(250) NOT NULL,
                size INT NOT NULL,
                format NVARCHAR(10) NOT NULL,
                uploadDate DATETIME NOT NULL,
                validationStatusID INT NOT NULL,
                storageLocation VARBINARY(250) NOT NULL,
                userID INT NOT NULL,
                institutionID INT NULL,
                mediaTypeID INT NOT NULL,
                documentTypeID INT NOT NULL
            );

            -- Depuración: Verificar datos antes de insertar en #TempDocuments
            -- SELECT * FROM #DebugDocuments; -- Descomenta para inspeccionar

            -- Insertar datos validados
            INSERT INTO #TempDocuments (fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID)
            SELECT fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID
            FROM #DebugDocuments;

            -- Depuración: Verificar datos en #TempDocuments
            -- SELECT * FROM #TempDocuments; -- Descomenta para inspeccionar

           
            -- Insertar en pv_proposalDocument
            INSERT INTO [dbo].[pv_proposalDocument] (proposalID, proposalVersionID, fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID)
            SELECT @ProposalID, COALESCE((SELECT MAX(proposalVersionID) FROM [dbo].[pv_proposalVersion] WHERE proposalID = @ProposalID), 1),
                   fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID
            FROM #TempDocuments;

        
            -- Preparar para revisión automatizada (solo si hay documentos)
            IF EXISTS (SELECT 1 FROM [dbo].[pv_proposalDocument] WHERE proposalID = @ProposalID)
            BEGIN
                INSERT INTO [dbo].[pv_workFlowsInstances] (proposalDocumentID, dagRunID, dagURL, payload, bucketOrigin, validationStatusID, startedAt, finishedAt, createdAt, updatedAt, workflowsDefinitionID)
                SELECT COALESCE(MAX(proposalDocumentID), (SELECT MAX(proposalDocumentID) FROM [dbo].[pv_proposalDocument])), -- Usar el último proposalDocumentID
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


            DROP TABLE IF EXISTS #TempDocuments;
            DROP TABLE IF EXISTS #DebugDocuments;
        END

        -- Devolver resultado
        SELECT @ProposalID AS proposalID, @Status AS status;

        -- Solo hacer COMMIT si iniciamos la transacción
        IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Manejar rollback según si estamos en una transacción anidada o no
        IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        ELSE IF @TransactionCountOnEntry > 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION sp_CreateUpdateProposal;
            
        SET @Status = 'Error: ' + ERROR_MESSAGE();
        SELECT NULL AS proposalID, @Status AS status;
    END CATCH
END;
GO

DECLARE @Status NVARCHAR(50);
EXEC [dbo].[sp_CreateUpdateProposal]
    @ProposalID = 1,
    @Name = 'Prueba Simple',
    @UserID = 2,
    @ProposalTypeID = 1,
    @TargetGroups = N'[{"groupID": 1}, {"groupID": 2}]',
    @Documents = N'[{"fileName": "Propuesta_Tecnica_V1.pdf", "size": 1024, "format": "PDF", "uploadDate": "2025-06-11 01:27:00", "validationStatusID": 2, "userID": 1, "institutionID": 1, "mediaTypeID": 2, "documentTypeID": 1}]',
    @Status = @Status OUTPUT;
SELECT @Status AS Status;
-- Descomenta las líneas de depuración en el SP y ejecuta nuevamente para inspeccionar
