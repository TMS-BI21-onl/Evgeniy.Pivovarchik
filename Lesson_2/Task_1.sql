    --Решите на базе данных AdventureWorks2017 следующие задачи:
    --a) Извлечь все столбцы из таблицы Sales.SalesTerritory.

	SELECT *
	FROM Sales.SalesTerritoryHistory

    --b) Извлечь столбцы TerritoryID и Name из таблицы Sales.SalesTerritory.

	SELECT TerritoryID, Name
	FROM Sales.SalesTerritory


    --c) Найдите все данные, которые существует для людей из Person.Person с LastName = ‘Norman’.

	SELECT *
	FROM Person.Person
	WHERE LastName IN ('Norman')

    --d) Найдите все строки из Person.Person, где EmailPromotion не равен 2. 

	SELECT *
	FROM Person.Person
	WHERE EmailPromotion NOT IN (2)
