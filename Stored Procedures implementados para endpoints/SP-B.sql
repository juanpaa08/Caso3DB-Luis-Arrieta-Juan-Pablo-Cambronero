USE [Caso3DB];
GO

CREATE OR ALTER PROCEDURE [dbo].[revisarPropuesta]
    @ProposalID INT,
    @ReviewerID INT,
    @ValidationResult NVARCHAR(255),
    @AIPayload NVARCHAR(MAX) = NULL,
    @Status NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TransactionCountOnEntry INT = @@TRANCOUNT;
    DECLARE @ProposalTypeID INT;
    DECLARE @MinimumRequirements NVARCHAR(MAX);
    DECLARE @CurrentDate DATETIME = GETDATE(); -- 2025-06-12 11:23 AM CST
    DECLARE @DocumentID INT;
    DECLARE @WorkflowInstanceID INT; -- Usar workFlowID como INT
    DECLARE @IsValid BIT;

    BEGIN TRY
        -- Iniciar transacción si no existe una
        IF @TransactionCountOnEntry = 0
            BEGIN TRANSACTION;

        PRINT 'Paso 1: Verificando existencia de la propuesta';
        -- Validar que la propuesta existe
        IF NOT EXISTS (SELECT 1 FROM [dbo].[pv_propposals] WHERE proposalID = @ProposalID)
        BEGIN
            SET @Status = 'Error: Propuesta no encontrada';
            PRINT 'Error: Propuesta ID ' + CAST(@ProposalID AS NVARCHAR(10)) + ' no encontrada';
            IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            RETURN;
        END
        PRINT 'Paso 2: Propuesta encontrada';

        -- Consultar tipo de propuesta y criterios de validación
        PRINT 'Paso 3: Consultando tipo y criterios de validación';
        SELECT @ProposalTypeID = proposalTypeID, @MinimumRequirements = minimumRequirements
        FROM [dbo].[pv_propposals] p
        JOIN [dbo].[pv_proposalType] pt ON p.proposalTypeID = pt.propposalTypeID
        WHERE p.proposalID = @ProposalID;
        PRINT 'Paso 4: Tipo de propuesta ID = ' + CAST(@ProposalTypeID AS NVARCHAR(10)) + ', Requisitos = ' + @MinimumRequirements;

        -- Preparar payloads esperados para validación por IA/LLM
        PRINT 'Paso 5: Preparando payload para IA';
        DECLARE @IAPayloadProcessed NVARCHAR(MAX) = @AIPayload;
        IF @IAPayloadProcessed IS NULL
            SET @IAPayloadProcessed = '{"proposalID": ' + CAST(@ProposalID AS NVARCHAR(10)) + ', "requirements": "' + @MinimumRequirements + '"}';
        PRINT 'Paso 6: Payload procesado = ' + @IAPayloadProcessed;

        -- Obtener el ID del documento asociado (usar TOP 1 para el primer documento)
        PRINT 'Paso 7: Obteniendo ID del documento';
        SELECT TOP 1 @DocumentID = proposalDocumentID 
        FROM [dbo].[pv_proposalDocument] 
        WHERE proposalID = @ProposalID;
        IF @DocumentID IS NULL
        BEGIN
            SET @Status = 'Error: No se encontró documento para la propuesta';
            PRINT 'Error: No se encontró documento para proposalID = ' + CAST(@ProposalID AS NVARCHAR(10));
            IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            RETURN;
        END
        PRINT 'Paso 8: Documento ID = ' + CAST(@DocumentID AS NVARCHAR(10));

        -- Obtener el workFlowID asociado
        PRINT 'Paso 9: Obteniendo workFlowID';
        SELECT @WorkflowInstanceID = workFlowID 
        FROM [dbo].[pv_workFlowsInstances] 
        WHERE proposalDocumentID = @DocumentID;
        IF @WorkflowInstanceID IS NULL
        BEGIN
            SET @Status = 'Error: No se encontró instancia de workflow para el documento';
            PRINT 'Error: No se encontró workFlowID para documentID = ' + CAST(@DocumentID AS NVARCHAR(10));
            IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            RETURN;
        END
        PRINT 'Paso 10: workFlowID = ' + CAST(@WorkflowInstanceID AS NVARCHAR(10));

        -- Procesar validación automática basada en documentos existentes
        PRINT 'Paso 11: Procesando validación';
        SET @IsValid = CASE 
            WHEN @ValidationResult = 'Approved' AND EXISTS (
                SELECT 1 FROM [dbo].[pv_proposalDocument] pd
                JOIN [dbo].[pv_validationStatus] vs ON pd.validationStatusID = vs.validationStatusID
                WHERE pd.proposalID = @ProposalID AND vs.code = 'APRV'
            ) THEN 1
            ELSE 0
        END;
        PRINT 'Paso 12: Validación result = ' + CAST(@IsValid AS NVARCHAR(1));

        -- Actualizar lastUpdate como indicación de revisión
        PRINT 'Paso 13: Actualizando lastUpdate';
        UPDATE [dbo].[pv_propposals]
        SET lastUpdate = @CurrentDate
        WHERE proposalID = @ProposalID;
        PRINT 'Paso 14: lastUpdate actualizado';

        -- Registrar validación en los logs con trazabilidad
        PRINT 'Paso 15: Registrando validación en logs';
        INSERT INTO [dbo].[pv_workflowLogs] (workflowInstanceID, userID, createdAt, workflowLogTypeID, message, description, detailsAI)
        VALUES (
            @WorkflowInstanceID, -- Usar workFlowID como workflowInstanceID
            @ReviewerID,
            @CurrentDate,
            CASE WHEN @IsValid = 1 THEN 3 ELSE 4 END, -- Completado o Error
            CASE WHEN @IsValid = 1 THEN 'Validación completada' ELSE 'Validación fallida' END,
            @ValidationResult,
            @IAPayloadProcessed
        );
        PRINT 'Paso 16: Validación registrada';

        -- Actualizar estado de validación en documentos
        PRINT 'Paso 17: Actualizando estado de validación en documentos';
        UPDATE [dbo].[pv_proposalDocument]
        SET validationStatusID = (SELECT validationStatusID FROM [dbo].[pv_validationStatus] WHERE code = CASE WHEN @IsValid = 1 THEN 'APRV' ELSE 'REJ' END)
        WHERE proposalID = @ProposalID;
        PRINT 'Paso 18: Estado de documento actualizado';

        -- Devolver resultado
        PRINT 'Paso 19: Devolviendo resultado';
        SET @Status = CASE WHEN @IsValid = 1 THEN 'Aprobada' ELSE 'Rechazada' END;
        PRINT 'Paso 20: Resultado = ' + @Status;

        -- Confirmar transacción si se inició
        IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Manejar rollback en caso de error
        PRINT 'Paso Error: ' + ERROR_MESSAGE();
        IF @TransactionCountOnEntry = 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        ELSE IF @TransactionCountOnEntry > 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION revisarPropuesta;

        SET @Status = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Ejecutar el procedimiento para probarlo con un ejemplo
DECLARE @ResultStatus NVARCHAR(50);
EXEC [dbo].[revisarPropuesta] 
    @ProposalID = 1,
    @ReviewerID = 1,
    @ValidationResult = 'Approved',
    @AIPayload = NULL,
    @Status = @ResultStatus OUTPUT;
SELECT @ResultStatus AS Resultado;


