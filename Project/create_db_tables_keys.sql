CREATE DATABASE GymProject

CREATE TABLE Filials
(
    FilialsId	INT IDENTITY(1,1),
	Name NVARCHAR(50) NOT NULL,
	Address NVARCHAR(100) NOT NULL,
	PRIMARY KEY (FilialsId)
);

CREATE TABLE VisitClients
(
    VisitClientId	INT IDENTITY(1,1),
	ClientSubID INT,
	VisitDate DATE NOT NULL,
	FilialsID INT,
	VisitEmployeeID INT,
	PRIMARY KEY (VisitClientId),
	FOREIGN KEY (ClientSubID) REFERENCES ClientsSubs(ClientSubID),
	FOREIGN KEY (FilialsID) REFERENCES Filials(FilialsID),
	FOREIGN KEY (VisitEmployeeID) REFERENCES VisitEmployees(VisitEmployeeID)
);

CREATE TABLE VisitEmployees
(
    VisitEmployeeId	INT IDENTITY(1,1),
	EmployeeID INT,
	DateStart DATETIME NOT NULL,
	DateEnd DATETIME,
	FilialsID INT,
	PRIMARY KEY (VisitEmployeeId),
	FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
	FOREIGN KEY (FilialsID) REFERENCES Filials(FilialsID)
);

CREATE TABLE ClientsSubs
(
    ClientsSubsID	INT IDENTITY(1,1),
	PassportNumber NVARCHAR(14) NOT NULL UNIQUE,
	RegistrationDate DATE NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	PhoneNumber NVARCHAR(15) NOT NULL,
	Email NVARCHAR(50) DEFAULT 'N/A',
	SubscriptionDateStart DATE NOT NULL,
	SubscriptionDateEnd DATE,
	SubscriptionDatePurchase DATE NOT NULL,
	SubcriptionName NVARCHAR(50) NOT NULL,
	Duration INT NOT NULL,
	Cost MONEY > 0 NOT NULL,
	StatusSubscription NVARCHAR(20) NOT NULL,
	PRIMARY KEY (ClientsSubsID)
);

CREATE TABLE Employees
(
	EmplyeeID INT IDENTITY(1,1),
    FirstName NVARCHAR(30),
	LastName NVARCHAR(30) NOT NULL,
	PassportNumber NVARCHAR(14) NOT NULL UNIQUE,
	PhoneNumber NVARCHAR(15) NOT NULL,
	Category INT NOT NULL,
	Position NVARCHAR(50) NOT NULL,
	SalaryPerHour MONEY > 0 NOT NULL,
	PersonalTrainCost MONEY DEFAULT 0,
	OrganizationRate FLOAT DEFAULT 0,
	PRIMARY KEY (EmplyeeID)
);
