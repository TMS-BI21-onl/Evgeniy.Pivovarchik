/*SELECT name, CONCAT(city, ', ', address)
FROM AdventureWorks2017.dbo.MOCK_DATA_filials

INSERT INTO GymProject.dbo.Filials 
SELECT name, CONCAT(city, ', ', address)
FROM AdventureWorks2017.dbo.MOCK_DATA_filials

SELECT * FROM GymProject.dbo.Filials 

ALTER TABLE GymProject.dbo.Employees 
ADD CONSTRAINT PassportNumber default NEWID () FOR PassportNumber

CREATE TABLE AdventureWorks2017.dbo.GeneratePositions
	(Position NVARCHAR(50))

INSERT INTO dbo.GeneratePositions (Position) VALUES 
('Manager'), ('Trainer'), ('Cleaner'), ('Accounter'), ('Economist'), ('Administrator');

SELECT Position FROM AdventureWorks2017.dbo.GeneratePositions

TRUNCATE TABLE GymProject.dbo.Filials

DROP DATABASE GymProject

ALTER TABLE AdventureWorks2017.dbo.MOCK_Employee
ADD Category INT,
	SalaryPerHour MONEY,
	PersonalTrainCost MONEY,
	OrganizationRate FLOAT

SELECT *
FROM AdventureWorks2017.dbo.MOCK_Employee

UPDATE AdventureWorks2017.dbo.MOCK_Employee SET Category = ABS(CONVERT(INT, (CONVERT(BINARY(5), (NEWID()))))) % 100;
UPDATE AdventureWorks2017.dbo.MOCK_Employee SET SalaryPerHour = ABS(CONVERT(INT, (CONVERT(BINARY(5), (NEWID()))))) % 100;
UPDATE AdventureWorks2017.dbo.MOCK_Employee SET PersonalTrainCost = ABS(CONVERT(INT, (CONVERT(BINARY(5), (NEWID()))))) % 100;
UPDATE AdventureWorks2017.dbo.MOCK_Employee SET OrganizationRate = ABS(CONVERT(INT, (CONVERT(BINARY(5), (NEWID()))))) % 100;

ALTER TABLE AdventureWorks2017.dbo.MOCK_Employee
ALTER COLUMN PersonalTrainCost INT

SELECT ABS(CONVERT(INT, (CONVERT(BINARY(5), (NEWID()))))) % 100
FROM sysobjects A
CROSS JOIN sysobjects B

SELECT DATEADD(DAY, FLOOR(rand()*23000), '1950-01-01');
*/
/*
Category - рандомом от 1 до 50
SalaryPerHour - рандом от 20 до 100
PersonalTrainCost - рандом от 20 до 100
OrganizationRate - random float от 5 до 50
*/
SELECT *, LEFT(P
FROM AdventureWorks2017.dbo.MOCK_Employee
'Manager', 'Trainer', 'Cleaner', 'Accounter', 'Economist', 'Administrator', 'Trainer', 'SMM-Manager', 'Trainer'

Загрузить данные в работников.