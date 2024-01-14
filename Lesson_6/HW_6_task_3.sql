USE AdventureWorks2017
GO

CREATE PROCEDURE HumanResources.ChangeNationalIDNumber
	@BusinessEntityID INT,
	@NationalIDNumberNew NVARCHAR(15)
AS
BEGIN
	
	UPDATE HumanResources.Employee
	SET NationalIDNumber = @NationalIDNumberNew
	WHERE BusinessEntityID = @BusinessEntityID
END

EXECUTE HumanResources.ChangeNationalIDNumber @BusinessEntityID=15, @NationalIDNumberNew=879341111