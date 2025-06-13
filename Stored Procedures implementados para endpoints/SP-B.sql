USE [Caso3DB];
GO

CREATE PROCEDURE [dbo].[revisarPropuesta]
    @proposalID INT, -- ID de la propuesta a revisar
    @reviewerID INT, -- ID del revisor
    @validationResult NVARCHAR(255), -- Resultado de la validaci�n (aprobado/rechazado)
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
            THROW 50003, 'No se encontr� el n�cleo de la propuesta.', 1;

        -- Consultar tipo de propuesta y criterios de validaci�n
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
            THROW 50005, 'No se encontr� documento para la propuesta.', 1;

        -- Obtener el workflowInstanceID asociado
        DECLARE @workflowInstanceID INT;
        SELECT @workflowInstanceID = workFlowID 
        FROM pv_workFlowsInstances 
        WHERE proposalDocumentID = @documentID;
        IF @workflowInstanceID IS NULL
            THROW 50006, 'No se encontr� instancia de workflow para el documento.', 1;

        -- Preparar payloads esperados para validaci�n por IA/LLM
        DECLARE @iapayloadProcessed NVARCHAR(MAX) = ISNULL(@aiPayload, '{"proposalID": ' + CAST(@proposalID AS NVARCHAR(10)) + ', "requirements": "' + ISNULL(@minimumRequirements, 'Sin requisitos') + '"}');

        -- Procesar validaci�n autom�tica basada en documentos existentes
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

        -- Actualizar estado de validaci�n en documentos
        UPDATE pv_proposalDocument
        SET validationStatusID = (SELECT validationStatusID FROM pv_validationStatus WHERE code = CASE WHEN @isValid = 1 THEN 'APRV' ELSE 'REJ' END)
        WHERE proposalID = @proposalID;

        -- Preparar valores para pv_proposalValidation (ning�n campo nulo)
        DECLARE @message NVARCHAR(200) = ISNULL('Validaci�n por usuario ' + CAST(@reviewerID AS NVARCHAR(10)) + ': ' + @validationResult, 'Validaci�n sin resultado');
        DECLARE @technicalDetails NVARCHAR(MAX) = ISNULL('Payload procesado: ' + @iapayloadProcessed + ' - ' + CAST(GETDATE() AS NVARCHAR(30)), 'Validaci�n manual - ' + CAST(GETDATE() AS NVARCHAR(30)));
        DECLARE @proposalRequirementID INT = 1; -- Valor predeterminado hasta que se defina una tabla de requisitos

        -- Registrar validaci�n en pv_proposalValidation
        INSERT INTO pv_proposalValidation (proposalID, proposalRequirementID, result, message, validationDate, automaticSystem, technicalDetails)
        VALUES (@proposalID, @proposalRequirementID, @isValid, @message, GETDATE(), CASE WHEN @aiPayload IS NOT NULL THEN 1 ELSE 0 END, @technicalDetails);

        -- Registrar validaci�n en pv_workflowLogs para mayor trazabilidad
        INSERT INTO pv_workflowLogs (workflowInstanceID, userID, createdAt, workflowLogTypeID, message, description, detailsAI)
        VALUES (
            @workflowInstanceID,
            @reviewerID,
            GETDATE(),
            CASE WHEN @isValid = 1 THEN 3 ELSE 4 END, -- Completado o Error
            CASE WHEN @isValid = 1 THEN 'Validaci�n completada' ELSE 'Validaci�n fallida' END,
            @validationResult,
            @iapayloadProcessed
        );

        -- Confirmar transacci�n
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Revertir transacci�n en caso de error
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
    @aiPayload = 'An�lisis de IA: Propuesta cumple con todos los criterios';



SELECT * FROM pv_proposalValidation WHERE proposalID = 1 ORDER BY validationDate DESC;
SELECT proposalID, status, lastUpdate FROM pv_proposalCore WHERE proposalID = 1;
SELECT * FROM pv_workflowLogs WHERE workflowInstanceID = (SELECT workFlowID FROM pv_workFlowsInstances WHERE proposalDocumentID = (SELECT TOP 1 proposalDocumentID FROM pv_proposalDocument WHERE proposalID = 1)) ORDER BY createdAt DESC;
