USE RevolutDB;
GO

CREATE OR ALTER FUNCTION Currencies.f_AmountToCurrency
(
	@iAmount MONEY,
	@iCurrencyCode VARCHAR(3),
	@iExchangeDate DATE = GETDATE,
	@iExchangeAction BIT = 0 -- 0 - Sell, 1 - Buy
)
RETURNS MONEY
AS
BEGIN
	DECLARE @oAmount MONEY;

	--SELECT @oAmount = iif(@iExchangeAction = 0, Sell, Buy) * @iAmount
	--FROM Currencies.ExchangeRates er
	--	INNER JOIN Currencies.Currencies c on c.CurrencyId = er.CurrencyId
	--WHERE c.Code = @iCurrencyCode and er.ExchangeDate = @iExchangeDate;

	SELECT @oAmount = 
	CASE @iExchangeAction
		WHEN 0 THEN Sell * @iAmount
		ELSE Buy * @iAmount
	END
	FROM Currencies.ExchangeRates er
		INNER JOIN Currencies.Currencies c on c.CurrencyId = er.CurrencyId
	WHERE c.Code = @iCurrencyCode and er.ExchangeDate = @iExchangeDate;

	RETURN @oAmount
END
GO

CREATE VIEW Accounts.VW_AccountsInformation
AS
SELECT act.Name, Balance, act.Code, FirstName, LastName, PermanentAccountNumber, ValidationDate
FROM Accounts.Accounts ac
	INNER JOIN Accounts.AccountTypes act on act.AccountTypeId = ac.AccountTypeId
	INNER JOIN Currencies.Currencies c on c.CurrencyId = ac.CurrencyId
	INNER JOIN Users.Clients cl on cl.ClientId = ac.ClientId
	INNER JOIN Users.Users u on u.UserId = cl.UserId
	INNER JOIN Cards.Cards crd on crd.CardId = ac.CardId;
GO