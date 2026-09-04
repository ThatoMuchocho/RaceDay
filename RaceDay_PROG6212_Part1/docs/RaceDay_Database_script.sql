/* RaceDay – PROG6212 Part 1 – SQL Server / SSMS */

IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO

DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Enrolments;
DROP TABLE IF EXISTS EventCategories;
DROP TABLE IF EXISTS RouteInformation;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Roles;
GO

CREATE TABLE Roles
(
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(30) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL
);
GO

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    RoleID INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    CategoryType NVARCHAR(20) NOT NULL,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_Categories_CategoryType CHECK (CategoryType IN ('Run', 'Walk', 'Cycle'))
);
GO

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName NVARCHAR(150) NOT NULL,
    Description NVARCHAR(1000) NULL,
    EventDate DATE NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    DistanceKm DECIMAL(8,2) NOT NULL,
    StartTime TIME(0) NULL,
    EndTime TIME(0) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Upcoming',
    CreatedBy INT NOT NULL,
    DateCreated DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_Events_Distance CHECK (DistanceKm > 0),
    CONSTRAINT CK_Events_Status CHECK (Status IN ('Upcoming', 'Open', 'Closed', 'Completed', 'Cancelled')),
    CONSTRAINT FK_Events_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

CREATE TABLE EventCategories
(
    EventCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL DEFAULT 0,
    MaxParticipants INT NOT NULL,
    CONSTRAINT CK_EventCategories_EntryFee CHECK (EntryFee >= 0),
    CONSTRAINT CK_EventCategories_MaxParticipants CHECK (MaxParticipants > 0),
    CONSTRAINT FK_EventCategories_Event FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE,
    CONSTRAINT FK_EventCategories_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_EventCategories_Event_Category UNIQUE (EventID, CategoryID)
);
GO

CREATE TABLE Enrolments
(
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventCategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Confirmed',
    PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT CK_Enrolments_Status CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')),
    CONSTRAINT CK_Enrolments_PaymentStatus CHECK (PaymentStatus IN ('Pending', 'Paid', 'Failed', 'Refunded')),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
    CONSTRAINT FK_Enrolments_EventCategory FOREIGN KEY (EventCategoryID) REFERENCES EventCategories(EventCategoryID),
    CONSTRAINT UQ_Enrolments_Participant_EventCategory UNIQUE (ParticipantID, EventCategoryID)
);
GO

CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    Position INT NULL,
    FinishTime TIME(0) NULL,
    ChipTime TIME(0) NULL,
    Pace DECIMAL(8,2) NULL,
    IsOfficial BIT NOT NULL DEFAULT 1,
    DateCaptured DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_Results_Position CHECK (Position IS NULL OR Position > 0),
    CONSTRAINT CK_Results_Pace CHECK (Pace IS NULL OR Pace > 0),
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID) ON DELETE CASCADE
);
GO

CREATE TABLE RouteInformation
(
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL UNIQUE,
    RouteName NVARCHAR(150) NOT NULL,
    RouteUrl NVARCHAR(500) NULL,
    RouteDescription NVARCHAR(1000) NULL,
    CONSTRAINT FK_RouteInformation_Event FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);
GO

INSERT INTO Roles (RoleName, Description)
VALUES
('Organiser', 'Manages events, categories, enrolments and results.'),
('Participant', 'Browses events, enters events and tracks personal results.');
GO

INSERT INTO Users (FirstName, LastName, Email, PasswordHash, RoleID)
VALUES
('RaceDay', 'Organiser', 'organiser@raceday.co.za', 'DEMO_HASH_REPLACE_IN_PART2', 1),
('Demo', 'Participant', 'participant@raceday.co.za', 'DEMO_HASH_REPLACE_IN_PART2', 2);
GO

INSERT INTO Categories (CategoryName, CategoryType, Description)
VALUES
('10 KM Run', 'Run', '10 kilometre road running category.'),
('21 KM Half Marathon', 'Run', '21 kilometre road running category.'),
('42 KM Marathon', 'Run', 'Full marathon road running category.'),
('Cycling', 'Cycle', 'Road cycling category.'),
('Community Walk', 'Walk', 'Community walking category.');
GO

INSERT INTO Events (EventName, Description, EventDate, Location, DistanceKm, StartTime, EndTime, Status, CreatedBy)
VALUES
('RaceDay Community Run', 'Sample South African community road running event.', '2026-10-10', 'Nelspruit', 10.00, '07:00', '12:00', 'Open', 1);
GO

INSERT INTO EventCategories (EventID, CategoryID, EntryFee, MaxParticipants)
VALUES (1, 1, 150.00, 500);
GO

INSERT INTO Enrolments (ParticipantID, EventCategoryID, Status, PaymentStatus)
VALUES (2, 1, 'Confirmed', 'Paid');
GO

INSERT INTO Results (EnrolmentID, Position, FinishTime, ChipTime, Pace, IsOfficial)
VALUES (1, 25, '00:58:30', '00:58:10', 5.83, 1);
GO

INSERT INTO RouteInformation (EventID, RouteName, RouteUrl, RouteDescription)
VALUES (1, 'RaceDay Community Run Route', NULL, 'Route information will be added for the final event.');
GO

SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Categories;
SELECT * FROM Events;
SELECT * FROM EventCategories;
SELECT * FROM Enrolments;
SELECT * FROM Results;
SELECT * FROM RouteInformation;
GO
