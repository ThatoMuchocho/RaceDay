RaceDay System Design – Part 1

1. System overview

RaceDay is a full-stack event management system for road running, walking and cycling events. It provides one platform for organisers to manage events and results and for participants to register for events and track their performance.

2. Main users

Organiser

The Organiser manages event information. The Organiser can create, edit and delete events, manage categories, view event enrolments and capture participant results.

Participant

The Participant creates an account, browses available events, enters an event by selecting a category, views personal enrolments and tracks personal results.

3. Database entities

Roles – stores the two supported application roles.

Users – stores organiser and participant accounts.

Events – stores event details.

Categories – stores reusable run, walk and cycle categories.

EventCategories – connects events to categories and stores entry fee/capacity.

Enrolments – stores participant entries.

Results – stores performance results for enrolments.

RouteInformation – stores route information for an event.

4. Relationships

One Role can be assigned to many Users.

One User/Organiser can create many Events.

One Event can have many EventCategories.

One Category can be used by many EventCategories.

One Participant/User can have many Enrolments.

One EventCategory can have many Enrolments.

One Enrolment can have zero or one Result.

One Event can have zero or one RouteInformation record.

5. Normalisation

First Normal Form

Each column stores one value and repeating groups are avoided.

Second Normal Form

Attributes depend on the complete key. Event/category-specific data is stored in EventCategories rather than being repeated in Categories.

Third Normal Form

Non-key attributes depend on the key of their own entity. User details are not duplicated in Events and category descriptions are not duplicated in EventCategories.

6. Validation

Email must be unique and valid.

Passwords must never be stored as plain text.

Role must be Organiser or Participant.

Event date is required.

Event distance must be greater than zero.

Entry fee cannot be negative.

Maximum participants must be greater than zero.

A participant cannot enrol in the same event category twice.

A result must belong to an existing enrolment.

Position must be positive when supplied.

7. Security

The final API will use authentication and role-based authorization. Passwords will be stored as hashes. Protected endpoints will reject unauthenticated or unauthorized requests. SQL parameters or ORM features will be used in Part 2 to reduce SQL injection risk.

8. Part 2 and Part 3 dependency

The database and API plan are the baseline for the C# REST API in Part 2. The MVC application in Part 3 will consume that API. Any later changes must be reflected consistently in the database, API and MVC layers.