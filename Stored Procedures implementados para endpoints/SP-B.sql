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
    
    -- Aqu� ir�a la l�gica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO
