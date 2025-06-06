USE [Caso3DB];
GO

CREATE PROCEDURE [dbo].[crearActualizarPropuesta]
    @proposalID INT = NULL, -- NULL para crear, ID para actualizar
    @userID INT, -- ID del usuario que crea/actualiza
    @title NVARCHAR(255), -- T�tulo de la propuesta
    @description NVARCHAR(MAX), -- Descripci�n
    @targetPopulation NVARCHAR(255), -- Poblaci�n meta (edad, grupo, regi�n)
    @fileData VARBINARY(MAX) = NULL, -- Archivo adjunto
    @statusID INT -- Estado inicial (pendiente de validaci�n)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aqu� ir�a la l�gica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO