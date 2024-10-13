USE RevolutDB;
GO

CREATE OR ALTER PROCEDURE USP_GetTransactionConvertedToBGN
(@AccountId INT)
AS
BEGIN
	SELECT *
	FROM Accounts.Transactions AS t
		INNER JOIN Accounts.Accounts AS aa ON t.AccountId = aa.AccountId
	WHERE t.AccountId = @AccountId AND aa.State = 1
END
GO
