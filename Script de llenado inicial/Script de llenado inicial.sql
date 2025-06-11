-- Script de llenado

USE [Caso3DB];
GO

-- Insertar estados de cuenta
INSERT INTO [dbo].[pv_accountStatus] (code, name, description, isDefault, isActive, createdAt, updatedAt)
VALUES 
    (1, 'Active', 'Usuario activo y autorizado con acceso completo al sistema', 1, 1, '2025-06-01 09:00:00', '2025-06-10 11:38:00'),
    (2, 'Inactive', 'Usuario temporalmente inactivo por inactividad prolongada', 0, 0, '2025-06-02 09:00:00', '2025-06-10 11:38:00'),
    (3, 'Pending', 'Usuario en proceso de verificación de identidad y documentos', 0, 1, '2025-06-03 09:00:00', '2025-06-10 11:38:00');


-- Insertar tipos de propuesta
INSERT INTO [dbo].[pv_proposalType] (propposalTypeID, name, description, applicationLevel, category, status, minimumRequirements, contentTemplate, version, lastUpdate)
VALUES 
    (1, 'Proyecto Municipal', 'Infraestructura urbana y servicios comunitarios', 'Local', 'Infraestructura', 'Activo', 'Plan técnico, presupuesto y permisos municipales', 'Plantilla estándar municipal', 1.0, '2025-06-10 11:38:00'),
    (2, 'Emprendimiento', 'Iniciativas de negocio innovadoras con enfoque sostenible', 'Nacional', 'Economía', 'Activo', 'Plan de negocio, análisis de mercado', 'Plantilla emprendedora avanzada', 1.1, '2025-06-10 11:38:00'),
    (3, 'Investigación Académica', 'Estudios científicos o tecnológicos con impacto social', 'Nacional', 'Educación', 'Activo', 'Propuesta de investigación, bibliografía', 'Plantilla académica detallada', 1.2, '2025-06-10 11:38:00'),
    (4, 'Iniciativa Cultural', 'Proyectos artísticos y culturales con alcance regional', 'Regional', 'Cultura', 'Activo', 'Presupuesto, cronograma y artistas', 'Plantilla cultural completa', 1.0, '2025-06-10 11:38:00'),
    (5, 'Desarrollo Tecnológico', 'Innovaciones tecnológicas con prototipo funcional', 'Global', 'Tecnología', 'Activo', 'Prototipo, plan técnico y patente', 'Plantilla tecnológica avanzada', 1.3, '2025-06-10 11:38:00');
	

-- Insertar monedas
INSERT INTO [dbo].[pv_currencies] (currencyID, name, acronym, symbol, country)
VALUES 
    (1, 'US Dollar', 'USD', '$', 'United States'),
    (2, 'Costa Rican Colón', 'CRC', '₡', 'Costa Rica'),
    (3, 'Euro', 'EUR', '€', 'European Union');


-- Insertar métodos de pago
INSERT INTO [dbo].[pv_paymentMethods] (name, secretKey, [key], apiURL, logoURL, configJSON, lastUpdated, enabled)
VALUES 
    ('Credit Card', 'SECKEY_1234567890', CONVERT(varbinary(512), 'APIKEY_CREDIT_12345'), 'https://api.paypal', GETDATE(), CONVERT(varbinary(512), '{"merchantId":"M123","currency":"USD"}'), GETDATE(), 1),
    ('Bank Transfer', 'SECKEY_BNK987654321', CONVERT(varbinary(512), 'APIKEY_BANK_54321'), 'https://api.banktr', GETDATE(), CONVERT(varbinary(512), '{"account":"ACC123"}'), GETDATE(), 1);


-- Procedimiento para insertar usuarios (50 usuarios)
CREATE PROCEDURE [dbo].[sp_SeedUsers]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 1;
    WHILE @i <= 50
    BEGIN
        INSERT INTO [dbo].[pv_users] (name, lastName, birthDate, registerDate, lastUpdate, accountStatusID, identityHash, password, failedAttempts, publicKey, privateKeyEncrypted)
        VALUES 
            ('Usuario' + CAST(@i AS NVARCHAR(3)), 'Apellido' + CAST(@i AS NVARCHAR(3)), DATEADD(year, -RAND() * 40 - 20, '2025-06-10'), 
             DATEADD(day, -RAND() * 180, '2025-06-10 09:34:00'), '2025-06-10 09:34:00', 
             CASE WHEN @i % 3 = 0 THEN 3 ELSE 1 END, 
             'IDH_U' + RIGHT('00' + CAST(@i AS NVARCHAR(3)), 3), 
             CONVERT(varbinary(512), 'PASS_U' + CAST(@i AS NVARCHAR(3))), 
             CASE WHEN @i % 5 = 0 THEN 1 ELSE 0 END, 
             CONVERT(varbinary(max), 'PUBKEY_U' + CAST(@i AS NVARCHAR(3))), 
             CONVERT(varbinary(max), 'PRVKEY_U' + CAST(@i AS NVARCHAR(3))));
        SET @i = @i + 1;
    END
END;
GO

EXEC [dbo].[sp_SeedUsers];


-- Insertar tipos de datos
INSERT INTO [dbo].[pv_dataTypes] (code, name, description, createdAt)
VALUES
    ('STR', 'String', 'Tipo de dato de texto', '2025-06-01'),
    ('NUM', 'Numeric', 'Tipo de dato numérico', '2025-06-01'),
    ('DAT', 'Date', 'Tipo de dato fecha', '2025-06-01'),
    ('BOL', 'Boolean', 'Tipo de dato booleano', '2025-06-01');


-- Insertar datos demográficos (sin cambios)
INSERT INTO [dbo].[pv_userDemographicTypes] (name, dataTypeID, description, isActive)
VALUES 
    ('Edad', 2, 'Rango de edad del usuario', 1),
    ('Sexo', 1, 'Género del usuario', 1),
    ('Región', 1, 'Región geográfica del usuario', 1);


-- Insertar datos demográficos para los 50 usuarios
INSERT INTO [dbo].[pv_userDemographics] (userID, userDemographicTypeID, value)
VALUES 
    (1, 1, '35'), (1, 2, 'Masculino'), (1, 3, 'San José'),
    (2, 1, '30'), (2, 2, 'Femenino'), (2, 3, 'Alajuela'),
    (3, 1, '40'), (3, 2, 'Masculino'), (3, 3, 'Heredia'),
    (4, 1, '25'), (4, 2, 'Femenino'), (4, 3, 'Cartago'),
    (5, 1, '45'), (5, 2, 'Masculino'), (5, 3, 'Guanacaste'),
    (6, 1, '28'), (6, 2, 'Femenino'), (6, 3, 'Puntarenas'),
    (7, 1, '32'), (7, 2, 'Masculino'), (7, 3, 'Limón'),
    (8, 1, '38'), (8, 2, 'Femenino'), (8, 3, 'San José'),
    (9, 1, '50'), (9, 2, 'Masculino'), (9, 3, 'Alajuela'),
    (10, 1, '27'), (10, 2, 'Femenino'), (10, 3, 'Heredia'),
    (11, 1, '33'), (11, 2, 'Masculino'), (11, 3, 'Cartago'),
    (12, 1, '29'), (12, 2, 'Femenino'), (12, 3, 'Guanacaste'),
    (13, 1, '41'), (13, 2, 'Masculino'), (13, 3, 'Puntarenas'),
    (14, 1, '36'), (14, 2, 'Femenino'), (14, 3, 'Limón'),
    (15, 1, '47'), (15, 2, 'Masculino'), (15, 3, 'San José'),
    (16, 1, '31'), (16, 2, 'Femenino'), (16, 3, 'Alajuela'),
    (17, 1, '39'), (17, 2, 'Masculino'), (17, 3, 'Heredia'),
    (18, 1, '26'), (18, 2, 'Femenino'), (18, 3, 'Cartago'),
    (19, 1, '43'), (19, 2, 'Masculino'), (19, 3, 'Guanacaste'),
    (20, 1, '34'), (20, 2, 'Femenino'), (20, 3, 'Puntarenas'),
    (21, 1, '37'), (21, 2, 'Masculino'), (21, 3, 'Limón'),
    (22, 1, '48'), (22, 2, 'Femenino'), (22, 3, 'San José'),
    (23, 1, '30'), (23, 2, 'Masculino'), (23, 3, 'Alajuela'),
    (24, 1, '42'), (24, 2, 'Femenino'), (24, 3, 'Heredia'),
    (25, 1, '28'), (25, 2, 'Masculino'), (25, 3, 'Cartago'),
    (26, 1, '35'), (26, 2, 'Femenino'), (26, 3, 'Guanacaste'),
    (27, 1, '44'), (27, 2, 'Masculino'), (27, 3, 'Puntarenas'),
    (28, 1, '31'), (28, 2, 'Femenino'), (28, 3, 'Limón'),
    (29, 1, '39'), (29, 2, 'Masculino'), (29, 3, 'San José'),
    (30, 1, '33'), (30, 2, 'Femenino'), (30, 3, 'Alajuela'),
    (31, 1, '36'), (31, 2, 'Masculino'), (31, 3, 'Heredia'),
    (32, 1, '29'), (32, 2, 'Femenino'), (32, 3, 'Cartago'),
    (33, 1, '41'), (33, 2, 'Masculino'), (33, 3, 'Guanacaste'),
    (34, 1, '27'), (34, 2, 'Femenino'), (34, 3, 'Puntarenas'),
    (35, 1, '38'), (35, 2, 'Masculino'), (35, 3, 'Limón'),
    (36, 1, '32'), (36, 2, 'Femenino'), (36, 3, 'San José'),
    (37, 1, '45'), (37, 2, 'Masculino'), (37, 3, 'Alajuela'),
    (38, 1, '30'), (38, 2, 'Femenino'), (38, 3, 'Heredia'),
    (39, 1, '43'), (39, 2, 'Masculino'), (39, 3, 'Cartago'),
    (40, 1, '26'), (40, 2, 'Femenino'), (40, 3, 'Guanacaste'),
    (41, 1, '34'), (41, 2, 'Masculino'), (41, 3, 'Puntarenas'),
    (42, 1, '37'), (42, 2, 'Femenino'), (42, 3, 'Limón'),
    (43, 1, '40'), (43, 2, 'Masculino'), (43, 3, 'San José'),
    (44, 1, '28'), (44, 2, 'Femenino'), (44, 3, 'Alajuela'),
    (45, 1, '46'), (45, 2, 'Masculino'), (45, 3, 'Heredia'),
    (46, 1, '31'), (46, 2, 'Femenino'), (46, 3, 'Cartago'),
    (47, 1, '39'), (47, 2, 'Masculino'), (47, 3, 'Guanacaste'),
    (48, 1, '33'), (48, 2, 'Femenino'), (48, 3, 'Puntarenas'),
    (49, 1, '42'), (49, 2, 'Masculino'), (49, 3, 'Limón'),
    (50, 1, '35'), (50, 2, 'Femenino'), (50, 3, 'San José');


-- Insertar tipos de grupos
INSERT INTO [dbo].[pv_groupTypes] (name, isActive)
VALUES 
    ('Comunidad Local', 1),
    ('Inversionistas', 1),
    ('Estudiantes Universitarios', 1),
    ('Organizaciones No Gubernamentales', 1),
    ('Profesionales Independientes', 1);

-- Insertar grupos
INSERT INTO [dbo].[pv_groups] (name, groupTypeID, createdAt, isActive)
VALUES 
    ('Asoc. Vecinos San José', 1, '2025-06-10 11:38:00', 1),
    ('Inversores Tech', 2, '2025-06-10 11:38:00', 1),
    ('Estudiantes TEC', 3, '2025-06-10 11:38:00', 1),
    ('ONG Verde', 4, '2025-06-10 11:38:00', 1),
    ('Freelancers CR', 5, '2025-06-10 11:38:00', 1);


-- Procedimiento para insertar propuestas (15 propuestas con nombres elaborados)
CREATE PROCEDURE [dbo].[sp_SeedProposals]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 1;
    WHILE @i <= 15
    BEGIN
        INSERT INTO [dbo].[pv_propposals] (proposalTypeID, name, userID, createdAt, lastUpdate, integrityHash)
        VALUES 
            (CASE WHEN @i % 5 = 0 THEN 5 ELSE @i % 5 END, 
             CASE 
                 WHEN @i = 1 THEN 'Construcción de Parque Urbano en San José'
                 WHEN @i = 2 THEN 'Plataforma de Crowdfunding para Emprendedores Locales'
                 WHEN @i = 3 THEN 'Investigación de Paneles Solares Eficientes'
                 WHEN @i = 4 THEN 'Festival Cultural Herediano 2025'
                 WHEN @i = 5 THEN 'Desarrollo de IA para Educación Inclusiva'
                 WHEN @i = 6 THEN 'Rehabilitación de Calles en Alajuela'
                 WHEN @i = 7 THEN 'App de Comercio Justo en Costa Rica'
                 WHEN @i = 8 THEN 'Estudio de Biodiversidad en Guanacaste'
                 WHEN @i = 9 THEN 'Exposición Artística Regional en Cartago'
                 WHEN @i = 10 THEN 'Prototipo de Drone Médico'
                 WHEN @i = 11 THEN 'Modernización de Escuelas Rurales'
                 WHEN @i = 12 THEN 'Iniciativa de Turismo Sostenible'
                 WHEN @i = 13 THEN 'Investigación de Energías Renovables'
                 WHEN @i = 14 THEN 'Teatro Comunitario en Limón'
                 WHEN @i = 15 THEN 'Sistema de Alerta Temprana Tecnológica'
             END,
             (@i % 50) + 1, 
             '2025-06-10 11:53:00', 
             '2025-06-10 11:53:00', 
             CONVERT(varbinary(512), HASHBYTES('SHA2_256', 'PROP_' + CAST(@i AS NVARCHAR(3)))));
        SET @i = @i + 1;
    END
END;
GO

EXEC [dbo].[sp_SeedProposals];


-- Insertar grupos objetivo (más campos)
INSERT INTO [dbo].[pv_proposalTargetGroups] (proposalID, groupID, createdAt, deleted)
VALUES 
    (1, 1, '2025-06-10 09:34:00', 1),
    (2, 2, '2025-06-10 09:34:00', 0),
    (3, 3, '2025-06-10 09:34:00', 0),
    (4, 4, '2025-06-10 09:34:00', 0),
    (5, 5, '2025-06-10 09:34:00', 0),
    (6, 1, '2025-06-10 09:34:00', 1),
    (7, 2, '2025-06-10 09:34:00', 0),
    (8, 3, '2025-06-10 09:34:00', 0),
    (9, 4, '2025-06-10 09:34:00', 0),
    (10, 5, '2025-06-10 09:34:00', 0),
    (11, 1, '2025-06-10 09:34:00', 0),
    (12, 2, '2025-06-10 09:34:00', 1),
    (13, 3, '2025-06-10 09:34:00', NULL),
    (14, 4, '2025-06-10 09:34:00', NULL),
    (15, 5, '2025-06-10 09:34:00', NULL);


-- Insertar estados de proyectos
INSERT INTO [dbo].[pv_projectStatuses] (name, isActive, createdAt, updatedAt)
VALUES 
    ('Planificación', 1, GETDATE(), GETDATE()),
    ('En Progreso', 1, GETDATE(), GETDATE()),
    ('Completado', 1, GETDATE(), GETDATE()),
    ('Cancelado', 0, GETDATE(), GETDATE());


-- Insertar proyectos
INSERT INTO [dbo].[pv_projects] (title, summary, fullDescription, userID, createdAt, projectStatusID, requestedAmount, currencyID, expectedStartDate, endDate, configuration, expectedDuration, checksum)
VALUES 
    ('Parque Urbano SJ', 'Construcción de parque comunitario', 'Proyecto para crear un parque en San José', 1, GETDATE(), 1, 50000.00, 1, GETDATE(), GETDATE(), CONVERT(varbinary(512), 'CFG_PRJ_001'), 180, CONVERT(varbinary(512), 'CHK_PRJ_001')),
    ('App Crowdfunding', 'Plataforma de financiación colectiva', 'Desarrollo de una app para crowdfunding', 2, GETDATE(), 1, 20000.00, 1, GETDATE(), GETDATE(), CONVERT(varbinary(512), 'CFG_PRJ_002'), 150, CONVERT(varbinary(512), 'CHK_PRJ_002')),
    ('Investigación Solar', 'Estudio de energía solar', 'Proyecto de investigación sobre paneles solares', 3, GETDATE(), 2, 30000.00, 1, GETDATE(), GETDATE(), CONVERT(varbinary(512), 'CFG_PRJ_003'), 140, CONVERT(varbinary(512), 'CHK_PRJ_003')),
    ('Festival Cultural', 'Evento cultural anual', 'Organización de un festival en Heredia', 4, GETDATE(), 1, 15000.00, 2, GETDATE(), GETDATE(), CONVERT(varbinary(512), 'CFG_PRJ_004'), 60, CONVERT(varbinary(512), 'CHK_PRJ_004')),
    ('IA Educativa', 'Desarrollo de IA para educación', 'Creación de herramientas de IA para estudiantes', 5, GETDATE(), 2, 25000.00, 1, GETDATE(), GETDATE(), CONVERT(varbinary(512), 'CFG_PRJ_005'), 180, CONVERT(varbinary(512), 'CHK_PRJ_005'));



-- Insertar hitos
INSERT INTO [dbo].[pv_projectMilestones] (projectID, title, description, assignedBudget, currencyCode, startDate, dueDate, actualCloseDate, createdAt, updatedAt, expectedDuration, checksum, projectStatusID)
VALUES 
    (1, 'Diseño', 'Diseño arquitectónico del parque', 10000.00, 'USD', GETDATE(), GETDATE(), NULL, '2025-06-10 09:00:00', '2025-06-10 09:20:00', 30, CONVERT(varbinary(512), 'CHK_M1'), 1),
    (1, 'Construcción', 'Ejecución de obras', 30000.00, 'USD', GETDATE(), GETDATE(), NULL, '2025-06-10 09:00:00', '2025-06-10 09:20:00', 120, CONVERT(varbinary(512), 'CHK_M2'), 1),
    (2, 'Análisis', 'Análisis de requisitos', 5000.00, 'USD', GETDATE(), GETDATE(), NULL, '2025-06-10 09:00:00', '2025-06-10 09:20:00', 30, CONVERT(varbinary(512), 'CHK_M3'), 1);


-- Insertar algoritmos
INSERT INTO [dbo].[pv_algorithms] (code, name, keyLenght, mode, description, isActive, createdAt, updatedAt)
VALUES 
    (N'SHA256', N'SHA-256', 256, N'Hashing', N'Algoritmo de hash seguro para integridad de datos', 1, '2025-06-10 10:06:00', '2025-06-10 10:06:00'),
    (N'AES128', N'AES-128', 128, N'CBC', N'Algoritmo de cifrado simétrico con modo CBC', 1, '2025-06-10 10:06:00', NULL),
    (N'RSA1024', N'RSA-1024', 1024, N'PKCS1', N'Algoritmo de cifrado asimétrico para claves públicas', 1, '2025-06-10 10:06:00', '2025-06-10 10:06:00');



-- Insertar usos principales
INSERT INTO [dbo].[pv_mainUses] (code, name, description, isActive, createdAt, updatedAt)
VALUES 
    (N'ENCRYPTION', N'Cifrado de Datos', N'Uso principal para cifrado de información sensible en transacciones', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'SIGNATURE', N'Firma Digital', N'Uso para generar y verificar firmas digitales en documentos', 1, '2025-06-10 11:38:00', NULL),
    (N'HASHING', N'Generación de Hash', N'Uso para crear hash seguros para integridad de datos', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00');



-- Insertar tipos de claves
INSERT INTO [dbo].[pv_keyTypes] (code, name, description, isActive, createdAt, updatedAt)
VALUES 
    (N'PUBLIC', N'Clave Pública', N'Clave utilizada para cifrado y verificación', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'PRIVATE', N'Clave Privada', N'Clave utilizada para descifrado y firma', 1, '2025-06-10 11:38:00', NULL),
    (N'SYMMETRIC', N'Clave Simétrica', N'Clave compartida para cifrado simétrico', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00');


-- Insertar datos en pv_secureEnclave
INSERT INTO [dbo].[pv_secureEnclave] (name, location, enclaveType, createdAt, status, enclaveHash)
VALUES 
    (N'Enclave Principal', geography::Point(9.9333, -84.0833, 4326), N'Hardware', '2025-06-10 11:38:00', N'Activo', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'ENCLAVE_001'))),
    (N'Enclave Secundario', geography::Point(10.0000, -83.2000, 4326), N'Software', '2025-06-10 11:38:00', N'Activo', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'ENCLAVE_002')));



ALTER TABLE [dbo].[pv_cryptographicKeys]
ALTER COLUMN digitalSignatureID INT NULL;


-- Insertar datos en pv_cryptographicKeys (IDs temporales)
INSERT INTO [dbo].[pv_cryptographicKeys] (keyType, algorithm, keyValue, createdAt, expirationDate, status, mainUse, hashKey, enclaveID, digitalSignatureID, userID, institutionID)
VALUES 
    (1, 1, CONVERT(varbinary(250), 'KEYVAL_001'), '2025-06-10 10:13:00', '2026-06-10 10:13:00', N'Activo', 1, CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'HASHKEY_001')), 1, NULL, 1, NULL),
    (2, 2, CONVERT(varbinary(250), 'KEYVAL_002'), '2025-06-10 10:13:00', '2026-06-10 10:13:00', N'Activo', 2, CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'HASHKEY_002')), 2, NULL, 2, N'INST001');



-- Insertar datos en pv_digitalSignature (IDs temporales)
INSERT INTO [dbo].[pv_digitalSignature] (cryptographicKeyID, signatureValue, signatureDate, transactionType, transactionHash, status)
VALUES 
    (1, CONVERT(binary(200), 'SIGNVAL_001'), '2025-06-10 10:13:00', N'Firma', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'TXNHASH_001')), N'Válida'),
    (2, CONVERT(binary(200), 'SIGNVAL_002'), '2025-06-10 10:13:00', N'Verificación', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'TXNHASH_002')), N'Pendiente');




-- Insertar estados de contribución
INSERT INTO [dbo].[pv_contributionStatuses] (name, isActive, updatedAt)
VALUES 
    (N'Pendiente', 1, '2025-06-10 11:38:00'),
    (N'Aprobado', 1, '2025-06-10 11:38:00'),
    (N'Rechazado', 0, '2025-06-10 11:38:00'),
    (N'Procesando', 1, NULL),
    (N'Completado', 1, '2025-06-10 11:38:00');



-- Insertar contribuciones de crowdfunding
INSERT INTO [dbo].[pv_crowdfundingContributions] (projectID, userID, contributionDate, amount, currencyCode, isMatchedByGob, matchedAmount, contributionStatusID, description, paymentMethodID, prevHash, cryptographicKeyID)
VALUES 
    (2, 1, '2025-06-10 09:59:00', 5000.00, 'USD', 0, 0.00, 1, N'Contribución inicial al proyecto', 1, CONVERT(varbinary(512), HASHBYTES('SHA2_256', 'PREVHASH_001')), 1),
    (2, 2, '2025-06-10 09:59:00', 3000.00, 'USD', 0, 0.00, 1, N'Apoyo al desarrollo de la app', 2, CONVERT(varbinary(512), HASHBYTES('SHA2_256', 'PREVHASH_002')), 2),
    (3, 3, '2025-06-10 09:59:00', 7000.00, 'USD', 1, 2000.00, 1, N'Financiamiento investigación solar', 1, CONVERT(varbinary(512), HASHBYTES('SHA2_256', 'PREVHASH_003')), 1),
    (4, 4, '2025-06-10 09:59:00', 4000.00, 'CRC', 0, 0.00, 1, N'Apoyo al festival cultural', 2, CONVERT(varbinary(512), HASHBYTES('SHA2_256', 'PREVHASH_004')), 2),
    (5, 5, '2025-06-10 09:59:00', 6000.00, 'USD', 1, 1500.00, 1, N'Contribución a IA educativa', 1, CONVERT(varbinary(512), HASHBYTES('SHA2_256', 'PREVHASH_005')), 1);



-- Insertar estados de validación
INSERT INTO [dbo].[pv_validationStatus] (code, name, description, isActive, createdAt, updatedAt)
VALUES 
    (N'PEND', N'Pendiente', N'Estado inicial de validación pendiente de revisión', 1, '2025-06-10 11:38:00', NULL),
    (N'APRV', N'Aprobado', N'Validación completada y aprobada', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'REJ', N'Rechazado', N'Validación rechazada por incumplimiento', 0, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'PROC', N'Procesando', N'Validación en curso de procesamiento', 1, '2025-06-10 11:38:00', NULL);



-- Insertar estados de institución (sin cambios)
INSERT INTO [dbo].[pv_institutionStatus] (code, name, description, isDefault, isActive, createdAt, updatedAt)
VALUES 
    (N'ACTV', N'Activo', N'Institución en operación y activa', 1, 1, '2025-06-10 11:38:00', NULL),
    (N'INAC', N'Inactivo', N'Institución temporalmente inactiva', 0, 0, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'PEND', N'Pendiente', N'Institución en proceso de registro', 0, 1, '2025-06-10 11:38:00', NULL);



-- Insertar sectores
INSERT INTO [dbo].[pv_sectors] (code, name, description, isActive, createdAt, updatedAt)
VALUES 
    (N'TECH', N'Tecnología', N'Sector relacionado con innovaciones tecnológicas', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'EDUC', N'Educación', N'Sector enfocado en servicios educativos', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'HLTH', N'Salud', N'Sector de servicios de salud y bienestar', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00');



-- Insertar instituciones
INSERT INTO [dbo].[pv_institutions] (name, insType, legalID, registrationDate, institutionStatusID, sectorID, size, legalLocation, symKeyEncryptedWithMaster)
VALUES 
    (N'TechCorp', N'Empresa Privada', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'LEGALID_001')), '2025-06-10 11:38:00', 1, 1, N'Mediana', geography::Point(9.9333, -84.0833, 4326), CONVERT(varbinary(250), 'SYMKEY_001')),
    (N'EduInst', N'Institución Educativa', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'LEGALID_002')), '2025-06-10 11:38:00', 3, 2, N'Grande', geography::Point(10.0000, -83.2000, 4326), CONVERT(varbinary(250), 'SYMKEY_002')),
    (N'HealthOrg', N'Organización No Gubernamental', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'LEGALID_003')), '2025-06-10 11:38:00', 1, 3, N'Pequeña', geography::Point(9.9000, -83.0500, 4326), CONVERT(varbinary(250), 'SYMKEY_003'));



-- Insertar tipos de medios
INSERT INTO [dbo].[pv_mediaTypes] (name, mediaExtension, createdAt, updatedAt, isActive)
VALUES 
    (N'Imagen', N'.jpg', '2025-06-10 11:38:00', NULL, 1),
    (N'Documento', N'.pdf', '2025-06-10 11:38:00', '2025-06-10 11:38:00', 1),
    (N'Video', N'.mp4', '2025-06-10 11:38:00', NULL, 1);


-- Insertar versiones de propuestas
INSERT INTO [dbo].[pv_proposalVersion] (proposalID, versionNumber, createdAt, madeChanges, versionStatus, contentHash, revisionComments)
VALUES 
    (1, 1, '2025-06-10 11:38:00', N'Añadido plan técnico inicial', N'Borrador', N'HASH_V1_P1_' + CAST(HASHBYTES('SHA2_256', 'CONTENT_P1_V1') AS NVARCHAR(300)), N'Revisión pendiente de aprobación'),
    (1, 2, '2025-06-10 11:38:00', N'Actualizado presupuesto', N'Revisado', N'HASH_V2_P1_' + CAST(HASHBYTES('SHA2_256', 'CONTENT_P1_V2') AS NVARCHAR(300)), N'Aprobado con ajustes menores'),
    (2, 1, '2025-06-10 11:38:00', N'Definido alcance de la app', N'Borrador', N'HASH_V1_P2_' + CAST(HASHBYTES('SHA2_256', 'CONTENT_P2_V1') AS NVARCHAR(300)), N'Esperando revisión inicial'),
    (3, 1, '2025-06-10 11:38:00', N'Incluido diseño preliminar', N'Pendiente', N'HASH_V1_P3_' + CAST(HASHBYTES('SHA2_256', 'CONTENT_P3_V1') AS NVARCHAR(300)), N'Revisión técnica requerida');


-- Insertar tipos de documentos
INSERT INTO [dbo].[pv_documentType] (name, isActive, createdAt, updatedAt)
VALUES 
    (N'Propuesta Técnica', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'Informe Financiero', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00'),
    (N'Cédula', 1, '2025-06-10 11:38:00', '2025-06-10 11:38:00');



-- Insertar documentos de propuestas
INSERT INTO [dbo].[pv_proposalDocument] (proposalID, proposalVersionID, fileName, fileHash, size, format, uploadDate, validationStatusID, storageLocation, userID, institutionID, mediaTypeID, documentTypeID)
VALUES 
    (1, 1, N'Propuesta_Tecnica_V1.pdf', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'DOC_001')), 1024, N'PDF', '2025-06-10 10:51:00', 2, CONVERT(varbinary(250), 'STOR_LOC_001'), 1, 1, 2, 1),
    (2, 1, N'App_Crowdfunding_Doc.pdf', CONVERT(varbinary(250), HASHBYTES('SHA2_256', 'DOC_002')), 2048, N'PDF', '2025-06-10 10:51:00', 1, CONVERT(varbinary(250), 'STOR_LOC_002'), 2, NULL, 2, 2),
    (3, 1, N'Invest_Solar_Report.jpg', CONVERT(varbinary(250)), HASHBYTES('SHA2_256', 'DOC_003'), 512, N'JPG', '2025-06-10 10:51:00', 4, CONVERT(varbinary(250), 'STOR_LOC_003'), 3, 2, 1, 3);



-- Insertar workflows
INSERT INTO [dbo].[pv_workflowDefinitions] (dagID, description, name)
VALUES 
    ('WF_PROPOSAL_001', 'Flujo para revisión de propuestas', 'Revisión Propuesta'),
    ('WF_INVESTMENT_001', 'Flujo para inversiones', 'Revisión Inversión');



-- Insertar instancias de workflows
INSERT INTO [dbo].[pv_workFlowsInstances] (proposalDocumentID, dagRunID, dagURL, payload, bucketOrigin, validationStatusID, startedAt, finishedAt, createdAt, updatedAt, workflowsDefinitionID)
VALUES 
    (1, 'RUN_PROPOSAL_001', 'http://workflow.local/run1', 'Payload_001', 'BUCKET_PROPOSAL_001', 1, '2025-06-10 11:38:00', '2025-06-10 12:38:00', '2025-06-10 11:38:00', '2025-06-10 11:38:00', 1),
    (2, 'RUN_INVESTMENT_001', 'http://workflow.local/run2', 'Payload_002', 'BUCKET_INVESTMENT_001', 2, '2025-06-10 11:38:00', '2025-06-10 13:38:00', '2025-06-10 11:38:00', '2025-06-10 11:38:00', 2);



-- Insertar tipos de logs de workflow
INSERT INTO [dbo].[pv_workflowLogTypes] (name)
VALUES 
    ('Inicio'),
    ('Progreso'),
    ('Completado'),
    ('Error');



-- Insertar logs de workflow
INSERT INTO [dbo].[pv_workflowLogs] (workflowInstanceID, userID, createdAt, workflowLogTypeID, message, description, detailsAI)
VALUES 
    (1, 1, '2025-06-10 11:38:00', 1, 'Workflow iniciado', 'Inicio del flujo de revisión', 'Análisis inicial'),
    (1, 1, '2025-06-10 11:39:00', 2, 'En progreso', 'Validación en curso', 'IA en proceso'),
    (2, 2, '2025-06-10 11:38:00', 1, 'Workflow iniciado', 'Inicio del flujo de inversión', 'Análisis financiero'),
    (2, 2, '2025-06-10 11:40:00', 3, 'Completado', 'Inversión aprobada', 'Validación exitosa');



-- Insertar parámetros de workflow
INSERT INTO [dbo].[pv_workflowParameters] (workflowDefinitionID, parameterKey, parameterValueDefault, dataType, isRequired)
VALUES 
    (1, 'reviewerID', '1', 'NUM', 1),
    (1, 'timeout', '3600', 'NUM', 1),
    (2, 'amountThreshold', '10000', 'NUM', 1),
    (2, 'approvalLevel', '2', 'NUM', 1);



-- Insertar estados de votación
INSERT INTO [dbo].[pv_votingStatuses] (name, isActive, updatedAt)
VALUES 
    (N'Abierto', 1, '2025-06-10 11:38:00'),
    (N'Cerrado', 1, '2025-06-10 11:38:00'),
    (N'Pendiente', 1, '2025-06-10 11:38:00');


	-- Insertar votaciones
INSERT INTO [dbo].[pv_votings] (proposalID, configurationHash, createdAt, quorum, projectID, votingStatusID)
VALUES 
    (1, CONVERT(varbinary(512), 'CFG_HASH_001'), '2025-03-10 09:00:00', 50, 1, 1),
    (2, CONVERT(varbinary(512), 'CFG_HASH_002'), '2025-03-10 09:00:00', 50, 2, 1),
	(3, CONVERT(varbinary(512), 'CFG_HASH_003'), '2025-04-10 09:00:00', 50, 2, 1),
	(4, CONVERT(varbinary(512), 'CFG_HASH_004'), '2025-05-10 09:00:00', 50, 2, 1),
	(5, CONVERT(varbinary(512), 'CFG_HASH_005'), '2025-06-10 09:00:00', 50, 2, 1),
	(6, CONVERT(varbinary(512), 'CFG_HASH_006'), '2025-06-11 09:10:00', 50, 2, 1),
	(7, CONVERT(varbinary(512), 'CFG_HASH_007'), '2025-06-11 09:30:00', 50, 2, 1),
	(8, CONVERT(varbinary(512), 'CFG_HASH_008'), '2025-06-12 10:00:00', 50, 2, 1);


-- Insertar tipos de resultados de votación
INSERT INTO [dbo].[pv_votingCoreResultTypes] (name, isActive, updatedAt)
VALUES 
    (N'Resultado Aprobado por Mayoría', 1, '2025-06-10 11:38:00'),
    (N'Resultado Rechazado', 1, NULL),
    (N'Resultado Empate', 1, '2025-06-10 11:38:00');


-- Insertar más campos en votingCore
INSERT INTO [dbo].[pv_votingCore] (votingID, title, description, startDate, endDate, approvalThreshold, isPublic, isActive, isPrivate, votingCoreResultTypeID)
VALUES 
    (1, 'Aprobación Parque', 'Votación para aprobar el parque', GETDATE(), GETDATE(), 60.00, 1, 1, 0, 1),
    (2, 'Aprobación App', 'Votación para aprobar la app', GETDATE(), GETDATE(), 60.00, 1, 1, 0, 1),
    (3, 'Investigación Solar', 'Votación sobre investigación', GETDATE(), GETDATE(), 65.00, 1, 1, 0, 1),
    (4, 'Festival Cultural', 'Aprobación del festival', GETDATE(), GETDATE(), 70.00, 1, 1, 0, 1),
    (5, 'IA Educativa', 'Votación sobre IA', GETDATE(), GETDATE(), 55.00, 1, 1, 0, 1),
    (6, 'Rehabilitación Calles', 'Votación para rehabilitar calles en Alajuela', GETDATE(), GETDATE(), 62.00, 1, 1, 0, 1),
    (7, 'Turismo Sostenible', 'Votación sobre iniciativa de turismo sostenible', GETDATE(), GETDATE(), 67.00, 1, 1, 0, 1),
    (8, 'Teatro Comunitario', 'Aprobación del teatro comunitario en Limón', GETDATE(), GETDATE(), 58.00, 1, 1, 0, 1);



-- Insertar tipos de preguntas para votación
INSERT INTO [dbo].[pv_questionTypes] (name, isActive, createdAt)
VALUES 
    (N'Selección única', 1, '2025-06-10 11:38:00'),
    (N'Selección múltiple', 1, '2025-06-10 11:38:00');


ALTER TABLE [dbo].[pv_voteQuestions]
ALTER COLUMN voteID INT NULL;


-- Insertar preguntas de votación
INSERT INTO [dbo].[pv_voteQuestions] (voteID, questionText, questionTypeID, maxSelections, isRequired, createdAt, updatedAt)
VALUES 
    (NULL, N'¿Aprueba la construcción del parque?', 1, 1, 1, '2025-06-10 10:51:00', NULL),
    (NULL, N'¿Qué nivel de apoyo tiene la app?', 2, 2, 0, '2025-06-10 10:51:00', '2025-06-10 10:51:00');


-- Insertar opciones de preguntas de votación
INSERT INTO [dbo].[pv_voteQuestionsOptions] (questionID, label, optionURL, value, dataTypeID, orderIndex, isActive, createdAt)
VALUES 
    (1, N'A favor', NULL, N'Si', 1, 1, 1, '2025-06-10 11:38:00'),
    (1, N'En contra', NULL, N'No', 1, 2, 1, '2025-06-10 11:38:00'),
    (2, N'Abstención', N'https://example.com/abstencion', N'Abst', 2, 1, 1, '2025-06-10 11:38:00');


-- Procedimiento para insertar votos (50 votos)
CREATE PROCEDURE [dbo].[sp_SeedVotes]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 1;
    WHILE @i <= 50
    BEGIN
        INSERT INTO [dbo].[pv_votes] (votingID, proposalID, projectID, questionID, optionID, customValue, voterHash, prevHash, criptographicKey, voteDate, tokenUsedAt, tokenValue)
        VALUES 
            (CASE WHEN @i <= 10 THEN 1 WHEN @i <= 20 THEN 2 WHEN @i <= 30 THEN 3 WHEN @i <= 40 THEN 4 ELSE 5 END,
             CASE WHEN @i <= 10 THEN 1 WHEN @i <= 20 THEN 2 WHEN @i <= 30 THEN 3 WHEN @i <= 40 THEN 4 ELSE 5 END,
             CASE WHEN @i <= 10 THEN 1 WHEN @i <= 20 THEN 2 WHEN @i <= 30 THEN 2 WHEN @i <= 40 THEN 2 ELSE 2 END,
             CASE WHEN @i % 2 = 0 THEN 1 ELSE 2 END,
             CASE WHEN @i % 3 = 0 THEN 1 WHEN @i % 3 = 1 THEN 2 ELSE 3 END,
             CASE WHEN @i % 2 = 0 THEN 'A favor' ELSE 'En contra' END,
             CONVERT(varbinary(250), 'VOTE_HASH_' + RIGHT('00' + CAST(@i AS NVARCHAR(3)), 3)),
             CONVERT(varbinary(512), 'PREV_HASH_' + RIGHT('00' + CAST(@i AS NVARCHAR(3)), 3)),
             CASE WHEN @i % 2 = 0 THEN 1 ELSE 2 END,
             DATEADD(minute, -@i * 10, '2025-06-10 12:04:00'),
             DATEADD(minute, -@i * 10, '2025-06-10 12:04:00'),
             CONVERT(varbinary(512), 'TOKEN_' + RIGHT('00' + CAST(@i AS NVARCHAR(3)), 3)));
        SET @i = @i + 1;
    END
END;
GO

EXEC [dbo].[sp_SeedVotes];



-- Procedimiento para llenado dinámico de resultados de votación
CREATE PROCEDURE [dbo].[sp_SeedVotingResults]
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[pv_votingResult] (votingID, totalVotes, totalValids, winningOption, approvalPorcentage, quorumMeet, closingDate, status, resultHash)
    SELECT votingID, 100 * ROW_NUMBER() OVER (ORDER BY votingID), 95 * ROW_NUMBER() OVER (ORDER BY votingID), 
           CASE WHEN votingID % 2 = 0 THEN 'Sí' ELSE 'No' END, 65.00 + (votingID * 5), 1, 
           DATEADD(day, votingID, '2025-06-10 12:04:00'), 'Finalizado', CONVERT(varbinary(250), 'RES_HASH_' + CAST(votingID AS NVARCHAR(10)))
    FROM [dbo].[pv_votings];
END;
GO


EXEC [dbo].[sp_SeedVotingResults];


-- Verificación de datos
SELECT * FROM [dbo].[pv_accountStatus];
SELECT * FROM [dbo].[pv_proposalType];
SELECT * FROM [dbo].[pv_currencies];
SELECT * FROM [dbo].[pv_paymentMethods];
SELECT * FROM [dbo].[pv_users];
SELECT * FROM [dbo].[pv_dataTypes];
SELECT * FROM [dbo].[pv_userDemographicTypes];
SELECT * FROM [dbo].[pv_userDemographics];
SELECT * FROM [dbo].[pv_groupTypes];
SELECT * FROM [dbo].[pv_groups];
SELECT * FROM [dbo].[pv_propposals];
SELECT * FROM [dbo].[pv_proposalTargetGroups];
SELECT * FROM [dbo].[pv_projectStatuses];
SELECT * FROM [dbo].[pv_projects];
SELECT * FROM [dbo].[pv_projectMilestones];
SELECT * FROM [dbo].[pv_algorithms];
SELECT * FROM [dbo].[pv_mainUses];
SELECT * FROM [dbo].[pv_keyTypes];
SELECT * FROM [dbo].[pv_secureEnclave];
SELECT * FROM [dbo].[pv_cryptographicKeys];
SELECT * FROM [dbo].[pv_digitalSignature];
SELECT * FROM [dbo].[pv_contributionStatuses];
SELECT * FROM [dbo].[pv_crowdfundingContributions];
SELECT * FROM [dbo].[pv_validationStatus];
SELECT * FROM [dbo].[pv_institutionStatus];
SELECT * FROM [dbo].[pv_sectors];
SELECT * FROM [dbo].[pv_institutions];
SELECT * FROM [dbo].[pv_mediaTypes];
SELECT * FROM [dbo].[pv_proposalVersion];
SELECT * FROM [dbo].[pv_documentType];
SELECT * FROM [dbo].[pv_proposalDocument];
SELECT * FROM [dbo].[pv_workflowDefinitions];
SELECT * FROM [dbo].[pv_workFlowsInstances];
SELECT * FROM [dbo].[pv_workflowLogTypes];
SELECT * FROM [dbo].[pv_workflowLogs];
SELECT * FROM [dbo].[pv_workflowParameters];
SELECT * FROM [dbo].[pv_votingStatuses];
SELECT * FROM [dbo].[pv_votings];
SELECT * FROM [dbo].[pv_votingCoreResultTypes];
SELECT * FROM [dbo].[pv_votingCore];
SELECT * FROM [dbo].[pv_questionTypes];
SELECT * FROM [dbo].[pv_voteQuestions];
SELECT * FROM [dbo].[pv_votes];
SELECT * FROM [dbo].[pv_votingResult];