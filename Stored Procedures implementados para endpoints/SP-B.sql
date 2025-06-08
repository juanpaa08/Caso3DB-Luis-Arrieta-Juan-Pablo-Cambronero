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
    
    -- Aquí iría la lógica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO
