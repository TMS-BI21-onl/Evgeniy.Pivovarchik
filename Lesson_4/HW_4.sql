--3
--����� RANK � DENSE_RANK ������������ �� ���������� ������ ������ (������ �������� ������� ���������).
--��������, ��� � ���� ����
SELECT BusinessEntityID
	, ROW_NUMBER() OVER (ORDER BY BusinessEntityID) AS 'Row number'
	, RANK () OVER (ORDER BY BusinessEntityID) AS 'Rank'
	, DENSE_RANK () OVER (ORDER BY BusinessEntityID) AS 'Dense_rank'
FROM Person.Person

--4
--a) ������� ������ � ������� Production.UnitMeasure. 
--���������, ���� �� ����� UnitMeasureCode, ������������ �� ����� �Ғ. 
-- �����: ���

SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%'

--������� ����� ��������� ����� ����� ����? 
--�����: 38

SELECT RANK () OVER (ORDER BY UnitMeasureCode) AS 'Rank'
FROM Production.UnitMeasure


--�������� ��������� ����� ������ � �������:
--TT1, Test 1, 9 �������� 2020

INSERT INTO Production.UnitMeasure
VALUES ('TT1', 'Test 1', '2020-09-20')

--TT2, Test 2, getdate()

INSERT INTO Production.UnitMeasure
VALUES ('TT2', 'Test 2', GETDATE())

--��������� ������, ���� �� ����� UnitMeasureCode, ������������ �� ����� �Ғ. 
-- �����: ��, 2 ��������, ������� ���� ��������� ����
SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%'

--b) ������ ��������� ����������� ����� � �����, �� ������������ ������� Production.UnitMeasureTest. 

SELECT *
INTO Production.UnitMeasureTest
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%'

--��������� ���� ���������� �� Production.UnitMeasure �� UnitMeasureCode = �CAN�.  

INSERT INTO Production.UnitMeasureTest
SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode = 'CAN'

--���������� ��������� � ��������������� ���� �� ����. 

SELECT *
FROM Production.UnitMeasureTest
ORDER BY UnitMeasureCode

--c) �������� UnitMeasureCode ��� ����� ������ �� Production.UnitMeasureTest �� �TTT�.

UPDATE Production.UnitMeasureTest
SET UnitMeasureCode = 'TTT'

--d) ������� ��� ������ �� Production.UnitMeasureTest.

DELETE
FROM Production.UnitMeasureTest

--e) ������� ���������� �� Sales.SalesOrderDetail �� ������� 43659,43664.  

SELECT *
FROM Sales.SalesOrderDetail
WHERE SalesOrderID in ('43659', '43664')

--� ������� ������� ������� MAX, MIN, AVG ������ �������� �� LineTotal ��� ������� SalesOrderID.

SELECT *
	, MAX(LineTotal) OVER (PARTITION BY SalesOrderID) AS MaxLT
	, MIN(LineTotal) OVER (PARTITION BY SalesOrderID) AS MinLT
	, AVG(LineTotal) OVER (PARTITION BY SalesOrderID) AS AvgLT
FROM Sales.SalesOrderDetail
WHERE SalesOrderID in ('43659', '43664')

--f) ������� ������ � ������� Sales.vSalesPerson. 

SELECT *
FROM Sales.vSalesPerson

--�������� ������� c���� ��������� �� ������ ������� ������ SalesYTD, ��������� ����������� ������� �������. 
--�������� ���� Login, ��������� �� 3 ������ ���� ������� � ������� �������� + �login� + TerritoryGroup (Null �������� �� ������ ��������). 

SELECT BusinessEntityID, FirstName, LastName, TerritoryGroup, SalesYTD
	, CONCAT(LEFT(LastName, 3), 'login', ISNULL(TerritoryGroup, '')) AS Login
	, RANK () OVER (ORDER BY SalesYTD DESC) AS RankBySYTD
FROM Sales.vSalesPerson

--��� ����������� �������? 
--�����: 276	Linda	Mitchell	North America	4251368,5497	MitloginNorth America	1
--� ��� ���������� ������� � ������� ���� (SalesLastYear). 
--�����: 290	Ranjit	Varkey Chudukatil	Europe	2396539,7601	VarloginEurope	1

SELECT BusinessEntityID, FirstName, LastName, TerritoryGroup, SalesLastYear
	, CONCAT(LEFT(LastName, 3), 'login', ISNULL(TerritoryGroup, '')) AS Login
	, RANK () OVER (ORDER BY SalesLastYear DESC) AS RankBySYTD
FROM Sales.vSalesPerson


--g) ������� ������ ������ ���� ������ (FROM �� ����������). ����� ����������� ��� �� ��� �������.

SELECT CASE
         WHEN DATENAME(WEEKDAY, DATEADD(DD, -DATEPART(DD, GETDATE()) + 1, GETDATE())) = 'Saturday' THEN DATEADD(DD, -DATEPART(DD, GETDATE()) + 3, GETDATE())
         WHEN DATENAME(WEEKDAY, DATEADD(DD, -DATEPART(DD, GETDATE()) + 1, GETDATE())) = 'Sunday' THEN DATEADD(DD, -DATEPART(DD, GETDATE()) + 2, GETDATE())
         ELSE DATEADD(WEEKDAY, -DATEPART(DD, GETDATE()) + 1, GETDATE())
       END

--5
--count(1) = 4
--count(name) = 2
--count(id) = 4
--count(*) = 4