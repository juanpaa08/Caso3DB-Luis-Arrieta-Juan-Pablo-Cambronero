USE [Caso3DB];
GO

CREATE PROCEDURE [dbo].[invertir]
    @proposalID INT, -- ID de la propuesta
    @userID INT, -- ID del inversionista
    @amount DECIMAL(18,2), -- Monto invertido
    @paymentMethodID INT -- M�todo de pago
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aqu� ir�a la l�gica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO
