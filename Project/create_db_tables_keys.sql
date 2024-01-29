CREATE DATABASE GymProject

CREATE TABLE Filials
(
    FilialId	INT IDENTITY(1,1),
	Name NVARCHAR(50) NOT NULL,
	Address NVARCHAR(100) NOT NULL,
	PRIMARY KEY (FilialId)
);

CREATE TABLE Employees
(
	EmployeeID INT IDENTITY(1,1),
    FirstName NVARCHAR(30),
	LastName NVARCHAR(30) NOT NULL,
	PassportNumber NVARCHAR(14) NOT NULL UNIQUE,
	PhoneNumber NVARCHAR(15) NOT NULL,
	Category INT NOT NULL,
	Position NVARCHAR(50) NOT NULL,
	SalaryPerHour MONEY NOT NULL CHECK (SalaryPerHour > 0),
	PersonalTrainCost MONEY DEFAULT 0,
	OrganizationRate FLOAT DEFAULT 0,
	PRIMARY KEY (EmployeeID)
);

CREATE TABLE VisitEmployees
(
    VisitEmployeeId	INT IDENTITY(1,1),
	EmployeeID INT,
	DateStart DATETIME NOT NULL,
	DateEnd DATETIME,
	FilialID INT,
	PRIMARY KEY (VisitEmployeeId),
	FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
	FOREIGN KEY (FilialID) REFERENCES Filials(FilialID)
);

CREATE TABLE ClientsSubs
(
    ClientSubID	INT IDENTITY(1,1),
	PassportNumber NVARCHAR(14) NOT NULL UNIQUE,
	RegistrationDate DATE NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	PhoneNumber NVARCHAR(15) NOT NULL,
	Email NVARCHAR(50) DEFAULT 'N/A',
	SubscriptionDateStart DATE NOT NULL DEFAULT '31.12.9999',
	SubscriptionDateEnd DATE,
	SubscriptionDatePurchase DATE NOT NULL,
	SubcriptionName NVARCHAR(50) NOT NULL,
	Duration INT NOT NULL,
	Cost MONEY NOT NULL CHECK (Cost > 0),
	StatusSubscription NVARCHAR(20) NOT NULL,
	PRIMARY KEY (ClientSubID)
);


CREATE TABLE VisitClients
(
    VisitClientId	INT IDENTITY(1,1),
	ClientSubID INT,
	VisitDate DATE NOT NULL,
	FilialID INT,
	VisitEmployeeID INT,
	PRIMARY KEY (VisitClientId),
	FOREIGN KEY (ClientSubID) REFERENCES ClientsSubs(ClientSubID),
	FOREIGN KEY (FilialID) REFERENCES Filials(FilialID),
	FOREIGN KEY (VisitEmployeeID) REFERENCES VisitEmployees(VisitEmployeeID)
);


