USE master
ALTER DATABASE RevolutDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE IF EXISTS RevolutDB
GO

CREATE DATABASE RevolutDB
GO

USE RevolutDB
GO

CREATE SCHEMA Banks
GO

CREATE SCHEMA Accounts
GO

CREATE SCHEMA Currencies
GO

CREATE SCHEMA Cards
GO

CREATE SCHEMA Users
GO

CREATE TABLE Banks.Banks (
	BankId INT IDENTITY(1, 1) NOT NULL,
	BankIdentifierCode VARCHAR(11) NOT NULL,
	BankName NVARCHAR(150) NOT NULL,
	BranchName NVARCHAR(150) NOT NULL,
	Rating INT NOT NULL,
	AssetsAmount DECIMAL NOT NULL,

	CONSTRAINT PK_Banks_BankId PRIMARY KEY (BankId)
);
GO

/*
INSERT INTO Banks.Banks (BankIdentifierCode, BankName, BranchName, Rating, AssetsAmount)
VALUES ('PSH', 'Na Pesho Bankata', 'BRCH1', 2, 100000),
	('GSH', 'Na Gosho Bankata', 'BRCH1', 2, 500000)

SELECT * FROM Banks.Banks
*/

CREATE TABLE Accounts.AccountTypes (
	AccountTypeId INT IDENTITY(1, 1) NOT NULL,
	Code VARCHAR(3) NOT NULL,
	Name NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_AccountTypes_AccountTypeId PRIMARY KEY (AccountTypeId)
);
GO

/*
INSERT INTO Accounts.AccountTypes (Code, Name)
VALUES ('CUR', 'Current'),
	('SAV', 'Savings')
	
SELECT * FROM Accounts.AccountTypes
*/

CREATE TABLE Currencies.Currencies (
	CurrencyId INT IDENTITY(1, 1) NOT NULL,
	Code VARCHAR(3) NOT NULL,
	Name NVARCHAR(25) NOT NULL,
	CBDC BIT NOT NULL CONSTRAINT DF_Currencies_CBDC DEFAULT 0,

	CONSTRAINT PK_Currencies_CurrencyId PRIMARY KEY (CurrencyId),
	CONSTRAINT UQ_Currencies_Code UNIQUE (Code)
);
GO

/*
INSERT INTO Currencies.Currencies (Code, Name)
VALUES ('BGN', 'Bulgarian Leva'),
		('EUR', 'Euro'),
		('USD', 'United States Dollar'),
		('GBP', 'Great Britain Pound')

SELECT * FROM Currencies.Currencies
*/

CREATE TABLE Currencies.ExchangeRates (
	ExchangeRateId INT IDENTITY(1, 1) NOT NULL,
	CurrencyId INT NOT NULL,
	ExchangeDate DATETIME2(7) NOT NULL,
	Buy DECIMAL(7,6) NOT NULL CONSTRAINT DF_ExchangeRates_Buy DEFAULT 1,
	Sell DECIMAL(7,6) NOT NULL CONSTRAINT DF_ExchangeRates_Sell DEFAULT 1,

	CONSTRAINT PK_ExchangeRates_ExchangeRateId PRIMARY KEY (ExchangeRateId),
	CONSTRAINT FK_Currencies_ExchangeRates_CurrencyId FOREIGN KEY(CurrencyId) REFERENCES Currencies.Currencies(CurrencyId)
);
GO

/*
INSERT INTO Currencies.ExchangeRates (ExchangeDate, CurrencyId, Buy, Sell)
VALUES 
(CONVERT(DATETIME2(7), '02.09.2024', 104), 4, 2.32234, 0.430600),
(CONVERT(DATETIME2(7), '03.09.2024', 104), 4, 2.32602, 0.429919),
(CONVERT(DATETIME2(7), '04.09.2024', 104), 4, 2.32152, 0.430752),
(CONVERT(DATETIME2(7), '05.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '06.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '07.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '08.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '09.09.2024', 104), 4, 2.31830, 0.431351),
(CONVERT(DATETIME2(7), '10.09.2024', 104), 4, 2.32105, 0.430839),
(CONVERT(DATETIME2(7), '02.09.2024', 104), 3, 1.76822, 0.565540),
(CONVERT(DATETIME2(7), '03.09.2024', 104), 3, 1.77239, 0.564210),
(CONVERT(DATETIME2(7), '04.09.2024', 104), 3, 1.76998, 0.564978),
(CONVERT(DATETIME2(7), '05.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '06.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '07.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '08.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '09.09.2024', 104), 3, 1.77110, 0.564621),
(CONVERT(DATETIME2(7), '10.09.2024', 104), 3, 1.77303, 0.564006)

SELECT * FROM Currencies.ExchangeRates
*/

CREATE TABLE Users.Users (
	UserId INT IDENTITY(1, 1) NOT NULL,
	FirstName NVARCHAR(150) NOT NULL,
	LastName NVARCHAR(150) NOT NULL,
	NationalIdentityNumber NVARCHAR(15) NOT NULL,
	State TINYINT NOT NULL CONSTRAINT DF_Users_State DEFAULT 1,

	CONSTRAINT PK_Users_UserId PRIMARY KEY (UserId),
	CONSTRAINT UQ_Users_NationalIdentityNumber UNIQUE (NationalIdentityNumber)
);
GO

/*
INSERT INTO Users.Users (FirstName, LastName, NationalIdentityNumber)
VALUES ('Ivan', 'Ivanov', '437554735'),
	('Penka', 'Dimitrova', '675723623')

SELECT * FROM Users.Users
*/

CREATE TABLE Users.Clients (
	ClientId INT IDENTITY(1, 1) NOT NULL,
	UserId INT NOT NULL,

	CONSTRAINT PK_Clients_ClientId PRIMARY KEY (ClientId),
	CONSTRAINT FK_Users_Clients_UserId FOREIGN KEY (UserId) REFERENCES Users.Users (UserId)
);
GO

/*
INSERT INTO Users.Clients (UserId)
VALUES (1), (2)

SELECT * FROM Users.Clients
*/

CREATE TABLE Cards.Cards (
	CardId INT IDENTITY(1, 1) NOT NULL,
	PermanentAccountNumber NVARCHAR(19) NOT NULL,
	CVV NVARCHAR(3) NOT NULL,
	ValidationDate DATETIME2(7) NOT NULL,
	State TINYINT NOT NULL CONSTRAINT DF_Accounts_State DEFAULT 1,

	CONSTRAINT PK_Cards_CardId PRIMARY KEY (CardId)
);
GO
/*
INSERT INTO Cards.Cards (PermanentAccountNumber, CVV, ValidationDate)
VALUES ('FSIRT45RETES6YG', '524', '2025-11-11'),
('HGTR65ET45ETSGG', '743', '2026-01-27'),
('GSLERJ5N4RNSEL4', '825', '2025-06-14'),
('R34W6HTSLETS4E5', '264', '2023-03-20')

SELECT * FROM Cards.Cards
*/

CREATE TABLE Accounts.Accounts(
	AccountId INT IDENTITY(1, 1) NOT NULL,
	IBAN NVARCHAR(34) NOT NULL,
	Balance MONEY,
	BankId INT NOT NULL,
	ClientId INT NOT NULL,
	AccountTypeId INT NOT NULL,
	CurrencyId INT NOT NULL,
	CardId INT NOT NULL,
	State TINYINT NOT NULL CONSTRAINT DF_Accounts_State DEFAULT 1,

	CONSTRAINT PK_Accounts_AccountId PRIMARY KEY (AccountId),
	CONSTRAINT FK_Accounts_Accounts_BankId FOREIGN KEY (BankId) REFERENCES Banks.Banks (BankId),
	CONSTRAINT FK_Accounts_Accounts_ClientId FOREIGN KEY (ClientId) REFERENCES Users.Clients (ClientId),
	CONSTRAINT FK_Accounts_Accounts_AccountTypeId FOREIGN KEY (AccountTypeId) REFERENCES Accounts.AccountTypes (AccountTypeId),
	CONSTRAINT FK_Accounts_Accounts_CurrencyId FOREIGN KEY (CurrencyId) REFERENCES Currencies.Currencies (CurrencyId),
	CONSTRAINT FK_Cards_Accounts_CardId FOREIGN KEY (CardId) REFERENCES Cards.Cards(CardId),
	CONSTRAINT UQ_Accounts_Accounts_IBAN UNIQUE (IBAN),
);
GO

/*
TRUNCATE TABLE Accounts.Transactions
TRUNCATE TABLE Accounts.Accounts
INSERT INTO Accounts.Accounts (IBAN, Balance, BankId, ClientId, AccountTypeId, CurrencyId, CardId)
VALUES ('AG43676435345363', 1500, 1, 2, 1, 1, 1),
('GR53476574546547', 250, 2, 1, 1, 1, 2),
('HG64576243547436', 250, 2, 1, 2, 1, 3),
('HF42347673463674', 250, 1, 1, 1, 1, 4)

SELECT * FROM Accounts.Accounts
*/

CREATE TABLE Accounts.Transactions (
	TransactionId INT IDENTITY(1, 1) NOT NULL,
	AccountId INT NOT NULL,
	ReceiverIBAN NVARCHAR(34) NOT NULL,
	Amount MONEY NOT NULL,
	CurrencyId INT NOT NULL,
	CreatedOn DATETIME2(7) NOT NULL CONSTRAINT DF_Transactions_CreatedOn DEFAULT GETDATE(),
	State TINYINT NOT NULL CONSTRAINT DF_Transactions_State DEFAULT 1,

	CONSTRAINT PK_Accounts_TransactionId PRIMARY KEY (TransactionId),
	CONSTRAINT FK_Accounts_Transactions_AccountId FOREIGN KEY (AccountId) REFERENCES Accounts.Accounts (AccountId),
	CONSTRAINT FK_Accounts_Transactions_CurrencyId FOREIGN KEY (CurrencyId) REFERENCES Currencies.Currencies (CurrencyId)
);
GO

INSERT INTO Banks.Banks (BankIdentifierCode, BankName, BranchName, Rating, AssetsAmount)
VALUES ('PSH', 'Na Pesho Bankata', 'BRCH1', 2, 100000),
	('GSH', 'Na Gosho Bankata', 'BRCH1', 2, 500000)

INSERT INTO Accounts.AccountTypes (Code, Name)
VALUES ('CUR', 'Current'),
	('SAV', 'Savings')

INSERT INTO Currencies.Currencies (Code, Name)
VALUES ('BGN', 'Bulgarian Leva'),
		('EUR', 'Euro'),
		('USD', 'United States Dollar'),
		('GBP', 'Great Britain Pound')

INSERT INTO Currencies.ExchangeRates (ExchangeDate, CurrencyId, Buy, Sell)
VALUES 
(CONVERT(DATETIME2(7), '02.09.2024', 104), 4, 2.32234, 0.430600),
(CONVERT(DATETIME2(7), '03.09.2024', 104), 4, 2.32602, 0.429919),
(CONVERT(DATETIME2(7), '04.09.2024', 104), 4, 2.32152, 0.430752),
(CONVERT(DATETIME2(7), '05.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '06.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '07.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '08.09.2024', 104), 4, 2.31959, 0.431111),
(CONVERT(DATETIME2(7), '09.09.2024', 104), 4, 2.31830, 0.431351),
(CONVERT(DATETIME2(7), '10.09.2024', 104), 4, 2.32105, 0.430839),
(CONVERT(DATETIME2(7), '02.09.2024', 104), 3, 1.76822, 0.565540),
(CONVERT(DATETIME2(7), '03.09.2024', 104), 3, 1.77239, 0.564210),
(CONVERT(DATETIME2(7), '04.09.2024', 104), 3, 1.76998, 0.564978),
(CONVERT(DATETIME2(7), '05.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '06.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '07.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '08.09.2024', 104), 3, 1.76249, 0.567379),
(CONVERT(DATETIME2(7), '09.09.2024', 104), 3, 1.77110, 0.564621),
(CONVERT(DATETIME2(7), '10.09.2024', 104), 3, 1.77303, 0.564006)

INSERT INTO Users.Users (FirstName, LastName, NationalIdentityNumber)
VALUES ('Ivan', 'Ivanov', '437554735'),
	('Penka', 'Dimitrova', '675723623')
	
INSERT INTO Users.Clients (UserId)
VALUES (1), (2)

INSERT INTO Cards.Cards (PermanentAccountNumber, CVV, ValidationDate)
VALUES ('FSIRT45RETES6YG', '524', '2025-11-11'),
('HGTR65ET45ETSGG', '743', '2026-01-27'),
('GSLERJ5N4RNSEL4', '825', '2025-06-14'),
('R34W6HTSLETS4E5', '264', '2023-03-20')

INSERT INTO Accounts.Accounts (IBAN, Balance, BankId, ClientId, AccountTypeId, CurrencyId, CardId)
VALUES ('AG43676435345363', 1500, 1, 2, 1, 1, 1),
('GR53476574546547', 250, 2, 1, 1, 1, 2),
('HG64576243547436', 250, 2, 1, 2, 1, 3),
('HF42347673463674', 250, 1, 1, 1, 1, 4)

SELECT * FROM Accounts.Accounts

--SELECT act.Name, Balance, act.Code, FirstName, LastName, PermanentAccountNumber, ValidationDate
--FROM Accounts.Accounts ac
--	INNER JOIN Accounts.AccountTypes act on act.AccountTypeId = ac.AccountTypeId
--	INNER JOIN Currencies.Currencies c on c.CurrencyId = ac.CurrencyId
--	INNER JOIN Users.Clients cl on cl.ClientId = ac.ClientId
--	INNER JOIN Users.Users u on u.UserId = cl.UserId
--	INNER JOIN Cards.Cards crd on crd.CardId = ac.CardId

--SELECT *
--FROM Accounts.VW_AccountsInformation