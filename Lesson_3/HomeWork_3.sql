--Task 2
--a)

SELECT StandardCost,
	CASE 
		WHEN StandardCost = 0 OR StandardCost IS NULL THEN 'Not for sale'
		WHEN StandardCost > 0 AND StandardCost < 100 THEN '<$100'
		WHEN StandardCost >= 100 AND StandardCost < 500 THEN '<$500'
	ELSE '>=500'
	END as PriceRange
FROM Production.Product

--b)

SELECT PPV.ProductID, PPV.BusinessEntityID, PV.Name
FROM Purchasing.Vendor PV
LEFT JOIN Purchasing.ProductVendor PPV
ON PV.BusinessEntityID = PPV.BusinessEntityID
WHERE PPV.StandardPrice > 10 AND (PV.Name LIKE '%X%' OR PV.Name LIKE 'N%')

--c)

SELECT Vend.Name
FROM Purchasing.Vendor Vend
	LEFT JOIN Purchasing.ProductVendor ProdVend
	ON Vend.BusinessEntityID = ProdVend.BusinessEntityID
WHERE ProdVend.BusinessEntityID IS NULL


--Task 3

--a) 

SELECT P.Name, P.StandardCost, PM.Name
FROM Production.Product P
	FULL JOIN Production.ProductModel PM
	ON P.ProductID = PM.ProductModelID
WHERE PM.Name LIKE 'LL%'

--b) 

SELECT Name
FROM Purchasing.Vendor
UNION
SELECT Name
FROM Sales.Store

--c) 

SELECT PP.Name
FROM Production.Product PP
LEFT JOIN Sales.SpecialOfferProduct SSOP
ON PP.ProductID = SSOP.ProductID
GROUP BY PP.Name
HAVING COUNT(SSOP.SpecialOfferID) > 1