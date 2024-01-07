--3
--Когда RANK и DENSE_RANK отрабатывают на уникальном наборе данных (каждое значение выборки уникально).
--Например, как в коде ниже
SELECT BusinessEntityID
	, ROW_NUMBER() OVER (ORDER BY BusinessEntityID) AS 'Row number'
	, RANK () OVER (ORDER BY BusinessEntityID) AS 'Rank'
	, DENSE_RANK () OVER (ORDER BY BusinessEntityID) AS 'Dense_rank'
FROM Person.Person

--4
--a) Изучите данные в таблице Production.UnitMeasure. 
--Проверьте, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’. 
-- Ответ: Нет

SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%'

--Сколько всего различных кодов здесь есть? 
--Ответ: 38

SELECT RANK () OVER (ORDER BY UnitMeasureCode) AS 'Rank'
FROM Production.UnitMeasure


--Вставьте следующий набор данных в таблицу:
--TT1, Test 1, 9 сентября 2020

INSERT INTO Production.UnitMeasure
VALUES ('TT1', 'Test 1', '2020-09-20')

--TT2, Test 2, getdate()

INSERT INTO Production.UnitMeasure
VALUES ('TT2', 'Test 2', GETDATE())

--Проверьте теперь, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’. 
-- Ответ: Да, 2 значения, которые были добавлены выше
SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%'

--b) Теперь загрузите вставленный набор в новую, не существующую таблицу Production.UnitMeasureTest. 

SELECT *
INTO Production.UnitMeasureTest
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%'

--Догрузите сюда информацию из Production.UnitMeasure по UnitMeasureCode = ‘CAN’.  

INSERT INTO Production.UnitMeasureTest
SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode = 'CAN'

--Посмотрите результат в отсортированном виде по коду. 

SELECT *
FROM Production.UnitMeasureTest
ORDER BY UnitMeasureCode

--c) Измените UnitMeasureCode для всего набора из Production.UnitMeasureTest на ‘TTT’.

UPDATE Production.UnitMeasureTest
SET UnitMeasureCode = 'TTT'

--d) Удалите все строки из Production.UnitMeasureTest.

DELETE
FROM Production.UnitMeasureTest

--e) Найдите информацию из Sales.SalesOrderDetail по заказам 43659,43664.  

SELECT *
FROM Sales.SalesOrderDetail
WHERE SalesOrderID in ('43659', '43664')

--С помощью оконных функций MAX, MIN, AVG найдем агрегаты по LineTotal для каждого SalesOrderID.

SELECT *
	, MAX(LineTotal) OVER (PARTITION BY SalesOrderID) AS MaxLT
	, MIN(LineTotal) OVER (PARTITION BY SalesOrderID) AS MinLT
	, AVG(LineTotal) OVER (PARTITION BY SalesOrderID) AS AvgLT
FROM Sales.SalesOrderDetail
WHERE SalesOrderID in ('43659', '43664')

--f) Изучите данные в объекте Sales.vSalesPerson. 

SELECT *
FROM Sales.vSalesPerson

--Создайте рейтинг cреди продавцов на основе годовых продаж SalesYTD, используя ранжирующую оконную функцию. 
--Добавьте поле Login, состоящий из 3 первых букв фамилии в верхнем регистре + ‘login’ + TerritoryGroup (Null заменить на пустое значение). 

SELECT BusinessEntityID, FirstName, LastName, TerritoryGroup, SalesYTD
	, CONCAT(LEFT(LastName, 3), 'login', ISNULL(TerritoryGroup, '')) AS Login
	, RANK () OVER (ORDER BY SalesYTD DESC) AS RankBySYTD
FROM Sales.vSalesPerson

--Кто возглавляет рейтинг? 
--Ответ: 276	Linda	Mitchell	North America	4251368,5497	MitloginNorth America	1
--А кто возглавлял рейтинг в прошлом году (SalesLastYear). 
--Ответ: 290	Ranjit	Varkey Chudukatil	Europe	2396539,7601	VarloginEurope	1

SELECT BusinessEntityID, FirstName, LastName, TerritoryGroup, SalesLastYear
	, CONCAT(LEFT(LastName, 3), 'login', ISNULL(TerritoryGroup, '')) AS Login
	, RANK () OVER (ORDER BY SalesLastYear DESC) AS RankBySYTD
FROM Sales.vSalesPerson


--g) Найдите первый будний день месяца (FROM не используем). Нужен стандартный код на все времена.

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