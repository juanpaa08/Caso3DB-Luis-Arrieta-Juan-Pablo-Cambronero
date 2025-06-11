USE [Caso3DB];
GO


USE [Caso3DB];
GO

CREATE OR ALTER PROCEDURE dbo.sp_Invertir
    @projectID        INT,
    @userID           INT,
    @amount           DECIMAL(18,2),
    @paymentMethodID  INT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE 
        @approvedStatusID   INT,
        @cryptoKeyID        INT,
        @keyAction          NVARCHAR(20) = N'existing',
        @totalSolicitado    DECIMAL(18,2),
        @sumaInvertido      DECIMAL(18,2),
        @equityPct          DECIMAL(10,2),
        @contribID          INT,
        @newKey             VARBINARY(32),
        @hashKey            VARBINARY(32),
        @keyTypeID          INT,
        @algID              INT,
        @mainUseID          INT,
        @enclaveID          INT,
        @sigID              INT;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- 0) Estado Approved/Aprobado
        SELECT @approvedStatusID = contributionStatusID
          FROM dbo.pv_contributionStatuses
         WHERE LTRIM(RTRIM(name)) IN (N'Approved', N'Aprobado');
        IF @approvedStatusID IS NULL
            THROW 50015, 'Falta estado Approved/Aprobado', 1;

        -- 0.1) Obtener o crear llave criptográfica
        SELECT TOP 1 @cryptoKeyID = cryptographicKeyID
          FROM dbo.pv_cryptographicKeys
         WHERE userID = @userID
         ORDER BY createdAt DESC;

        IF @cryptoKeyID IS NULL
        BEGIN
            SET @keyAction = N'created';

            SET @newKey  = CRYPT_GEN_RANDOM(32);
            SET @hashKey = HASHBYTES('SHA2_256', @newKey);

            SELECT TOP 1
                @keyTypeID = keyTypeID,
                @algID     = algorithmID,
                @mainUseID = mainUseID
              FROM dbo.pv_keyTypes kt
              JOIN dbo.pv_algorithms a       ON 1=1
              JOIN dbo.pv_mainUses mu       ON 1=1;

            SELECT TOP 1
                @enclaveID = secureEnclaveID,
                @sigID     = digitalSignatureID
              FROM dbo.pv_secureEnclave se
              JOIN dbo.pv_digitalSignature ds ON 1=1;

            IF @keyTypeID    IS NULL
            OR @algID        IS NULL
            OR @mainUseID    IS NULL
            OR @enclaveID    IS NULL
            OR @sigID        IS NULL
                THROW 50017, 'Faltan datos maestros para la llave', 1;

            INSERT INTO dbo.pv_cryptographicKeys
            (
                keyType, algorithm, keyValue, createdAt, expirationDate,
                status, mainUse, hashKey, enclaveID, digitalSignatureID, userID
            )
            VALUES
            (
                @keyTypeID,
                @algID,
                @newKey,
                GETDATE(),
                DATEADD(YEAR,1,GETDATE()),
                N'Active',
                @mainUseID,
                @hashKey,
                @enclaveID,
                @sigID,
                @userID
            );
            SET @cryptoKeyID = SCOPE_IDENTITY();
        END

        -- 1) Proyecto planificado o en progreso
        IF NOT EXISTS (
            SELECT 1
              FROM dbo.pv_projects p
             WHERE p.projectID = @projectID
               AND p.projectStatusID IN (1,2)
        )
            THROW 50010, 'Proyecto no habilitado para inversión', 1;

        -- 2) Usuario existe
        IF NOT EXISTS (
            SELECT 1
              FROM dbo.pv_users u
             WHERE u.userID = @userID
        )
            THROW 50011, 'Usuario no existe', 1;

        -- 3) Método de pago habilitado
        IF NOT EXISTS (
            SELECT 1
              FROM dbo.pv_paymentMethods pm
             WHERE pm.paymentMethodID = @paymentMethodID
               AND pm.enabled = 1
        )
            THROW 50012, 'Método de pago inválido', 1;

        -- 4) Calcular montos
        SELECT @totalSolicitado = requestedAmount
          FROM dbo.pv_projects
         WHERE projectID = @projectID;
        IF @totalSolicitado IS NULL
            THROW 50013, 'Proyecto no encontrado', 1;

        SELECT @sumaInvertido = ISNULL(SUM(amount),0)
          FROM dbo.pv_crowdfundingContributions
         WHERE projectID = @projectID
           AND contributionStatusID = @approvedStatusID;

        IF @sumaInvertido + @amount > @totalSolicitado
            THROW 50014, 'Inversión excede monto máximo del proyecto', 1;

        SET @equityPct = ROUND(@amount * 100.0 / @totalSolicitado, 2);

        -- 5) Insertar contribución
        INSERT INTO dbo.pv_crowdfundingContributions
        (
            projectID, userID, contributionDate, amount, currencyCode,
            isMatchedByGob, matchedAmount, contributionStatusID,
            description, paymentMethodID, prevHash, cryptographicKeyID
        )
        VALUES
        (
            @projectID, @userID, GETDATE(), @amount, N'CRC',
            0, 0, @approvedStatusID,
            NULL, @paymentMethodID,
            HASHBYTES('SHA2_256', CONVERT(VARCHAR(36), NEWID())),
            @cryptoKeyID
        );
        SET @contribID = SCOPE_IDENTITY();

        -- 6a) Resumen
        SELECT
            @contribID        AS contributionID,
            @projectID        AS projectID,
            @userID           AS userID,
            @amount           AS investedAmount,
            @totalSolicitado  AS totalRequested,
            @sumaInvertido    AS alreadyInvested,
            @equityPct        AS equityPercent,
            @cryptoKeyID      AS cryptoKeyID,
            @keyAction        AS cryptoKeyAction,
            @approvedStatusID AS statusID;

        -- 6b) 12 cuotas
        ;WITH Months AS (
            SELECT 1 AS MesOffset
            UNION ALL
            SELECT MesOffset + 1 FROM Months WHERE MesOffset < 12
        )
        SELECT
            @contribID                            AS contributionID,
            DATEADD(MONTH, MesOffset, CAST(GETDATE() AS DATE)) AS dueDate,
            ROUND(@amount/12, 2)                  AS installmentAmount
        FROM Months
        OPTION (MAXRECURSION 12);

        -- 6c) 4 revisiones
        SELECT
            @contribID                            AS contributionID,
            DATEADD(MONTH, v.ReviewOffset, CAST(GETDATE() AS DATE)) AS reviewDate,
            v.ReviewLabel                        AS milestone
        FROM (VALUES
            ( 3, N'1ra Revisión'),
            ( 6, N'2da Revisión'),
            ( 9, N'3ra Revisión'),
            (12, N'Revisión Final')
        ) AS v(ReviewOffset, ReviewLabel);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- Invertir

EXEC dbo.sp_Invertir 
    1,         -- @proposalID
    5,          -- @userID
    10000.00,     -- @amount
    1;          -- @paymentMethodID


DROP PROCEDURE sp_Invertir;


SELECT * FROM pv_users;
SELECT * FROM pv_propposals;
SELECT * FROM pv_projects;
SELECT * FROM pv_paymentMethods;
SELECT * FROM pv_contributionStatuses;
SELECT * FROM pv_cryptographicKeys;



