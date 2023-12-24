    --4. ������ �� ���� ������ AdventureWorks2017 ��������� ������:
    --a) ������� ���������� PersonType ���������� ��� ����� �� Person.Person � LastName ������������ � ����� � ��� �� ���������� 1 � EmailPromotion.
		--answer: 6

	SELECT COUNT (DISTINCT PersonType)
	FROM Person.Person
	WHERE LastName LIKE 'M%' AND EmailPromotion NOT LIKE '%1%'
	
	--b) ������� ������ 3 ����������� ����������� �� Sales.SpecialOffer � ����������� DiscountPct, ������� �������� ����������� � 2013-01-01 �� 2014-01-01.
		--answer: ��. ��� ����

	SELECT TOP 3 *
	FROM Sales.SpecialOffer
	WHERE StartDate BETWEEN '2013-01-01' AND '2014-01-01'
	ORDER BY DiscountPct DESC
	   
	--c) ����� ����� ����������� ��� � ����� ������������ ������ �������� �� Production.Product.
		--answer: 
			-- ����������� ���: 2.12
			-- ������������ ������ (��������): 70
			-- ������������ ������ (���������): XL

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
	
	--d) ����� ����� ����������� ��� � ����� ������������ ������ �������� ��� ������ ������������ ProductSubcategoryID �� Production.Product. 
		--answer: ��. ��� ����

	SELECT ProductSubcategoryID, MIN(Weight) AS MinWeight, MAX(Size) AS MaxSize
	FROM Production.Product
	GROUP BY ProductSubcategoryID
	
	--e) ����� ����� ����������� ��� � ����� ������������ ������ �������� ��� ������ ������������ ProductSubcategoryID �� Production.Product, ��� ���� �������� ���������(Color).
		--answer: ��. ��� ����

	SELECT ProductSubcategoryID, MIN(Weight) AS MinWeight, MAX(Size) AS MaxSize
	FROM Production.Product
	WHERE Color IS NOT NULL
	GROUP BY ProductSubcategoryID