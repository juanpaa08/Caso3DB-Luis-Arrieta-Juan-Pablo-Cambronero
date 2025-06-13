USE [Caso3DB];
GO

CREATE PROCEDURE [dbo].[revisarPropuesta]
    @proposalID INT, -- ID de la propuesta a revisar
    @reviewerID INT, -- ID del revisor
    @validationResult NVARCHAR(255), -- Resultado de la validación (aprobado/rechazado)
    @aiPayload NVARCHAR(MAX) = NULL -- Payload para IA (opcional)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar existencia de proposalID y reviewerID
        IF NOT EXISTS (SELECT 1 FROM pv_propposals WHERE proposalID = @proposalID)
            THROW 50001, 'Propuesta no encontrada.', 1;
        IF NOT EXISTS (SELECT 1 FROM pv_users WHERE userID = @reviewerID)
            THROW 50002, 'Revisor no encontrado.', 1;

        -- Verificar que exista el proposalCore asociado
        IF NOT EXISTS (SELECT 1 FROM pv_proposalCore WHERE proposalID = @proposalID)
            THROW 50003, 'No se encontró el núcleo de la propuesta.', 1;

        -- Consultar tipo de propuesta y criterios de validación
        DECLARE @proposalTypeID INT;
        DECLARE @minimumRequirements NVARCHAR(MAX);
        SELECT @proposalTypeID = p.proposalTypeID, @minimumRequirements = pt.minimumRequirements
        FROM pv_propposals p
        JOIN pv_proposalType pt ON p.proposalTypeID = pt.propposalTypeID
        WHERE p.proposalID = @proposalID;

        IF @proposalTypeID IS NULL
            THROW 50004, 'Tipo de propuesta no definido.', 1;

        -- Obtener el ID del documento asociado (usar TOP 1 para el primer documento)
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

        -- Preparar payloads esperados para validación por IA/LLM
        DECLARE @iapayloadProcessed NVARCHAR(MAX) = ISNULL(@aiPayload, '{"proposalID": ' + CAST(@proposalID AS NVARCHAR(10)) + ', "requirements": "' + ISNULL(@minimumRequirements, 'Sin requisitos') + '"}');

        -- Procesar validación automática basada en documentos existentes
        DECLARE @isValid BIT = CASE 
            WHEN @validationResult = 'aprobado' AND EXISTS (
                SELECT 1 FROM pv_proposalDocument pd
                JOIN pv_validationStatus vs ON pd.validationStatusID = vs.validationStatusID
                WHERE pd.proposalID = @proposalID AND vs.code = 'APRV'
            ) THEN 1
            ELSE 0
        END;

        -- Actualizar estado en pv_proposalCore
        DECLARE @newStatus NVARCHAR(20) = CASE WHEN @isValid = 1 THEN '1' ELSE '0' END; -- '1' para activa, '0' para bloqueada
        UPDATE pv_proposalCore
        SET status = @newStatus,
            lastUpdate = GETDATE()
        WHERE proposalID = @proposalID;

        -- Actualizar estado de validación en documentos
        UPDATE pv_proposalDocument
        SET validationStatusID = (SELECT validationStatusID FROM pv_validationStatus WHERE code = CASE WHEN @isValid = 1 THEN 'APRV' ELSE 'REJ' END)
        WHERE proposalID = @proposalID;

        -- Preparar valores para pv_proposalValidation (ningún campo nulo)
        DECLARE @message NVARCHAR(200) = ISNULL('Validación por usuario ' + CAST(@reviewerID AS NVARCHAR(10)) + ': ' + @validationResult, 'Validación sin resultado');
        DECLARE @technicalDetails NVARCHAR(MAX) = ISNULL('Payload procesado: ' + @iapayloadProcessed + ' - ' + CAST(GETDATE() AS NVARCHAR(30)), 'Validación manual - ' + CAST(GETDATE() AS NVARCHAR(30)));
        DECLARE @proposalRequirementID INT = 1; -- Valor predeterminado hasta que se defina una tabla de requisitos

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

        -- Confirmar transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Revertir transacción en caso de error
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50007, @ErrorMessage, 1;
    END CATCH;
END;
GO

EXEC [dbo].[revisarPropuesta]
    @proposalID = 1,
    @reviewerID = 1,
    @validationResult = 'aprobado',
    @aiPayload = 'Análisis de IA: Propuesta cumple con todos los criterios';



SELECT * FROM pv_proposalValidation WHERE proposalID = 1 ORDER BY validationDate DESC;
SELECT proposalID, status, lastUpdate FROM pv_proposalCore WHERE proposalID = 1;
SELECT * FROM pv_workflowLogs WHERE workflowInstanceID = (SELECT workFlowID FROM pv_workFlowsInstances WHERE proposalDocumentID = (SELECT TOP 1 proposalDocumentID FROM pv_proposalDocument WHERE proposalID = 1)) ORDER BY createdAt DESC;
