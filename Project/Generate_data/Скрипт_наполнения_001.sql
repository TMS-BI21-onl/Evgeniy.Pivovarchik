CREATE DATABASE GymsBase

GO
USE GymsBase
CREATE TABLE dbo.ClientsSubs (
	ClientsSubID INT PRIMARY KEY IDENTITY (1,1),
	PassportNumber NVARCHAR(14) NOT NULL UNIQUE (PassportNumber),
	RegistrationDate DATE NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	PhoneNumber NVARCHAR(15) NOT NULL,
	Email NVARCHAR(50) DEFAULT 'N/A',
	SubscriptionDateStart DATE,
	SubsciptrionDateEnd DATE,
	SubsciptionDatePurchase DATE NOT NULL,
	SubscriptionName NVARCHAR(50) NOT NULL,
	Duration INT NOT NULL,
	Cost MONEY NOT NULL CHECK (Cost > 0),
	StatusSubscription NVARCHAR(20) NOT NULL
)
GO

CREATE TABLE dbo.Employees (
	EmployeeID INT PRIMARY KEY IDENTITY (1,1),
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	PassportNumber NVARCHAR(14) NOT NULL UNIQUE (PassportNumber),
	PhoneNumber NVARCHAR(15) NOT NULL,
	Category INT NOT NULL,
	Position NVARCHAR(50) NOT NULL,
	SalaryPerHour MONEY NOT NULL CHECK (SalaryPerHour > 0),
	PersonalTrainCost MONEY DEFAULT 0,
	OrganizationRate FLOAT DEFAULT 0
)
GO

CREATE TABLE dbo.Filials (
	FilialsID INT PRIMARY KEY IDENTITY (1,1),
	[Name] NVARCHAR(50) NOT NULL,
	[Address] NVARCHAR(100) NOT NULL
)
GO

CREATE TABLE dbo.VisitEmployees (
	VisitEmployeeID INT PRIMARY KEY IDENTITY(1,1),
	EmployeeID INT FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
	DateStart DATETIME,
	DateEnd DATETIME,
	FilialsID INT FOREIGN KEY (FilialsID) REFERENCES Filials (FilialsID)
 )
GO

CREATE TABLE dbo.VisitClients (
	VisitClientID INT PRIMARY KEY IDENTITY(1,1),
	ClientsSubID INT FOREIGN KEY (ClientsSubID) REFERENCES ClientsSubs (ClientsSubID),
	VisitDate DATE NOT NULL,
	FilialsID INT FOREIGN KEY (FilialsID) REFERENCES Filials (FilialsID),
	VisitEmployeeID INT FOREIGN KEY (VisitEmployeeID) REFERENCES VisitEmployees (VisitEmployeeID)
)



/*Foreign key
ALTER TABLE VisitEmployees
ADD FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)

ALTER TABLE VisitEmployees
ADD FOREIGN KEY (FilialsID) REFERENCES Filials (FilialsID)

ALTER TABLE VisitClients
ADD FOREIGN KEY (ClientsSubID) REFERENCES ClientsSubs (ClientsSubID)

ALTER TABLE VisitClients
ADD FOREIGN KEY (FilialsID) REFERENCES Filials (FilialsID)

ALTER TABLE VisitClients
ADD FOREIGN KEY (VisitEmployeeID) REFERENCES VisitEmployees (VisitEmployeeID)
*/


---------------------------------------------------------------------------------------------------------------------------------------------------
dbo.Employees
---------------------------------------------------------------------------------------------------------------------------------------------------
WITH 
FN AS
(SELECT DISTINCT pp.FirstName
 FROM Person.Person pp),
LN AS
(SELECT DISTINCT pp.LastName
 FROM Person.Person pp),
EMP AS
(SELECT TOP (1000) 
       FN.FirstName
	  ,LN.LastName
	  ,CONCAT(LEFT(FirstName,1), LEFT(LastName,1), SUBSTRING( CAST(ABS(CHECKSUM(NEWID())) AS varchar(50)) , 1 , 6)) AS PassportNumber
	  ,CAST(CONCAT('802',SUBSTRING( CAST(ABS(CHECKSUM(NEWID())) AS varchar(20)) , 1 , 8)) AS nvarchar) AS PhoneNumber
	  ,CASE ABS(CHECKSUM(NEWID())) % 8
			WHEN 0 THEN 'Administrator'
			WHEN 1 THEN 'Economist'
			WHEN 2 THEN 'Cleaner'
			WHEN 3 THEN 'Manager'
			WHEN 4 THEN 'Trainer 5'
			WHEN 5 THEN 'Trainer 4'
			WHEN 6 THEN 'Trainer 3'
			WHEN 7 THEN 'Trainer 2'
			ELSE 'Trainer 1' END AS P
 FROM FN
 CROSS JOIN LN
 ORDER BY NEWID()),
T_Employees AS
(SELECT EMP.FirstName
      ,EMP.LastName
	  ,EMP.PassportNumber
	  ,EMP.PhoneNumber
	  ,CASE WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('1','2','3','4','5') THEN CAST(SUBSTRING(EMP.P,9,1) AS INT)
			ELSE 0 END AS Category
      ,CASE WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' THEN CAST(SUBSTRING(EMP.P,1,7) AS nvarchar)
	        ELSE CAST(EMP.P AS nvarchar) END AS Position
      ,CASE WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('1') THEN CAST('25' AS money)
	        WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('2') THEN CAST('20' AS money)
			WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('3') THEN CAST('15' AS money)
			WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('4') THEN CAST('12' AS money)
			WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('5') THEN CAST('10' AS money)
			WHEN EMP.P = 'Administrator' THEN CAST('10' AS money)
			WHEN EMP.P = 'Economist' THEN CAST('15' AS money)
			WHEN EMP.P = 'Cleaner' THEN CAST('10' AS money)
			WHEN EMP.P = 'Manager' THEN CAST('15' AS money)
            END AS SalaryPerHour
      ,CASE WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('1') THEN CAST('50' AS money)
	        WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('2') THEN CAST('40' AS money)
			WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('3') THEN CAST('30' AS money)
			WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('4') THEN CAST('20' AS money)
			WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' AND SUBSTRING(EMP.P,9,1) IN ('5') THEN CAST('15' AS money)
			ELSE 0 END AS PersonalTrainCost
      ,CASE WHEN SUBSTRING(EMP.P,1,7) = 'Trainer' THEN CAST('0.2' AS FLOAT)
			END AS OrganizationRate
FROM EMP)

INSERT INTO [GymsBase].[dbo].[Employees] ([FirstName], [LastName], [PassportNumber], [PhoneNumber], [Category], [Position], [SalaryPerHour], [PersonalTrainCost], [OrganizationRate])
SELECT *
FROM T_Employees

---------------------------------------------------------------------------------------------------------------------------------------------------
dbo.Filials
---------------------------------------------------------------------------------------------------------------------------------------------------

WITH 
AddressC AS
(SELECT 'PB BREST' AS a 
 UNION SELECT 'PB MINSK' AS b
 UNION SELECT 'PB GRODNO' AS c
 UNION SELECT 'PB MOGILEV' AS d
 UNION SELECT 'PB VITEBSK' AS e
 UNION SELECT 'AVSTRIA VENA' AS f
 UNION SELECT 'GERMANIA BERLIN' AS g
 UNION SELECT 'ITALIA RIM' AS h
 UNION SELECT 'IRLANDIA DUBLIN' AS t
 UNION SELECT 'ISPANIA MADRID' AS o
 UNION SELECT 'NORVEGIA OSLO' AS p
 UNION SELECT 'CERBIA BELGRAD' AS s
 UNION SELECT 'ESTONIA TALLIN' AS j),
AddressS AS
(SELECT 'A' AS a 
 UNION SELECT 'B' AS b
 UNION SELECT 'C' AS c
 UNION SELECT 'D' AS d
 UNION SELECT 'E' AS e
 UNION SELECT 'F' AS f
 UNION SELECT 'G' AS g
 UNION SELECT 'H' AS h
 UNION SELECT 'T' AS t
 UNION SELECT 'O' AS o
 UNION SELECT 'P' AS p
 UNION SELECT 'S' AS s
 UNION SELECT 'J' AS j),
AddressH AS
(SELECT 'A' AS a 
 UNION SELECT 'B' AS b
 UNION SELECT 'C' AS c
 UNION SELECT 'D' AS d
 UNION SELECT 'E' AS e
 UNION SELECT 'F' AS f
 UNION SELECT 'G' AS g
 UNION SELECT 'H' AS h
 UNION SELECT 'T' AS t
 UNION SELECT 'O' AS o
 UNION SELECT 'P' AS p
 UNION SELECT 'S' AS s
 UNION SELECT 'J' AS j),
T_Filials AS 
(SELECT TOP 1000
        CASE AddressC.a WHEN 'PB BREST' THEN 'FILIAL 1 PB BREST'
		                WHEN 'PB MINSK' THEN 'FILIAL 2 PB MINSK'
						WHEN 'PB GRODNO' THEN 'FILIAL 3 PB GRODNO'
						WHEN 'PB MOGILEV' THEN 'FILIAL 4 PB MOGILEV'
						WHEN 'PB VITEBSK' THEN 'FILIAL 5 PB VITEBSK'
						WHEN 'AVSTRIA VENA' THEN 'FILIAL 6 AVSTRIA VENA'
						WHEN 'GERMANIA BERLIN' THEN 'FILIAL 7 GERMANIA BERLIN'
						WHEN 'ITALIA RIM' THEN 'FILIAL 8 ITALIA RIM'
						WHEN 'IRLANDIA DUBLIN' THEN 'FILIAL 9 IRLANDIA DUBLIN'
						WHEN 'ISPANIA MADRID' THEN 'FILIAL 10 ISPANIA MADRID'
						WHEN 'NORVEGIA OSLO' THEN 'FILIAL 11 NORVEGIA OSLO'
						WHEN 'CERBIA BELGRAD' THEN 'FILIAL 12 CERBIA BELGRAD'
						WHEN 'ESTONIA TALLIN' THEN 'FILIAL 13 ESTONIA TALLIN'
						ELSE 'N/A' END AS [Name]
	    ,CONCAT(AddressC.a,',Street',AddressS.a,',House',AddressH.a,'',ABS(CHECKSUM(NEWID())) % 143) AS [Address]
 FROM AddressC
 CROSS JOIN AddressS
 CROSS JOIN AddressH
 ORDER BY NEWID())

INSERT INTO [GymsBase].[dbo].[Filials] ([Name], [Address])
SELECT *
FROM T_Filials

---------------------------------------------------------------------------------------------------------------------------------------------------
dbo.ClientsSubs
---------------------------------------------------------------------------------------------------------------------------------------------------

WITH 
FN AS
(SELECT DISTINCT pp.FirstName
 FROM Person.Person pp),
LN AS
(SELECT DISTINCT pp.LastName
 FROM Person.Person pp),
SUB AS
(SELECT TOP (1000) 
        CONCAT(LEFT(FirstName,1), LEFT(LastName,1), SUBSTRING( CAST(ABS(CHECKSUM(NEWID())) AS varchar(50)) , 1 , 6)) AS PassportNumber
	   ,CAST(DATEADD(minute , -ABS(CHECKSUM(NEWID()))/1000 , GETDATE()) AS Date) AS RegistrationDate
	   ,FN.FirstName
	   ,LN.LastName
	   ,CONCAT('802',SUBSTRING( CAST(ABS(CHECKSUM(NEWID())) AS varchar(20)) , 1 , 8)) AS PhoneNumber
	   ,CONCAT(LEFT(UPPER(FirstName),2),LEFT(LOWER(LastName),3),'@mail.com') AS Email
	   ,CASE ABS(CHECKSUM(NEWID())) % 8
			 WHEN 0 THEN 'Classic'
			 WHEN 1 THEN 'Classic'
			 WHEN 2 THEN 'Classic'
			 WHEN 3 THEN 'Gold'
			 WHEN 4 THEN 'Gold'
			 WHEN 5 THEN 'Platinum'
			 WHEN 6 THEN 'Black'
			 WHEN 7 THEN 'VIP'
			 ELSE 'Classic' END AS SubscriptionName
      ,CASE ABS(CHECKSUM(NEWID())) % 8
			 WHEN 0 THEN 1
			 WHEN 1 THEN 3
			 WHEN 2 THEN 6
			 WHEN 3 THEN 12
			 WHEN 4 THEN 12
			 WHEN 5 THEN 24
			 WHEN 6 THEN 24
			 WHEN 7 THEN 36
			 ELSE 12 END AS Duration
 FROM FN
 CROSS JOIN LN
 ORDER BY NEWID()),
 Clients AS
(SELECT *
       ,RegistrationDate AS SubsciptionDatePurchase
	   ,CASE ABS(CHECKSUM(NEWID())) % 8
			 WHEN 0 THEN DATEADD(DAY,8,RegistrationDate)
			 WHEN 1 THEN DATEADD(DAY,1,RegistrationDate)
			 WHEN 2 THEN DATEADD(DAY,3,RegistrationDate)
			 WHEN 3 THEN DATEADD(DAY,7,RegistrationDate)
			 WHEN 4 THEN DATEADD(DAY,2,RegistrationDate)
			 WHEN 5 THEN DATEADD(DAY,5,RegistrationDate)
			 WHEN 6 THEN DATEADD(DAY,10,RegistrationDate)
			 WHEN 7 THEN DATEADD(DAY,15,RegistrationDate)
			 ELSE DATEADD(DAY,0,RegistrationDate) END AS SubscriptionDateStartOLD
       ,CASE WHEN SubscriptionName = 'Classic' AND Duration = '1' THEN 6*1 *10
	         WHEN SubscriptionName = 'Classic' AND Duration = '3' THEN 6*3 *10
			 WHEN SubscriptionName = 'Classic' AND Duration = '6' THEN 6*6 *9
			 WHEN SubscriptionName = 'Classic' AND Duration = '12' THEN 6*12 *9
			 WHEN SubscriptionName = 'Classic' AND Duration = '24' THEN 6*24 *8
			 WHEN SubscriptionName = 'Classic' AND Duration = '36' THEN 6*36 *8
	         WHEN SubscriptionName = 'Gold' AND Duration = '1' THEN 8*1 *10
			 WHEN SubscriptionName = 'Gold' AND Duration = '3' THEN 8*3 *10
			 WHEN SubscriptionName = 'Gold' AND Duration = '6' THEN 8*6 *9 
			 WHEN SubscriptionName = 'Gold' AND Duration = '12' THEN 8*12 *9 
			 WHEN SubscriptionName = 'Gold' AND Duration = '24' THEN 8*24 *8 
			 WHEN SubscriptionName = 'Gold' AND Duration = '36' THEN 8*36 *8 
			 WHEN SubscriptionName = 'Platinum' AND Duration = '1' THEN 10*1 *10
			 WHEN SubscriptionName = 'Platinum' AND Duration = '3' THEN 10*3 *10
			 WHEN SubscriptionName = 'Platinum' AND Duration = '6' THEN 10*6 *9
			 WHEN SubscriptionName = 'Platinum' AND Duration = '12' THEN 10*12 *9
			 WHEN SubscriptionName = 'Platinum' AND Duration = '24' THEN 10*24 *8
			 WHEN SubscriptionName = 'Platinum' AND Duration = '36' THEN 10*36 *8
			 WHEN SubscriptionName = 'Black' AND Duration = '1' THEN 12*1 *10 
			 WHEN SubscriptionName = 'Black' AND Duration = '3' THEN 12*3 *10 
			 WHEN SubscriptionName = 'Black' AND Duration = '6' THEN 12*6 *9 
			 WHEN SubscriptionName = 'Black' AND Duration = '12' THEN 12*12 *9 
			 WHEN SubscriptionName = 'Black' AND Duration = '24' THEN 12*24 *8 
			 WHEN SubscriptionName = 'Black' AND Duration = '36' THEN 12*36 *8 
			 WHEN SubscriptionName = 'VIP' AND Duration = '1' THEN 15*1 *10 
			 WHEN SubscriptionName = 'VIP' AND Duration = '3' THEN 15*3 *10 
			 WHEN SubscriptionName = 'VIP' AND Duration = '6' THEN 15*6 *9 
			 WHEN SubscriptionName = 'VIP' AND Duration = '12' THEN 15*12 *9 
			 WHEN SubscriptionName = 'VIP' AND Duration = '24' THEN 15*24 *8 
			 WHEN SubscriptionName = 'VIP' AND Duration = '36' THEN 15*36 *8 
			 END AS Cost
 FROM SUB),
DATESTARTSUB AS
(SELECT *
       ,CASE WHEN SubscriptionDateStartOLD > GETDATE() THEN CAST(GETDATE() AS Date)
	         ELSE CAST(SubscriptionDateStartOLD AS Date) END AS SubscriptionDateStart
 FROM Clients),
T_ClientsSubs AS
(SELECT PassportNumber
		,RegistrationDate
		,FirstName
		,LastName
		,PhoneNumber
		,Email
		,SubscriptionDateStart
      ,CAST(DATEADD(month,Duration,SubscriptionDateStart) AS Date) AS SubsciptrionDateEnd
		,SubsciptionDatePurchase
		,SubscriptionName
		,Duration
		,Cost
	  ,CASE WHEN DATEADD(month,Duration,SubscriptionDateStart) < GETDATE() THEN 'Finished'
			WHEN SubscriptionDateStart IS NULL THEN 'Inactive'
	        WHEN DATEADD(month,Duration,SubscriptionDateStart) >= GETDATE() THEN 'Active'
			END AS StatusSubscription

FROM DATESTARTSUB)

INSERT INTO [GymsBase].[dbo].[ClientsSubs] ([PassportNumber], [RegistrationDate], [FirstName], [LastName], [PhoneNumber], [Email], [SubscriptionDateStart],
            [SubsciptrionDateEnd], [SubsciptionDatePurchase], [SubscriptionName], [Duration], [Cost], [StatusSubscription])
SELECT *
FROM T_ClientsSubs
ORDER BY RegistrationDate


---------------------------------------------------------------------------------------------------------------------------------------------------
dbo.VisitEmployees
---------------------------------------------------------------------------------------------------------------------------------------------------

WITH 
T_Employees AS
(SELECT EmployeeID
 FROM [GymsBase].[dbo].[Employees]),
T_Filials AS
(SELECT FilialsID
 FROM [GymsBase].[dbo].[Filials]),
VisitEmployees AS (
SELECT TOP 1000000  EmployeeID
                ,CASE WHEN CAST(DATEADD(minute , -ABS(CHECKSUM(NEWID()))/1000 , GETDATE()) AS Date) < (SELECT min(RegistrationDate) AS MIN_DATE FROM [GymsBase].[dbo].[ClientsSubs]) THEN (SELECT min(RegistrationDate) AS MIN_DATE FROM [GymsBase].[dbo].[ClientsSubs])
				      WHEN CAST(DATEADD(minute , -ABS(CHECKSUM(NEWID()))/1000 , GETDATE()) AS Date) > GETDATE() THEN GETDATE()
				 ELSE CAST(DATEADD(minute , -ABS(CHECKSUM(NEWID()))/1000 , GETDATE()) AS Date) END AS DateStartOLD
				,FilialsID
FROM T_Employees
CROSS JOIN T_Filials
ORDER BY newid()),
VisitEmployees2 AS 
(SELECT EmployeeID
	   ,CASE ABS(CHECKSUM(NEWID())) % 8
					  WHEN 0 THEN DATEADD(hour,2,DateStartOLD)
					  WHEN 1 THEN DATEADD(hour,3,DateStartOLD)
					  WHEN 2 THEN DATEADD(hour,4,DateStartOLD)
					  WHEN 3 THEN DATEADD(hour,5,DateStartOLD)
					  WHEN 4 THEN DATEADD(hour,6,DateStartOLD)
					  WHEN 5 THEN DATEADD(hour,7,DateStartOLD)
					  WHEN 6 THEN DATEADD(hour,8,DateStartOLD)
					  WHEN 7 THEN DATEADD(hour,9,DateStartOLD)
					  WHEN 8 THEN DATEADD(hour,10,DateStartOLD)
					  ELSE DATEADD(hour,6,DateStartOLD) END AS DateStart
	   ,FilialsID                         
FROM VisitEmployees),
T_VisitEmployees AS
(SELECT EmployeeID
       ,DateStart
	   ,CASE ABS(CHECKSUM(NEWID())) % 8
					  WHEN 0 THEN DATEADD(hour,2,DateStart)
					  WHEN 1 THEN DATEADD(hour,3,DateStart)
					  WHEN 2 THEN DATEADD(hour,4,DateStart)
					  WHEN 3 THEN DATEADD(hour,5,DateStart)
					  WHEN 4 THEN DATEADD(hour,6,DateStart)
					  WHEN 5 THEN DATEADD(hour,7,DateStart)
					  WHEN 6 THEN DATEADD(hour,8,DateStart)
					  WHEN 7 THEN DATEADD(hour,9,DateStart)
					  WHEN 8 THEN DATEADD(hour,10,DateStart)
					  ELSE DATEADD(hour,6,DateStart) END AS DateEnd
	   ,FilialsID
FROM VisitEmployees2)
INSERT INTO [GymsBase].[dbo].[VisitEmployees] ([EmployeeID], [DateStart], [DateEnd], [FilialsID])
SELECT *
FROM T_VisitEmployees

---------------------------------------------------------------------------------------------------------------------------------------------------
dbo.VisitClients
---------------------------------------------------------------------------------------------------------------------------------------------------

WITH 
T_ClientsSubs AS
(SELECT ClientsSubID
 FROM [GymsBase].[dbo].[ClientsSubs]
 UNION
 SELECT ClientsSubID
 FROM [GymsBase].[dbo].[ClientsSubs]
 UNION
 SELECT ClientsSubID
 FROM [GymsBase].[dbo].[ClientsSubs]),
T_ClientsSubs2 AS
(SELECT ClientsSubID, SubscriptionDateStart, SubsciptrionDateEnd
 FROM [GymsBase].[dbo].[ClientsSubs]
 WHERE SubscriptionDateStart IS NOT NULL),
T_Filials AS
(SELECT TOP 30 FilialsID
 FROM [GymsBase].[dbo].[Filials]
 ORDER BY newid()),
EMP AS
(SELECT TOP 10000000 [VisitEmployeeID], CAST([DateStart] AS Date) AS DateStart
 FROM [GymsBase].[dbo].[VisitEmployees]
 ORDER BY NEWID()),
VisitClients AS 
(SELECT TOP 10000000 ClientsSubID
       ,FilialsID
       ,ROW_NUMBER() OVER (PARTITION BY ClientsSubID ORDER BY ClientsSubID DESC) AS s
 FROM T_ClientsSubs c
 CROSS JOIN T_Filials
 ORDER BY NEWID()),
 VisitClients2 AS 
(SELECT v.ClientsSubID
       ,v.FilialsID
	   ,c.SubscriptionDateStart
	   ,c.SubsciptrionDateEnd
	   ,MIN(v.FilialsID) OVER (PARTITION BY v.ClientsSubID ORDER BY v.FilialsID) AS r
       ,v.s
 FROM VisitClients v
 JOIN T_ClientsSubs2 c ON c.ClientsSubID = v.ClientsSubID
 ),
T_VisitClients AS
(SELECT ClientsSubID
       ,SubscriptionDateStart
       ,CASE WHEN r = s THEN  SubscriptionDateStart
	         WHEN r != s AND SubsciptrionDateEnd > DATEADD(day,ABS(CHECKSUM(NEWID())) % 17*3+1,SubscriptionDateStart) THEN DATEADD(day,ABS(CHECKSUM(NEWID())) % 17*3+1,SubscriptionDateStart)
			 ELSE SubsciptrionDateEnd
		END AS VisitDate
	   ,FilialsID
	   ,e.VisitEmployeeID
 FROM VisitClients2 v
 LEFT JOIN EMP e ON e.DateStart = v.SubscriptionDateStart
 ),
 T_LastVersion AS
 (
 SELECT TOP 1000000 ClientsSubID
       ,VisitDate
	   ,FilialsID
	   ,CASE WHEN VisitDate = SubscriptionDateStart THEN VisitEmployeeID
	    END AS VisitEmployeeID
 FROM T_VisitClients
 ORDER BY NEWID()
 )

 SELECT ClientsSubID
       ,VisitDate
	   ,FilialsID
	   ,VisitEmployeeID
 FROM T_LastVersion
 ORDER BY ClientsSubID, VisitDate


