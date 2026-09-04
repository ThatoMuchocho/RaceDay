================================================================
README.md
================================================================
# RaceDay – PROG6212 Part 1

RaceDay is a web-based event management system for South African road running, walking and cycling events.

## Part 1 scope

Part 1 focuses on planning the system before application code is written.

Included:
- Entity Relationship Diagram (ERD)
- RESTful API endpoint plan
- SQL Server database script
- Role-based access design
- Validation and security planning
- GitHub Actions documentation validation

## Roles

### Organiser
- Create, view, update and delete events
- Manage event categories
- View event enrolments
- Capture and update participant results

### Participant
- Create an account
- Browse upcoming events
- Enter an event by selecting a category
- View own enrolments
- View own performance results

## Repository structure

```text
RaceDay_PROG6212_Part1/
├── .github/
│   └── workflows/
│       └── docs-validation.yml
├── docs/
│   ├── api_endpoint_plan.md
│   ├── erd_diagram.png
│   ├── erd_diagram.puml
│   ├── RaceDay_Database_script.sql
│   └── system_design.md
├── .gitignore
└── README.md
```

## Database setup

1. Open SQL Server Management Studio (SSMS).
2. Open `docs/RaceDay_Database_script.sql`.
3. Execute the script.
4. The script creates `RaceDayDB`, its tables, constraints and sample data.
5. Run the test SELECT statements at the bottom of the script.

## Part 1 validation

The GitHub Actions workflow checks that the required planning files exist in `docs/`.

## Important

The planning files should be committed before Part 2 API development starts.
The final project must maintain meaningful GitHub commits that reflect real work.

================================================================
.gitignore
================================================================
.vs/
*.user
*.suo
*.userosscache
*.sln.docstates
bin/
obj/
Debug/
Release/
TestResults/
*.trx
.idea/
_ReSharper*/
*.DotSettings.user
.DS_Store
Thumbs.db
.env
appsettings.Development.json
*.log

================================================================
docs/api_endpoint_plan.md
================================================================
# RaceDay RESTful API Endpoint Plan

## Base URL
`/api`

## Authentication

| Method | Endpoint | Role | Purpose |
|---|---|---|---|
| POST | `/api/auth/register` | Public | Create a Participant account. |
| POST | `/api/auth/login` | Public | Authenticate a user and return an access token. |

## Events

| Method | Endpoint | Role | Purpose |
|---|---|---|---|
| GET | `/api/events` | Public | View upcoming events. |
| GET | `/api/events/{id}` | Public | View one event and its available categories. |
| POST | `/api/events` | Organiser | Create an event. |
| PUT | `/api/events/{id}` | Organiser | Update an event. |
| DELETE | `/api/events/{id}` | Organiser | Delete an event. |

## Categories

| Method | Endpoint | Role | Purpose |
|---|---|---|---|
| GET | `/api/categories` | Authenticated | View event categories. |
| POST | `/api/categories` | Organiser | Create a category. |
| PUT | `/api/categories/{id}` | Organiser | Update a category. |
| DELETE | `/api/categories/{id}` | Organiser | Delete a category. |

## Event categories

| Method | Endpoint | Role | Purpose |
|---|---|---|---|
| POST | `/api/events/{eventId}/categories` | Organiser | Add a category offering to an event. |
| DELETE | `/api/events/{eventId}/categories/{categoryId}` | Organiser | Remove a category offering. |

## Enrolments

| Method | Endpoint | Role | Purpose |
|---|---|---|---|
| POST | `/api/enrolments` | Participant | Enter an event category. |
| GET | `/api/enrolments/my` | Participant | View the logged-in participant's enrolments. |
| GET | `/api/enrolments/event/{eventId}` | Organiser | View all enrolments for an event. |

## Results

| Method | Endpoint | Role | Purpose |
|---|---|---|---|
| POST | `/api/results` | Organiser | Capture a participant result. |
| PUT | `/api/results/{id}` | Organiser | Update a participant result. |
| GET | `/api/results/my` | Participant | View the participant's own performance history. |
| GET | `/api/events/{eventId}/results` | Organiser | View results for an event. |

## Route information

| Method | Endpoint | Role | Purpose |
|---|---|---|---|
| GET | `/api/events/{eventId}/route` | Authenticated | View route information. |
| POST | `/api/events/{eventId}/route` | Organiser | Add route information. |
| PUT | `/api/events/{eventId}/route` | Organiser | Update route information. |
| DELETE | `/api/events/{eventId}/route` | Organiser | Delete route information. |

## Authorisation rules

- Public users may browse events and register/login.
- Only Organisers may manage events and categories.
- Only Organisers may view all event enrolments.
- Participants may access only their own enrolments and results.
- Only Organisers may capture or modify results.
- API authorization is the main security control. The MVC interface must reflect the same permissions.

================================================================
docs/system_design.md
================================================================
# RaceDay System Design – Part 1

## 1. System overview

RaceDay is a full-stack event management system for road running, walking and cycling events. It provides one platform for organisers to manage events and results and for participants to register for events and track their performance.

## 2. Main users

### Organiser
The Organiser manages event information. The Organiser can create, edit and delete events, manage categories, view event enrolments and capture participant results.

### Participant
The Participant creates an account, browses available events, enters an event by selecting a category, views personal enrolments and tracks personal results.

## 3. Database entities

- Roles – stores the two supported application roles.
- Users – stores organiser and participant accounts.
- Events – stores event details.
- Categories – stores reusable run, walk and cycle categories.
- EventCategories – connects events to categories and stores entry fee/capacity.
- Enrolments – stores participant entries.
- Results – stores performance results for enrolments.
- RouteInformation – stores route information for an event.

## 4. Relationships

- One Role can be assigned to many Users.
- One User/Organiser can create many Events.
- One Event can have many EventCategories.
- One Category can be used by many EventCategories.
- One Participant/User can have many Enrolments.
- One EventCategory can have many Enrolments.
- One Enrolment can have zero or one Result.
- One Event can have zero or one RouteInformation record.

## 5. Normalisation

### First Normal Form
Each column stores one value and repeating groups are avoided.

### Second Normal Form
Attributes depend on the complete key. Event/category-specific data is stored in EventCategories rather than being repeated in Categories.

### Third Normal Form
Non-key attributes depend on the key of their own entity. User details are not duplicated in Events and category descriptions are not duplicated in EventCategories.

## 6. Validation

- Email must be unique and valid.
- Passwords must never be stored as plain text.
- Role must be Organiser or Participant.
- Event date is required.
- Event distance must be greater than zero.
- Entry fee cannot be negative.
- Maximum participants must be greater than zero.
- A participant cannot enrol in the same event category twice.
- A result must belong to an existing enrolment.
- Position must be positive when supplied.

## 7. Security

The final API will use authentication and role-based authorization. Passwords will be stored as hashes. Protected endpoints will reject unauthenticated or unauthorized requests. SQL parameters or ORM features will be used in Part 2 to reduce SQL injection risk.

## 8. Part 2 and Part 3 dependency

The database and API plan are the baseline for the C# REST API in Part 2. The MVC application in Part 3 will consume that API. Any later changes must be reflected consistently in the database, API and MVC layers.

================================================================
docs/RaceDay_Database_script.sql
================================================================
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

================================================================
.github/workflows/docs-validation.yml
================================================================
name: Part 1 Documentation Validation

on:
  push:
    branches:
      - main
      - master
  pull_request:

jobs:
  validate-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Check required Part 1 files
        shell: bash
        run: |
          set -e
          test -f README.md
          test -f docs/api_endpoint_plan.md
          test -f docs/erd_diagram.png
          test -f docs/RaceDay_Database_script.sql
          test -f docs/system_design.md
          echo "All required Part 1 documentation files are present."

================================================================
docs/erd_diagram.puml
================================================================
@startuml
left to right direction
title RaceDay - Entity Relationship Diagram

entity Roles {
  * RoleID : INT <<PK>>
  --
  RoleName : NVARCHAR
  Description : NVARCHAR
}
entity Users {
  * UserID : INT <<PK>>
  --
  FirstName : NVARCHAR
  LastName : NVARCHAR
  Email : NVARCHAR
  PasswordHash : NVARCHAR
  RoleID : INT <<FK>>
  CreatedAt : DATETIME2
  IsActive : BIT
}
entity Events {
  * EventID : INT <<PK>>
  --
  EventName : NVARCHAR
  Description : NVARCHAR
  EventDate : DATE
  Location : NVARCHAR
  DistanceKm : DECIMAL
  StartTime : TIME
  EndTime : TIME
  Status : NVARCHAR
  CreatedBy : INT <<FK>>
  DateCreated : DATETIME2
}
entity Categories {
  * CategoryID : INT <<PK>>
  --
  CategoryName : NVARCHAR
  CategoryType : NVARCHAR
  Description : NVARCHAR
  IsActive : BIT
}
entity EventCategories {
  * EventCategoryID : INT <<PK>>
  --
  EventID : INT <<FK>>
  CategoryID : INT <<FK>>
  EntryFee : DECIMAL
  MaxParticipants : INT
}
entity Enrolments {
  * EnrolmentID : INT <<PK>>
  --
  ParticipantID : INT <<FK>>
  EventCategoryID : INT <<FK>>
  EnrolmentDate : DATETIME2
  Status : NVARCHAR
  PaymentStatus : NVARCHAR
}
entity Results {
  * ResultID : INT <<PK>>
  --
  EnrolmentID : INT <<FK>>
  Position : INT
  FinishTime : TIME
  ChipTime : TIME
  Pace : DECIMAL
  IsOfficial : BIT
  DateCaptured : DATETIME2
}
entity RouteInformation {
  * RouteID : INT <<PK>>
  --
  EventID : INT <<FK>>
  RouteName : NVARCHAR
  RouteUrl : NVARCHAR
  RouteDescription : NVARCHAR
}
Roles ||--o{ Users : assigns
Users ||--o{ Events : creates
Events ||--o{ EventCategories : offers
Categories ||--o{ EventCategories : used_by
Users ||--o{ Enrolments : makes
EventCategories ||--o{ Enrolments : receives
Enrolments ||--o| Results : has
Events ||--o| RouteInformation : has
@enduml

