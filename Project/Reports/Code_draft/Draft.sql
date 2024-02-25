CREATE VIEW v_employee_salary
AS

SELECT	CAST(VE.DateStart AS Date) DateWork, 
		E.FirstName, 
		E.LastName,
		E.PassportNumber,
		E.Position, 
		E.Category,
		E.PersonalTrainCost,
		PersonalTrainCost * OrganizationRate AS PersonalTrainOrganiztionPart, 
		PersonalTrainCost - PersonalTrainCost * OrganizationRate AS PersonalTrainTrainerPart,
		DATEDIFF(HOUR, DateStart, DateEnd) * SalaryPerHour AS PayDaySalary,
		CASE 
			WHEN E.Position <> 'Trainer' THEN DATEDIFF(HOUR, DateStart, DateEnd) * SalaryPerHour
			ELSE DATEDIFF(HOUR, DateStart, DateEnd) * SalaryPerHour + (PersonalTrainCost - PersonalTrainCost * OrganizationRate) 
			END AS PayDayFull

FROM
(
SELECT *
FROM VisitEmployees
) VE LEFT JOIN VisitClients VC ON VE.VisitEmployeeID = VC.VisitEmployeeID
LEFT JOIN Employees E ON VE.EmployeeID = E.EmployeeID
LEFT JOIN ClientsSubs CS ON VC.ClientsSubID = CS.ClientsSubID