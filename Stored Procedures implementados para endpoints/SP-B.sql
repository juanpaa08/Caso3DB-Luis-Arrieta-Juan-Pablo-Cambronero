USE [Caso3DB];
GO

CREATE OR ALTER PROCEDURE [dbo].[revisarPropuesta]
    @proposalID INT, -- ID de la propuesta a revisar
    @reviewerID INT, -- ID del revisor
    @validationResult NVARCHAR(255), -- Resultado de la validación (aprobado/rechazado)
    @aiPayload NVARCHAR(MAX) = NULL -- Payload para IA (opcional)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- BEGIN TRANSACTION; -- Desactivado temporalmente para prueba
    BEGIN TRY
        -- Validar existencia de proposalID y reviewerID
        PRINT 'Verificando proposalID: ' + CAST(@proposalID AS NVARCHAR(10)); -- Depuración
        IF NOT EXISTS (SELECT 1 FROM pv_propposals WHERE proposalID = @proposalID)
            THROW 50001, 'Propuesta no encontrada.', 1;
        IF NOT EXISTS (SELECT 1 FROM pv_users WHERE userID = @reviewerID)
            THROW 50002, 'Revisor no encontrado.', 1;

        -- Depuración: Mostrar registros encontrados
        PRINT 'Registros en pv_proposalCore para proposalID = ' + CAST(@proposalID AS NVARCHAR(10)) + ': ';
        SELECT * FROM pv_proposalCore WHERE proposalID = @proposalID; -- Asegurar visibilidad

        -- Obtener el documentID asociado
        DECLARE @documentID INT;
        SELECT TOP 1 @documentID = proposalDocumentID 
        FROM pv_proposalDocument 
        WHERE proposalID = @proposalID;
        IF @documentID IS NULL
            THROW 50005, 'No se encontró documento para la propuesta.', 1;

        -- Obtener el workflowInstanceID asociado
        DECLARE @workflowInstanceID INT;
        SELECT @workflowInstanceID = workFlowID 
        FROM pv_workFlowsInstances 
        WHERE proposalDocumentID = @documentID;
        IF @workflowInstanceID IS NULL
            THROW 50006, 'No se encontró instancia de workflow para el documento.', 1;

        -- Obtener la configuración del workflow
        DECLARE @workflowDefinitionID INT;
        SELECT @workflowDefinitionID = workflowsDefinitionID
        FROM pv_workFlowsInstances
        WHERE workFlowID = @workflowInstanceID;

        -- Obtener parámetros dinámicos del workflow
        DECLARE @proposalRequirementID INT;
        SELECT @proposalRequirementID = CAST(parameterValueDefault AS INT)
        FROM pv_workflowParameters
        WHERE workflowDefinitionID = @workflowDefinitionID
        AND parameterKey = 'proposalRequirementID';

        IF @proposalRequirementID IS NULL
            SET @proposalRequirementID = 1; -- Valor por defecto si no está configurado

        -- Consultar tipo de propuesta y criterios de validación desde el workflow
        DECLARE @proposalTypeID INT;
        DECLARE @minimumRequirements NVARCHAR(MAX);
        SELECT @proposalTypeID = p.proposalTypeID, @minimumRequirements = pt.minimumRequirements
        FROM pv_propposals p
        JOIN pv_proposalType pt ON p.proposalTypeID = pt.propposalTypeID
        WHERE p.proposalID = @proposalID;

        IF @proposalTypeID IS NULL
            THROW 50004, 'Tipo de propuesta no definido.', 1;

        -- Preparar payloads esperados para validación por IA/LLM
        DECLARE @iapayloadProcessed NVARCHAR(MAX) = ISNULL(@aiPayload, '{"proposalID": ' + CAST(@proposalID AS NVARCHAR(10)) + ', "requirements": "' + ISNULL(@minimumRequirements, 'Sin requisitos') + '"}');

        -- Obtener estado de validación y status desde parámetros del workflow
        DECLARE @approvedStatus NVARCHAR(20);
        DECLARE @rejectedStatus NVARCHAR(20);
        DECLARE @approvedValidationStatusID INT;
        DECLARE @rejectedValidationStatusID INT;

        SELECT 
            @approvedStatus = wp1.parameterValueDefault,
            @rejectedStatus = wp2.parameterValueDefault,
            @approvedValidationStatusID = CAST(wp3.parameterValueDefault AS INT),
            @rejectedValidationStatusID = CAST(wp4.parameterValueDefault AS INT)
        FROM pv_workflowParameters wp1
        FULL OUTER JOIN pv_workflowParameters wp2 ON wp2.workflowDefinitionID = @workflowDefinitionID AND wp2.parameterKey = 'rejectedStatus'
        FULL OUTER JOIN pv_workflowParameters wp3 ON wp3.workflowDefinitionID = @workflowDefinitionID AND wp3.parameterKey = 'approvedValidationStatusID'
        FULL OUTER JOIN pv_workflowParameters wp4 ON wp4.workflowDefinitionID = @workflowDefinitionID AND wp4.parameterKey = 'rejectedValidationStatusID'
        WHERE wp1.workflowDefinitionID = @workflowDefinitionID AND wp1.parameterKey = 'approvedStatus';

        -- Verificar que los valores sean válidos
        IF @approvedStatus IS NULL OR @rejectedStatus IS NULL OR @approvedValidationStatusID IS NULL OR @rejectedValidationStatusID IS NULL
            THROW 50010, 'Configuración del workflow incompleta. Faltan valores para approvedStatus, rejectedStatus, approvedValidationStatusID o rejectedValidationStatusID.', 1;

        -- Depuración de valores de status
        PRINT 'approvedStatus: ' + ISNULL(@approvedStatus, 'NULL');
        PRINT 'rejectedStatus: ' + ISNULL(@rejectedStatus, 'NULL');
        PRINT 'approvedValidationStatusID: ' + ISNULL(CAST(@approvedValidationStatusID AS NVARCHAR(10)), 'NULL');
        PRINT 'rejectedValidationStatusID: ' + ISNULL(CAST(@rejectedValidationStatusID AS NVARCHAR(10)), 'NULL');

        -- Determinar @isValid basado solo en @validationResult
        DECLARE @isValid BIT = CASE WHEN @validationResult = 'aprobado' THEN 1 ELSE 0 END;

        -- Depuración antes del UPDATE
        PRINT 'Intentando actualizar proposalID: ' + CAST(@proposalID AS NVARCHAR(10)) + ' con status: ' + (CASE WHEN @isValid = 1 THEN @approvedStatus ELSE @rejectedStatus END);

        -- Actualizar estado en pv_proposalCore
        UPDATE pv_proposalCore
        SET status = (CASE WHEN @isValid = 1 THEN @approvedStatus ELSE @rejectedStatus END),
            lastUpdate = GETDATE()
        WHERE proposalID = @proposalID;

        -- Verificar que se actualizó al menos una fila
        IF @@ROWCOUNT = 0
            THROW 50008, 'No se encontró registro para actualizar en pv_proposalCore.', 1;

        -- Actualizar estado de validación en documentos
        UPDATE pv_proposalDocument
        SET validationStatusID = (CASE WHEN @isValid = 1 THEN @approvedValidationStatusID ELSE @rejectedValidationStatusID END)
        WHERE proposalID = @proposalID;

        -- Verificar que se actualizó al menos una fila
        IF @@ROWCOUNT = 0
            THROW 50009, 'No se encontró registro para actualizar en pv_proposalDocument.', 1;

        -- Preparar valores para pv_proposalValidation
        DECLARE @message NVARCHAR(200) = ISNULL('Validación por usuario ' + CAST(@reviewerID AS NVARCHAR(10)) + ': ' + @validationResult, 'Validación sin resultado');
        DECLARE @technicalDetails NVARCHAR(MAX) = ISNULL('Payload procesado: ' + @iapayloadProcessed + ' - ' + CAST(GETDATE() AS NVARCHAR(30)), 'Validación manual - ' + CAST(GETDATE() AS NVARCHAR(30)));

        -- Registrar validación en pv_proposalValidation
        INSERT INTO pv_proposalValidation (proposalID, proposalRequirementID, result, message, validationDate, automaticSystem, technicalDetails)
        VALUES (@proposalID, @proposalRequirementID, @isValid, @message, GETDATE(), CASE WHEN @aiPayload IS NOT NULL THEN 1 ELSE 0 END, @technicalDetails);

        -- Registrar validación en pv_workflowLogs para mayor trazabilidad
        INSERT INTO pv_workflowLogs (workflowInstanceID, userID, createdAt, workflowLogTypeID, message, description, detailsAI)
        VALUES (
            @workflowInstanceID,
            @reviewerID,
            GETDATE(),
            CASE WHEN @isValid = 1 THEN 3 ELSE 4 END, -- Completado o Error
            CASE WHEN @isValid = 1 THEN 'Validación completada' ELSE 'Validación fallida' END,
            @validationResult,
            @iapayloadProcessed
        );

        -- COMMIT TRANSACTION; -- Desactivado temporalmente para prueba
    END TRY
    BEGIN CATCH
        -- ROLLBACK TRANSACTION; -- Desactivado temporalmente para prueba
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50007, @ErrorMessage, 1;
    END CATCH;
END;
GO

-- Prueba 1 SP
EXEC [dbo].[revisarPropuesta]
    @proposalID = 1,
    @reviewerID = 1,
    @validationResult = 'aprobado',
    @aiPayload = 'Análisis de IA: Propuesta cumple con todos los criterios';


-- Prueba 2 SP
EXEC [dbo].[revisarPropuesta]
    @proposalID = 4,
    @reviewerID = 4,
    @validationResult = 'aprobado',
    @aiPayload = 'Evaluación de IA: Propuesta cumple requisitos técnicos y legales';




-- Verificar resultados



-- Verificación en pv_proposalCore

SELECT proposalID, status, lastUpdate FROM pv_proposalCore WHERE proposalID = 1;
SELECT proposalID, status, lastUpdate FROM pv_proposalCore WHERE proposalID = 2;
SELECT proposalID, status, lastUpdate FROM pv_proposalCore WHERE proposalID = 4;



-- Verificación en pv_proposalDocument

SELECT proposalID, validationStatusID, uploadDate FROM pv_proposalDocument WHERE proposalID = 1;
SELECT proposalID, validationStatusID, uploadDate FROM pv_proposalDocument WHERE proposalID = 3;
SELECT proposalID, validationStatusID, uploadDate FROM pv_proposalDocument WHERE proposalID = 4;



-- Verificación en pv_proposalValidation

SELECT proposalID, proposalRequirementID, result, message, validationDate, automaticSystem, technicalDetails
FROM pv_proposalValidation WHERE proposalID = 1 ORDER BY validationDate DESC;

SELECT proposalID, proposalRequirementID, result, message, validationDate, automaticSystem, technicalDetails
FROM pv_proposalValidation WHERE proposalID = 3 ORDER BY validationDate DESC;

SELECT proposalID, proposalRequirementID, result, message, validationDate, automaticSystem, technicalDetails
FROM pv_proposalValidation WHERE proposalID = 4 ORDER BY validationDate DESC;



-- Verificación en pv_workflowLogs
SELECT workflowInstanceID, userID, createdAt, workflowLogTypeID, message, description, detailsAI
FROM pv_workflowLogs
WHERE workflowInstanceID = (SELECT workFlowID FROM pv_workFlowsInstances WHERE proposalDocumentID = (SELECT TOP 1 proposalDocumentID FROM pv_proposalDocument WHERE proposalID = 1))
ORDER BY createdAt DESC;

SELECT workflowInstanceID, userID, createdAt, workflowLogTypeID, message, description, detailsAI
FROM pv_workflowLogs
WHERE workflowInstanceID = (SELECT workFlowID FROM pv_workFlowsInstances WHERE proposalDocumentID = (SELECT TOP 1 proposalDocumentID FROM pv_proposalDocument WHERE proposalID = 4))
ORDER BY createdAt DESC;