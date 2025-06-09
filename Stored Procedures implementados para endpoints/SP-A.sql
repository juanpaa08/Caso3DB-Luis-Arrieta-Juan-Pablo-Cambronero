USE Caso3DB;
GO

CREATE PROCEDURE sp_CreateUpdateProposal
  @ProposalID INT,
  @Name NVARCHAR(150),
  @UserID INT,
  @ProposalTypeID INT, -- Quitamos el = NULL para hacerlo obligatorio
  @IntegrityHash VARBINARY(512) = NULL,
  @Status NVARCHAR(50) OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRANSACTION;
  BEGIN TRY
    -- Validar que @ProposalTypeID no sea NULL
    IF @ProposalTypeID IS NULL
      THROW 50002, 'El ProposalTypeID es obligatorio.', 1;

    -- Generar un integrityHash predeterminado si es NULL
    DECLARE @FinalIntegrityHash VARBINARY(512);
    SET @FinalIntegrityHash = ISNULL(@IntegrityHash, HASHBYTES('SHA2_256', CAST(NEWID() AS NVARCHAR(36))));

    IF @ProposalID IS NULL
      BEGIN
        INSERT INTO pv_propposals (name, userID, proposalTypeID, createdAt, lastUpdate, integrityHash)
        VALUES (@Name, @UserID, @ProposalTypeID, GETDATE(), GETDATE(), @FinalIntegrityHash);
        SET @ProposalID = SCOPE_IDENTITY();
        SET @Status = 'Pending';
      END
    ELSE
      BEGIN
        UPDATE pv_propposals
        SET name = @Name, 
            userID = @UserID, 
            proposalTypeID = @ProposalTypeID, 
            lastUpdate = GETDATE(), 
            integrityHash = @FinalIntegrityHash
        WHERE proposalID = @ProposalID AND userID = @UserID;
        SET @Status = 'Pending';
      END

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    THROW 50001, @ErrorMessage, 1;
  END CATCH;
END;
GO


DECLARE @Status NVARCHAR(50);
EXEC sp_CreateUpdateProposal
  @ProposalID = 1,
  @Name = 'Proyecto Solar',
  @UserID = 1,
  @ProposalTypeID = 1, -- Debes proporcionar un valor válido
  @IntegrityHash = NULL,
  @Status = @Status OUTPUT;
SELECT @Status;


select * from pv_users;
SELECT * FROM pv_propposals;