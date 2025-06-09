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

-- Insertar PaymentMethods
INSERT INTO dbo.pv_paymentMethods
  (
    name,
    secretKey,
    [key],
    apiURL,
    logoURL,
    configJSON,
    lastUpdated,
    enabled
  )
VALUES
  (
    -- Nombre legible
    N'Credit Card',

    -- Clave secreta (20 chars max)
    N'SECRETKEY_123456789',

    -- API-Key cifrada/convertida a varbinary
    CONVERT(varbinary(250), N'APIKEY_ABCDEFG12345'),

    -- URL de tu servicio (rellena hasta 20 chars)
    N'https://api.pay/v1',

    -- Fecha de “logo” (tal y como tienes definido datetime)
    '2025-06-10',

    -- Configuración en JSON convertida a varbinary
    CONVERT(varbinary(250), N'{"merchantId":"M123","currency":"USD"}'),

    -- Última actualización
    GETDATE(),

    -- 1 = habilitado, 0 = deshabilitado
    1
  );

-- Insertar usuarios
INSERT INTO [dbo].[pv_users] (name, lastname, birthDate, registerDate, lastUpdate, accountStatusID, identityHash, password, failedAttempts, publicKey, privateKeyEncrypted)
VALUES 
	('user1', 'Apellido1', '1985-05-05', '2025-01-10', '2025-06-01', 1, 'x7k9p2m4q8', CONVERT(VARBINARY(MAX), '123'), 1, CONVERT(VARBINARY(MAX), 'Llave1'), CONVERT(VARBINARY(MAX), 'LlaveEn1')),
    ('user2', 'Apellido2', '1985-05-06', '2025-01-11', '2025-06-02', 2, 'x7k9p2m4q1', CONVERT(VARBINARY(MAX), '123'), 0, CONVERT(VARBINARY(MAX), 'Llave2'), CONVERT(VARBINARY(MAX), 'LlaveEn1')),
    ('admin', 'Apellido3', '1985-05-07', '2025-01-12', '2025-06-03', 2, 'x7k9p2m4q2', CONVERT(VARBINARY(MAX), '123'), 1, CONVERT(VARBINARY(MAX), 'Llave3'), CONVERT(VARBINARY(MAX), 'LlaveEn3')),
    ('user3', 'Apellido4', GETDATE(), GETDATE(), GETDATE(), 1, 'x7k9p2m4q3', CONVERT(VARBINARY(MAX), '123'), 0, CONVERT(VARBINARY(MAX), 'Llave4'), CONVERT(VARBINARY(MAX), 'LlaveEn4')),
    ('user4', 'Apellido5', GETDATE(), GETDATE(), GETDATE(), 2, 'x7k9p2m4q4', CONVERT(VARBINARY(MAX), '123'), 1, CONVERT(VARBINARY(MAX), 'Llave5'), CONVERT(VARBINARY(MAX), 'LlaveEn5')),
    ('user5', 'Apellido6', GETDATE(), GETDATE(), GETDATE(), 3, 'x7k9p2m4q5', CONVERT(VARBINARY(MAX), '123'), 0, CONVERT(VARBINARY(MAX), 'Llave6'), CONVERT(VARBINARY(MAX), 'LlaveEn6'));

	DBCC CHECKIDENT (pv_users, RESEED, 0);
	

	select * from pv_accountStatus;
	select * from pv_proposalType;
	select * from pv_currencies;
	select * from pv_paymentMethods;
	select * from pv_propposals;
	select * from pv_users;
	select * from pv_groupTypes;
	select * from pv_groups;
	select * from pv_projectStatuses;
	select * from pv_projects;
	select * from [dbo].[pv_dataTypes];
	SELECT * FROM [dbo].[pv_userDemographicTypes];
	select * from pv_userDemographics;
	select * from pv_proposalTargetGroups;
	select * from pv_projectMilestones;




-- Insertar tipos de datos
INSERT INTO [dbo].[pv_dataTypes] (code, name, description, createdAt)
VALUES
    ('STR', 'String', 'Tipo de dato de texto', '2025-06-01'),
    ('NUM', 'Numeric', 'Tipo de dato numérico', '2025-06-01'),
    ('DAT', 'Date', 'Tipo de dato fecha', '2025-06-01'),
    ('BOL', 'Boolean', 'Tipo de dato booleano', '2025-06-01');

-- Insertar tipos de datos demográficos
INSERT INTO [dbo].[pv_userDemographicTypes] (name, dataTypeID, description, isActive)
VALUES
    ('Edad', 2, 'Rango de edad del usuario', 1), -- Numeric
    ('Sexo', 1, 'Género del usuario', 1),        -- String
    ('Región', 1, 'Región geográfica del usuario', 1); -- String


-- Insertar datos demográficos para los usuarios
INSERT INTO dbo.pv_userDemographics (userID, userDemographicTypeID, value)
VALUES
  -- user1 (userID = 1)
  (1, 1, N'Masculino'),  -- Sexo
  (1, 2, N'35'),         -- Edad
  (1, 3, N'San José'),   -- Región

  -- user2 (userID = 2)
  (2, 1, N'Femenino'),   -- Sexo
  (2, 2, N'40'),         -- Edad
  (2, 3, N'Alajuela'),   -- Región

  -- admin (userID = 3)
  (3, 1, N'Masculino'),  -- Sexo
  (3, 2, N'45'),         -- Edad
  (3, 3, N'Heredia'),    -- Región

  -- user3 (userID = 4)
  (4, 1, N'Femenino'),   -- Sexo
  (4, 2, N'30'),         -- Edad
  (4, 3, N'Cartago'),    -- Región

  -- user4 (userID = 5)
  (5, 1, N'Masculino'),  -- Sexo
  (5, 2, N'50'),         -- Edad
  (5, 3, N'Guanacaste'), -- Región

  -- user5 (userID = 6)
  (6, 1, N'Femenino'),   -- Sexo
  (6, 2, N'25'),         -- Edad
  (6, 3, N'Puntarenas'); -- Región


-- Insertar propuestas
INSERT INTO [dbo].[pv_propposals] (proposalTypeID, name, userID, createdAt, lastUpdate, integrityHash)
VALUES 
    (1,'Proyecto Solar', 1, '2025-06-01', GETDATE(), CONVERT(VARBINARY(MAX), '123xhx')),
    (1,'Reforestación', 2, '2025-06-03', GETDATE(), CONVERT(VARBINARY(MAX), '123kdj'));


-- Insertar tipos de grupos de población meta
INSERT INTO [dbo].[pv_groupTypes] (name, isActive)
VALUES ('Tipo1', 1);



-- Insertar grupos de población meta
INSERT INTO dbo.pv_groups
  (name, groupTypeID, createdAt, isActive)
VALUES
  (N'Asociacion ecologica', 1,   GETDATE(),       1);


INSERT INTO [dbo].[pv_proposalTargetGroups] (proposalID, groupID, createdAt)
VALUES (1, 1, GETDATE()), (2, 1, GETDATE());

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
) VALUES 
(
    'Desarrollo de Aplicación Móvil',  -- title
    'Aplicación para gestión de proyectos con funciones colaborativas',  -- summary
    'Este proyecto busca desarrollar una aplicación móvil multiplataforma que permita a equipos gestionar proyectos, asignar tareas y colaborar en tiempo real. Incluirá integración con herramientas populares y sistema de notificaciones.',  -- fullDescription
    2,  -- usenID (FK, probablemente usuario)
    '2023-05-01',  -- createdAt
    1,  -- projectStatusID (FK, ej. 3=En progreso)
    15000.00,  -- requestedAmount
    1,  -- currencyID (FK, ej. 1=USD)
    '2023-06-01',  -- expectedStartDate
    '2023-12-02',  -- endDate
    NULL,  -- configuration (varbinary)
    180.5,  -- expectedDuration (en días?)
    NULL  -- checksum
),
(
    'Plataforma de Crowdfunding', 
    'Plataforma para financiar proyectos comunitarios', 
    'Desarrollo de una plataforma para recaudar fondos de manera transparente.', 
    2, '2025-06-01', 1, 20000.00, 1, '2025-07-01', '2025-12-02', NULL, 180.0, NULL
);


-- Insertar hitos para pv_projectMilestones
INSERT INTO [dbo].[pv_projectMilestones] (
    projectID, title, description, assignedBudget, currencyCode, startDate, dueDate, actualCloseDate, 
    createdAt, updatedAt, expectedDuration, checksum, projectStatusID
)
VALUES
    -- Hitos para proyecto 1 (Desarrollo de Aplicación Móvil, projectID = 1)
    (1, 'Planificación', 'Diseño inicial del proyecto', 3000.00, 'USD',  GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(), 30.0, CONVERT(VARBINARY(MAX), 'chk1'), 1),
    (1, 'Recaudación de fondos', 'Campaña de crowdfunding', 8000.00, 'USD', GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(), 90.0, CONVERT(VARBINARY(MAX), 'chk2'), 1),
    (1, 'Desarrollo', 'Implementación de la aplicación', 4000.00, 'USD', GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(), 90.0, CONVERT(VARBINARY(MAX), 'chk3'), 1),

    -- Hitos para proyecto 2 (Plataforma de Crowdfunding, projectID = 2, asumimos que es el ID asignado al nuevo proyecto)
    (2, 'Análisis de requisitos', 'Definición de necesidades', 4000.00, 'USD', GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(), 30.0, CONVERT(VARBINARY(MAX), 'chk4'), 1),
    (2, 'Recaudación inicial', 'Primera fase de financiación', 6000.00, 'USD', GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(), 60.0, CONVERT(VARBINARY(MAX), 'chk5'), 1),
    (2, 'Desarrollo de plataforma', 'Construcción de la infraestructura', 2000.00, 'USD', GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(),  GETDATE(), 90.0, CONVERT(VARBINARY(MAX), 'chk6'), 1);

-- Verificar datos
SELECT * FROM [dbo].[pv_projectMilestones];

-- Insertar votación (simples para pruebas)
INSERT INTO [dbo].[pv_votings] (proposalID, status, configurationHash, createdAt, quorum, projectID)
VALUES
    (1, 'Finalizado', CONVERT(VARBINARY(MAX), 'c7k9p2m1'), '2025-06-06 10:00:00', 1, 1),
    (2, 'Finalizado', CONVERT(VARBINARY(MAX), 'c7k9p2m2'), '2025-06-05 14:30:00', 1, 1),
    (1, 'Finalizado', CONVERT(VARBINARY(MAX), 'c7k9p2m3'), '2025-06-04 09:15:00', 1, 1),
    (2, 'Finalizado', CONVERT(VARBINARY(MAX), 'c7k9p2m4'), '2025-06-03 16:45:00', 1, 1),
    (1, 'Finalizado', CONVERT(VARBINARY(MAX), 'c7k9p2m5'), '2025-06-02 12:00:00', 1, 1);

	select * from pv_votings;


-- Insertar datos en pv_votingResult
INSERT INTO [dbo].[pv_votingResult] (
    votingID, totalVotes, totalValids, winningOption, approvalPorcentage, quorumMeet, closingDate, status, resultHash
)
VALUES
    -- Resultado para votingID 1 (Proyecto Solar, 2025-06-06)
    (1, 80, 75, 'Sí', 66.67, 1, '2025-06-06 12:00:00', 'Finalizado', CONVERT(VARBINARY(MAX), 'hash1x7k9')),
    -- Resultado para votingID 2 (Reforestación, 2025-06-05)
    (2, 60, 58, 'A favor', 68.97, 1, '2025-06-05 16:00:00', 'Finalizado', CONVERT(VARBINARY(MAX), 'hash2x7k9')),
    -- Resultado para votingID 3 (Proyecto Solar, 2025-06-04)
    (3, 70, 65, 'Sí', 92.31, 1, '2025-06-04 11:00:00', 'Finalizado', CONVERT(VARBINARY(MAX), 'hash3x7k9')),
    -- Resultado para votingID 4 (Reforestación, 2025-06-03)
    (4, 50, 48, 'A favor', 72.92, 0, '2025-06-03 18:00:00', 'Finalizado', CONVERT(VARBINARY(MAX), 'hash4x7k9')),
    -- Resultado para votingID 5 (Proyecto Solar, 2025-06-02)
    (5, 70, 67, 'No', 37.31, 1, '2025-06-02 14:00:00', 'Finalizado', CONVERT(VARBINARY(MAX), 'hash5x7k9'));

-- Verificar los datos insertados
SELECT * FROM [dbo].[pv_votingResult];

SELECT * FROM pv_votingResult ORDER BY closingDate DESC;