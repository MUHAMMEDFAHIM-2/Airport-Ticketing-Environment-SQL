CREATE DATABASE AirportTicketing;
GO
USE AirportTicketing;
GO

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role VARCHAR(50) CHECK (Role IN ('Ticketing Staff', 'Ticketing Supervisor')) NOT NULL
);

CREATE TABLE Passengers (
    PassengerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DoB DATE NOT NULL,
    MealPreference VARCHAR(20) CHECK (MealPreference IN ('Vegetarian', 'Non-Vegetarian')),
    EmergencyContact VARCHAR(15) NULL
);

-- Create Flights Table
CREATE TABLE Flights (
    FlightID INT IDENTITY(1,1) PRIMARY KEY,
    FlightNumber VARCHAR(10) UNIQUE NOT NULL,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL
);

-- Create Reservations Table
CREATE TABLE Reservations (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    PNR VARCHAR(10) UNIQUE NOT NULL,
    PassengerID INT NOT NULL,
    FlightID INT NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Confirmed', 'Pending', 'Cancelled')) NOT NULL,
    ReservationDate DATE NOT NULL,
    CONSTRAINT FK_Reservations_Passengers FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID) ON DELETE CASCADE,
    CONSTRAINT FK_Reservations_Flights FOREIGN KEY (FlightID) REFERENCES Flights(FlightID) ON DELETE CASCADE,
    CONSTRAINT CHK_ReservationDate CHECK (ReservationDate >= GETDATE()) -- Ensures no past reservations
);

-- Create Tickets Table
CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NOT NULL,
    IssueDate DATE NOT NULL DEFAULT GETDATE(),
    Fare DECIMAL(10,2) NOT NULL,
    SeatNumber VARCHAR(10) NULL,
    Class VARCHAR(20) CHECK (Class IN ('Business', 'FirstClass', 'Economy')) NOT NULL,
    EmployeeID INT NULL,  -- Allow NULL for SET NULL to work
    CONSTRAINT FK_Tickets_Reservations FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID) ON DELETE CASCADE,
    CONSTRAINT FK_Tickets_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);


-- Create Baggage Table
CREATE TABLE Baggage (
    BaggageID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL,
    Weight DECIMAL(5,2) NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('CheckedIn', 'Loaded')) NOT NULL,
    AdditionalFee DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT FK_Baggage_Tickets FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID) ON DELETE CASCADE
);


INSERT INTO Employees (Name, Email, Role) VALUES
('John Doe', 'johndoe@email.com', 'Ticketing Staff'),
('Jane Smith', 'janesmith@email.com', 'Ticketing Supervisor'),
('Alan Kay', 'alan@email.com', 'Ticketing Staff'),
('Emily Clark', 'emily@email.com', 'Ticketing Staff'),
('Mohamed Ali', 'mohamed@email.com', 'Ticketing Supervisor'),
('Sara Khan', 'sarak@email.com', 'Ticketing Staff'),
('David Miller', 'david@email.com', 'Ticketing Staff');

INSERT INTO Passengers (FirstName, LastName, Email, DoB, MealPreference, EmergencyContact) VALUES
('Alice', 'Brown', 'alice@email.com', '1985-05-10', 'Vegetarian', '1234567890'),
('Bob', 'Johnson', 'bob@email.com', '1990-08-22', 'Non-Vegetarian', NULL),
('Charlie', 'Davis', 'charlie@email.com', '1978-11-15', 'Vegetarian', '9876543210'),
('Diana', 'Ross', 'diana@email.com', '1980-02-25', 'Non-Vegetarian', NULL),
('Ethan', 'Hunt', 'ethan@email.com', '1975-12-12', 'Vegetarian', '5566778899'),
('Fiona', 'Green', 'fiona@email.com', '1995-06-30', 'Vegetarian', NULL),
('George', 'Stone', 'george@email.com', '1988-09-09', 'Non-Vegetarian', '1239874560');


INSERT INTO Flights (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime) VALUES
('F1001', 'London', 'New York', '2025-04-10 08:00:00', '2025-04-10 14:00:00'),
('F2002', 'Manchester', 'Dubai', '2025-04-12 10:30:00', '2025-04-12 20:00:00'),
('F3003', 'Birmingham', 'Paris', '2025-04-15 07:45:00', '2025-04-15 10:30:00'),
('F4004', 'London', 'Berlin', '2025-04-18 12:00:00', '2025-04-18 15:00:00'),
('F5005', 'Edinburgh', 'Madrid', '2025-04-20 06:30:00', '2025-04-20 11:00:00'),
('F6006', 'Liverpool', 'Rome', '2025-04-22 09:00:00', '2025-04-22 13:00:00'),
('F7007', 'Bristol', 'Istanbul', '2025-04-25 14:15:00', '2025-04-25 19:30:00');


INSERT INTO Reservations (PNR, PassengerID, FlightID, Status, ReservationDate) VALUES
('PNR001', 13, 11, 'Confirmed', '2025-04-23'),
('PNR002', 14, 12, 'Pending', '2025-04-24'),
('PNR003', 15, 13, 'Cancelled', '2025-04-25'),
('PNR004', 16, 14, 'Confirmed', '2025-04-26'),
('PNR005', 17, 15, 'Confirmed', '2025-04-27'),
('PNR006', 18, 16, 'Pending', '2025-04-28'),
('PNR007', 19, 17, 'Confirmed', '2025-04-29');


INSERT INTO Tickets (ReservationID, Fare, SeatNumber, Class, EmployeeID) VALUES
(14, 500.00, 'A12', 'Economy', 11),
(15, 700.00, NULL, 'Business', 12),
(16, 900.00, 'C5', 'FirstClass', 13),
(17, 450.00, 'B6', 'Economy', 14),
(18, 800.00, 'A2', 'Business', 15),
(19, 600.00, NULL, 'Economy',16),
(20, 1000.00, 'D1', 'FirstClass', 17);

INSERT INTO Baggage (TicketID, Weight, Status, AdditionalFee) VALUES
(6, 15.00, 'CheckedIn', 0),
(7, 25.00, 'Loaded', 250.00),
(8, 30.00, 'CheckedIn', 300.00),
(9, 10.00, 'Loaded', 0),
(10, 35.00, 'CheckedIn', 350.00),
(11, 20.00, 'CheckedIn', 200.00),
(12, 40.00, 'Loaded', 400.00);



SELECT * FROM Employees;
SELECT * FROM Passengers;
SELECT * FROM Flights;
SELECT * FROM Reservations;
SELECT * FROM Tickets;
SELECT * FROM Baggage;

SELECT FirstName, LastName, Email, DoB, Status
FROM Passengers P
JOIN Reservations R ON P.PassengerID = R.PassengerID
WHERE R.Status = 'Pending' 
AND DATEDIFF(YEAR, P.DoB, GETDATE()) > 40;

SELECT E.Name AS EmployeeName, T.TicketID, T.Fare, B.AdditionalFee, (T.Fare + B.AdditionalFee) AS TotalRevenue
FROM Employees E
JOIN Tickets T ON E.EmployeeID = T.EmployeeID
LEFT JOIN Baggage B ON T.TicketID = B.TicketID
WHERE E.EmployeeID = 11;


SELECT F.FlightNumber, COUNT(B.BaggageID) AS TotalCheckedInBaggage
FROM Flights F
JOIN Reservations R ON F.FlightID = R.FlightID
JOIN Tickets T ON R.ReservationID = T.ReservationID
JOIN Baggage B ON T.TicketID = B.TicketID
WHERE B.Status = 'CheckedIn' AND F.FlightID = 11
GROUP BY F.FlightNumber;




CREATE VIEW PassengerMealView AS
SELECT FirstName, LastName, Email, MealPreference
FROM Passengers;


SELECT * FROM PassengerMealView;


CREATE VIEW EmployeeTicketView AS
SELECT E.Name AS EmployeeName, COUNT(T.TicketID) AS TotalTicketsIssued
FROM Employees E
JOIN Tickets T ON E.EmployeeID = T.EmployeeID
GROUP BY E.Name;

SELECT * FROM EmployeeTicketView;


CREATE PROCEDURE SearchPassengerByLastName
    @LastName VARCHAR(50)
AS
BEGIN
    SELECT * FROM Passengers WHERE LastName LIKE '%' + @LastName + '%';
END;

EXEC SearchPassengerByLastName 'Brown';


CREATE PROCEDURE InsertEmployee
    @Name VARCHAR(100),
    @Email VARCHAR(100),
    @Role VARCHAR(50)
AS
BEGIN
    INSERT INTO Employees (Name, Email, Role)
    VALUES (@Name, @Email, @Role);
END;

EXEC InsertEmployee 'Michael Lee', 'mlee@email.com', 'Ticketing Staff';

CREATE PROCEDURE UpdatePassengerEmail
    @PassengerID INT,
    @NewEmail VARCHAR(100)
AS
BEGIN
    UPDATE Passengers
    SET Email = @NewEmail
    WHERE PassengerID = @PassengerID;
END;

EXEC UpdatePassengerEmail 1, 'newemail@email.com';

CREATE TRIGGER UpdateSeatStatus
ON Tickets
AFTER INSERT
AS
BEGIN
    UPDATE Tickets
    SET SeatNumber = 'Reserved'
    WHERE SeatNumber IS NULL
    AND TicketID IN (SELECT TicketID FROM inserted);
END;
