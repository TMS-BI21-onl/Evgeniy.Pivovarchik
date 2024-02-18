CREATE VIEW v_top_50_trainers
AS

WITH 
T_VE_VC AS
(
SELECT VC.VisitDate AS Visit_date_t1, VE.EmployeeID AS EmployeeID_t1
FROM VisitClients VC JOIN VisitEmployees VE
ON VC.VisitEmployeeID = VE.VisitEmployeeID
),

T_VE_VC_group_date AS
(
SELECT Visit_date_t1, EmployeeID_t1, COUNT(Visit_date_t1) AS visits_count
FROM T_VE_VC
GROUP BY Visit_date_t1, EmployeeID_t1
),

T_points AS
(
SELECT *, 
	CASE
		WHEN visits_count < 5 THEN 1
		WHEN visits_count >= 5 AND visits_count < 10 THEN 2
		WHEN visits_count >= 10 THEN 3
		END AS points
FROM T_VE_VC_group_date
),

T_rating AS
(
SELECT EmployeeID_t1, SUM(points) AS Sum_points
FROM T_points
GROUP BY EmployeeID_t1
)

SELECT TOP 50 WITH TIES *
FROM T_rating
ORDER BY Sum_points