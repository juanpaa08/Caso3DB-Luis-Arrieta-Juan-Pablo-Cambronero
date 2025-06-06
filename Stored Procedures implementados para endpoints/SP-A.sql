USE [Caso3DB];
GO

CREATE PROCEDURE [dbo].[crearActualizarPropuesta]
    @proposalID INT = NULL, -- NULL para crear, ID para actualizar
    @userID INT, -- ID del usuario que crea/actualiza
    @title NVARCHAR(255), -- Título de la propuesta
    @description NVARCHAR(MAX), -- Descripción
    @targetPopulation NVARCHAR(255), -- Población meta (edad, grupo, región)
    @fileData VARBINARY(MAX) = NULL, -- Archivo adjunto
    @statusID INT -- Estado inicial (pendiente de validación)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aquí iría la lógica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO