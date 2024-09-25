USE RevolutDB;
GO

CREATE OR ALTER TRIGGER Cards.TR_ForDeleteCard
ON Cards.Cards
FOR DELETE
AS
BEGIN
	IF EXISTS(SELECT 1
		FROM deleted
		WHERE ValidationDate >= GETDATE() OR State = 1
	)
	BEGIN
		PRINT 'You cannot perform delete on valid cards';
		ROLLBACK TRANSACTION;
	END
END
GO

--When creating account, create transactions for 5 from this account into another
CREATE OR ALTER TRIGGER Accounts.TR_ForInsertAccount
ON Accounts.Accounts
AFTER INSERT
AS
BEGIN
	IF EXISTS (SELECT 1
		FROM inserted
		WHERE Balance < 5
	)
	BEGIN
		PRINT 'You cannot create account with balance less than 5.';
		ROLLBACK TRANSACTION;
		RETURN;
	END

	DECLARE @destinationIBAN VARCHAR(34);

	SELECT TOP 1 @destinationIBAN = IBAN FROM Accounts.Accounts WHERE AccountId = 1

	INSERT INTO Accounts.Transactions (AccountId, ReceiverIBAN, Amount, CurrencyId)
	SELECT AccountId, @destinationIBAN, 5, 1
	FROM inserted;
	
	UPDATE Accounts.Accounts
	SET Balance = Balance + 5 * (SELECT TOP 1 COUNT(1) FROM inserted WHERE AccountId != 1)
	WHERE IBAN = @destinationIBAN

	SELECT @destinationIBAN

	UPDATE a
	SET Balance = a.Balance - 5
	FROM Accounts.Accounts a
		INNER JOIN inserted i on i.AccountId = a.AccountId
	WHERE a.AccountId != 1
END
GO