    --������ �� ���� ������ AdventureWorks2017 ��������� ������:
    --a) ������� ��� ������� �� ������� Sales.SalesTerritory.

	SELECT *
	FROM Sales.SalesTerritoryHistory

    --b) ������� ������� TerritoryID � Name �� ������� Sales.SalesTerritory.

	SELECT TerritoryID, Name
	FROM Sales.SalesTerritory


    --c) ������� ��� ������, ������� ���������� ��� ����� �� Person.Person � LastName = �Norman�.

	SELECT *
	FROM Person.Person
	WHERE LastName IN ('Norman')

    --d) ������� ��� ������ �� Person.Person, ��� EmailPromotion �� ����� 2. 

	SELECT *
	FROM Person.Person
	WHERE EmailPromotion NOT IN (2)
