USE [Caso3DB];
GO

-- 1) Eliminar versión previa
IF OBJECT_ID('dbo.invertir','P') IS NOT NULL
  DROP PROCEDURE dbo.invertir;
GO

-- 2) Crear el SP con THROW corregido
CREATE PROCEDURE dbo.invertir
  @projectID       INT,
  @userID          INT,
  @amount          DECIMAL(18,2),
  @paymentMethodID INT
WITH EXECUTE AS OWNER
AS
BEGIN
  SET NOCOUNT      ON;
  SET XACT_ABORT   ON;
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

  DECLARE
    @keyName        SYSNAME,
    @cryptoKeyID    INT,
    @openCmd        NVARCHAR(MAX),
    @closeCmd       NVARCHAR(MAX),
    @encryptedAmt   VARBINARY(MAX),
    @encryptedPrev  VARBINARY(MAX),
    @approvedStatus INT,
    @totalSolicited DECIMAL(18,2),
    @sumInvested    DECIMAL(18,2),
    @equityPct      DECIMAL(10,2),
    @contribID      INT,
    @errMsg         NVARCHAR(200);

  -- 1) Validar monto
  IF @amount <= 0
  BEGIN
    SET @errMsg = 'El monto de inversión debe ser mayor a cero.';
    THROW 50018, @errMsg, 1;
  END

  -- 2) Nombre de la key del usuario
  SET @keyName = N'SK_User_' + CAST(@userID AS NVARCHAR(10));

  -- 3) Verificar existencia física de la symmetric key
  IF NOT EXISTS (
    SELECT 1 FROM sys.symmetric_keys WHERE name = @keyName
  )
  BEGIN
    SET @errMsg = 'No existe symmetric key ' + @keyName + '.';
    THROW 50017, @errMsg, 1;
  END

  -- 4) Obtener cryptographicKeyID
  SELECT TOP 1
    @cryptoKeyID = cryptographicKeyID
  FROM dbo.pv_cryptographicKeys
  WHERE userID = @userID
    AND status = N'Activo'
  ORDER BY createdAt DESC;

  IF @cryptoKeyID IS NULL
  BEGIN
    SET @errMsg = 'No hay registro activo en pv_cryptographicKeys para userID=' 
                  + CAST(@userID AS NVARCHAR(10)) + '.';
    THROW 50017, @errMsg, 1;
  END

  -- 5) Abrir la symmetric key dinámicamente
  SET @openCmd = 
    N'OPEN SYMMETRIC KEY [' + @keyName
    + N'] DECRYPTION BY CERTIFICATE [Cert_UserKey];';
  EXEC sp_executesql @openCmd;

  -- 6) Cifrar amount y prevHash
  SET @encryptedAmt  = EncryptByKey(
    Key_GUID(@keyName),
    CONVERT(varchar(50), @amount)
  );
  SET @encryptedPrev = EncryptByKey(
    Key_GUID(@keyName),
    HASHBYTES('SHA2_256', CONVERT(varchar(36), NEWID()))
  );

  -- 7) Cerrar la symmetric key
  SET @closeCmd = N'CLOSE SYMMETRIC KEY [' + @keyName + N'];';
  EXEC sp_executesql @closeCmd;

  -- 8) Obtener estado “Approved”
  SELECT @approvedStatus = contributionStatusID
    FROM dbo.pv_contributionStatuses
   WHERE name IN (N'Approved', N'Aprobado');
  IF @approvedStatus IS NULL
  BEGIN
    SET @errMsg = 'Falta estado Approved/Aprobado.';
    THROW 50015, @errMsg, 1;
  END

  -- 9) Validaciones de proyecto, usuario y método de pago
  IF NOT EXISTS (
    SELECT 1 FROM dbo.pv_projects
     WHERE projectID = @projectID
       AND projectStatusID IN (1,2)
  )
  BEGIN
    SET @errMsg = 'Proyecto no habilitado.';
    THROW 50010, @errMsg, 1;
  END

  IF NOT EXISTS (
    SELECT 1 FROM dbo.pv_users WHERE userID = @userID
  )
  BEGIN
    SET @errMsg = 'Usuario no existe.';
    THROW 50011, @errMsg, 1;
  END

  IF NOT EXISTS (
    SELECT 1 FROM dbo.pv_paymentMethods
     WHERE paymentMethodID = @paymentMethodID
       AND enabled = 1
  )
  BEGIN
    SET @errMsg = 'Método de pago inválido.';
    THROW 50012, @errMsg, 1;
  END

  -- 10) Cálculo de montos
  SELECT @totalSolicited = requestedAmount
    FROM dbo.pv_projects
   WHERE projectID = @projectID;

  SELECT @sumInvested = ISNULL(SUM(amount), 0)
    FROM dbo.pv_crowdfundingContributions
   WHERE projectID = @projectID
     AND contributionStatusID = @approvedStatus;

  IF @sumInvested + @amount > @totalSolicited
  BEGIN
    SET @errMsg = 'Inversión excede monto máximo.';
    THROW 50014, @errMsg, 1;
  END

  SET @equityPct = ROUND(@amount * 100.0 / @totalSolicited, 2);

  -- 11) Insertar la contribución
  INSERT INTO dbo.pv_crowdfundingContributions
  (
    projectID, userID, contributionDate,
    amount, encryptedAmount, currencyCode,
    isMatchedByGob, matchedAmount, contributionStatusID,
    description, paymentMethodID, prevHash, cryptographicKeyID
  )
  VALUES
  (
    @projectID, @userID, GETDATE(),
    @amount, @encryptedAmt, N'CRC',
    0, 0, @approvedStatus,
    NULL, @paymentMethodID, @encryptedPrev, @cryptoKeyID
  );
  SET @contribID = SCOPE_IDENTITY();

  -- 12) Retornar resultados
  SELECT
    @contribID       AS contributionID,
    @projectID       AS projectID,
    @userID          AS userID,
    @amount          AS investedAmount,
    @totalSolicited  AS totalRequested,
    @sumInvested     AS alreadyInvested,
    @equityPct       AS equityPercent,
    @encryptedAmt    AS encryptedAmount,
    @encryptedPrev   AS prevHash;
END;
GO

--------------------------------------------------------------------------------
-- EVIDENCIA A: compilación exitosa
-- (Si el CREATE PROCEDURE arriba no arroja errores, compiló bien)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EVIDENCIA B: prueba de ejecución
--------------------------------------------------------------------------------
EXEC dbo.invertir
  @projectID       = 1,
  @userID          = 151,
  @amount          = 2468.02,
  @paymentMethodID = 1;
GO

--------------------------------------------------------------------------------
-- EVIDENCIA C: verificar symmetric key usada
--------------------------------------------------------------------------------
SELECT
  sk.name            AS symmetricKeyName,
  KEY_GUID(sk.name)  AS symmetricKeyGUID
FROM sys.symmetric_keys sk
WHERE sk.name = 'SK_User_151';
GO

--------------------------------------------------------------------------------
-- EVIDENCIA D: verificar inserción en contributions
--------------------------------------------------------------------------------
SELECT TOP 1
  crowdfundinCotributionID AS contributionID,
  projectID,
  userID,
  amount,
  encryptedAmount,
  prevHash,
  cryptographicKeyID
FROM dbo.pv_crowdfundingContributions
WHERE userID = 151
ORDER BY crowdfundinCotributionID DESC;
GO


-- Desencriptar para comprobar

-- Abre la key del usuario
OPEN SYMMETRIC KEY [SK_User_151]
  DECRYPTION BY CERTIFICATE [Cert_UserKey];

-- Desencripta el monto de la última contribución
SELECT
  crowdfundinCotributionID,
  CAST(
    CONVERT(varchar(50), DecryptByKey(encryptedAmount))
    AS DECIMAL(18,2)
  ) AS decryptedAmount
FROM dbo.pv_crowdfundingContributions
WHERE userID = 151
  AND crowdfundinCotributionID = 8;  -- o el ID que corresponda

-- Cierra la key
CLOSE SYMMETRIC KEY [SK_User_151];
