    --4. Решите на базе данных AdventureWorks2017 следующие задачи:
    --a) Сколько уникальных PersonType существует для людей из Person.Person с LastName начинающиеся с буквы М или не содержащий 1 в EmailPromotion.
		--answer: 6

	SELECT COUNT (DISTINCT PersonType)
	FROM Person.Person
	WHERE LastName LIKE 'M%' AND EmailPromotion NOT LIKE '%1%'
	
	--b) Вывести первых 3 специальных предложений из Sales.SpecialOffer с наибольшими DiscountPct, которые начинали действовать с 2013-01-01 по 2014-01-01.
		--answer: см. код ниже

	SELECT TOP 3 *
	FROM Sales.SpecialOffer
	WHERE StartDate BETWEEN '2013-01-01' AND '2014-01-01'
	ORDER BY DiscountPct DESC
	   
	--c) Найти самый минимальный вес и самый максимальный размер продукта из Production.Product.
		--answer: 
			-- минимальный вес: 2.12
			-- максимальный размер (цифровой): 70
			-- максимальный размер (буквенный): XL

	SELECT TOP 1 Weight
	FROM Production.Product
	WHERE Weight IS NOT NULL
	ORDER BY Weight

	SELECT TOP 1 Size
	FROM Production.Product
	WHERE Size IS NOT NULL AND ISNUMERIC(SIZE) = 1
	ORDER BY Size DESC

	SELECT TOP 1 Size
	FROM Production.Product
	WHERE Size IS NOT NULL
	ORDER BY Size DESC
	
	--d) Найти самый минимальный вес и самый максимальный размер продукта для каждой подкатегории ProductSubcategoryID из Production.Product. 
		--answer: см. код ниже

	SELECT ProductSubcategoryID, MIN(Weight) AS MinWeight, MAX(Size) AS MaxSize
	FROM Production.Product
	GROUP BY ProductSubcategoryID
	
	--e) Найти самый минимальный вес и самый максимальный размер продукта для каждой подкатегории ProductSubcategoryID из Production.Product, где цвет продукта определен(Color).
		--answer: см. код ниже

	SELECT ProductSubcategoryID, MIN(Weight) AS MinWeight, MAX(Size) AS MaxSize
	FROM Production.Product
	WHERE Color IS NOT NULL
	GROUP BY ProductSubcategoryID