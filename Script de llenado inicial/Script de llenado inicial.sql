-- Script de llenado inicial

USE [Caso3DB];
GO

-- Insertar estados de cuenta
INSERT INTO [dbo].[pv_accountStatus] (code, name, description, isDefault, isActive, createdAt, updatedAt)
VALUES (1, 'Active', 'Usuario activo', 1, 1, '2025-06-01', '2025-06-05'), (2, 'Active', 'Usuario activo', 1, 1, '2025-06-02', '2025-06-05'), (3, 'Active', 'Usuario activo', 1, 1, '2025-06-03', '2025-06-05');

-- Insertar tipos de propuesta
INSERT INTO [dbo].[pv_proposalType] (propposalTypeID, name, description, applicationLevel, category, status, minimumRequirements, contentTemplate, version, lastUpdate)
VALUES (1, 'Proyecto Municipal', 'Infraestructura urbana', 'Local', 'Infraestructura', 'Activo', 'Documento tecnico', 'Planilla estandar', 1.0, '2025-06-01');

-- Insertar monedas
INSERT INTO [dbo].[pv_currencies] (currencyID, name, acronym, symbol, country)
VALUES (1, 'US Dollar', 'USD', '$', 'USA'), (2, 'Euro', 'EUR', '€', 'Alemania');

-- Insertar métodos de pago
INSERT INTO [dbo].[pv_paymentMethods] (name, methodType, config, status, createdAt, methodHash)
VALUES ('Credit Card', 'Tarjeta de crédito', CONVERT(VARBINARY(MAX), 'Configuracion segura'), 'Activo', '2025-01-01', NULL);

-- Insertar usuarios
INSERT INTO [dbo].[pv_users] (name, lastname, birthDate, registerDate, lastUpdate, accountStatusID, identityHash, password, failedAttempts, publicKey, privateKeyEncrypted)
VALUES 
    ('user1', 'Apellido1', '1985-05-05', '2025-01-10', '2025-06-01', 2, 'x7k9p2m4q8', CONVERT(VARBINARY(MAX), '123'), 1, CONVERT(VARBINARY(MAX), 'Llave1'), CONVERT(VARBINARY(MAX), 'LlaveEn1')),
    ('user2', 'Apellido2', '1985-05-06', '2025-01-11', '2025-06-02', 3, 'x7k9p2m4q1', CONVERT(VARBINARY(MAX), '123'), 0, CONVERT(VARBINARY(MAX), 'Llave2'), CONVERT(VARBINARY(MAX), 'LlaveEn1')),
    ('admin', 'Apellido3', '1985-05-07', '2025-01-12', '2025-06-03', 4, 'x7k9p2m4q2', CONVERT(VARBINARY(MAX), '123'), 1, CONVERT(VARBINARY(MAX), 'Llave3'), CONVERT(VARBINARY(MAX), 'LlaveEn3'));

	select * from pv_proposalType;
	select * from pv_propposals;
	select * from pv_users;
	select * from pv_groups;
	select * from pv_projectStatuses;
	select * from pv_projects;

-- Insertar propuestas
INSERT INTO [dbo].[pv_propposals] (proposalTypeID, name, userID, createdAt, lastUpdate, integrityHash)
VALUES 
    (1,'Proyecto Solar', 4, '2025-06-01', GETDATE(), CONVERT(VARBINARY(MAX), '123xhx')),
    (1,'Reforestación', 5, '2025-06-03', GETDATE(), CONVERT(VARBINARY(MAX), '123kdj'));

-- Insertar tipos de grupos de población meta
INSERT INTO [dbo].[pv_groupTypes] (name, isActive, createdAt, updatedtAt)
VALUES ('Tipo1', 1, GETDATE(), GETDATE());

-- Insertar estados de grupos de población meta
INSERT INTO [dbo].[pv_groupStatus] (name, isActive, createdAt, updatedAt)
VALUES ('Estado1', 1, GETDATE(), GETDATE());

-- Insertar estados de grupos de población meta
INSERT INTO [dbo].[pv_groupVisibilities] (code, name, isActive, createdAt)
VALUES ('123', 'GrupoVisible1', 1, GETDATE());


-- Insertar grupos de población meta
INSERT INTO [dbo].[pv_groups] (name, description, groupTypeID, createdAt, userID, groupStatusID, groupVisibilityID, maxMembers)
VALUES ('Asociacion ecologica', 'Grupo ambiental', 1, GETDATE(), 4, 1, 1, 23);

INSERT INTO [dbo].[pv_proposalTargetGroups] (proposalID, groupID, createdAt)
VALUES (1, 3, GETDATE()), (2, 3, GETDATE());

INSERT INTO [dbo].[pv_projectStatuses] (name, isActive, createdAt, updatedAt)
VALUES ('Estado1', 1, GETDATE(), GETDATE());

INSERT INTO [dbo].[pv_projects] (
    title,
    summary,
    fullDescription,
    userID,
    createdAt,
    projectStatusID,
    requestedAmount,
    currencyID,
    expectedStartDate,
    endDate,
    configuration,
    expectedDuration,
    checksum
) VALUES (
    'Desarrollo de Aplicación Móvil',  -- title
    'Aplicación para gestión de proyectos con funciones colaborativas',  -- summary
    'Este proyecto busca desarrollar una aplicación móvil multiplataforma que permita a equipos gestionar proyectos, asignar tareas y colaborar en tiempo real. Incluirá integración con herramientas populares y sistema de notificaciones.',  -- fullDescription
    5,  -- usenID (FK, probablemente usuario)
    '2023-05-01',  -- createdAt
    1,  -- projectStatusID (FK, ej. 3=En progreso)
    15000.00,  -- requestedAmount
    1,  -- currencyID (FK, ej. 1=USD)
    '2023-06-01',  -- expectedStartDate
    '2023-12-02',  -- endDate
    NULL,  -- configuration (varbinary)
    180.5,  -- expectedDuration (en días?)
    NULL  -- checksum
);

-- Insertar reglas de votación (simples para pruebas)
INSERT INTO [dbo].[pv_votings] (proposalID, status, configurationHash, createdAt, userID, quorum, projectID)
VALUES (1, 'En progreso', CONVERT(VARBINARY(MAX), 'c7k9p2m'), GETDATE(), 5, 1, 5);


INSERT INTO [dbo].[pv_votingRuleTypes] (code, name, description, isActive, createdAt, updatedAt)
VALUES ('001', 'Regla1', 'Esta es una regla de votacion', 1, GETDATE(), GETDATE());

INSERT INTO [dbo].[pv_votingRules] (name, description, ruleType, value, createdAt, status)
VALUES ('Quorum', '100 votos minimos', 1, '100', GETDATE(), 'Activo');