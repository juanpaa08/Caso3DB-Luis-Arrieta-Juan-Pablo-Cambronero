USE [Caso3DB];
GO

CREATE PROCEDURE [dbo].[invertir]
    @proposalID INT, -- ID de la propuesta
    @userID INT, -- ID del inversionista
    @amount DECIMAL(18,2), -- Monto invertido
    @paymentMethodID INT -- Método de pago
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aquí iría la lógica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO
