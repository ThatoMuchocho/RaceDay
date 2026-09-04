RaceDay RESTful API Endpoint Plan

Base URL

/api

Authentication

Method

Endpoint

Role

Purpose

POST

/api/auth/register

Public

Create a Participant account.

POST

/api/auth/login

Public

Authenticate a user and return an access token.

Events

Method

Endpoint

Role

Purpose

GET

/api/events

Public

View upcoming events.

GET

/api/events/{id}

Public

View one event and its available categories.

POST

/api/events

Organiser

Create an event.

PUT

/api/events/{id}

Organiser

Update an event.

DELETE

/api/events/{id}

Organiser

Delete an event.

Categories

Method

Endpoint

Role

Purpose

GET

/api/categories

Authenticated

View event categories.

POST

/api/categories

Organiser

Create a category.

PUT

/api/categories/{id}

Organiser

Update a category.

DELETE

/api/categories/{id}

Organiser

Delete a category.

Event categories

Method

Endpoint

Role

Purpose

POST

/api/events/{eventId}/categories

Organiser

Add a category offering to an event.

DELETE

/api/events/{eventId}/categories/{categoryId}

Organiser

Remove a category offering.

Enrolments

Method

Endpoint

Role

Purpose

POST

/api/enrolments

Participant

Enter an event category.

GET

/api/enrolments/my

Participant

View the logged-in participant's enrolments.

GET

/api/enrolments/event/{eventId}

Organiser

View all enrolments for an event.

Results

Method

Endpoint

Role

Purpose

POST

/api/results

Organiser

Capture a participant result.

PUT

/api/results/{id}

Organiser

Update a participant result.

GET

/api/results/my

Participant

View the participant's own performance history.

GET

/api/events/{eventId}/results

Organiser

View results for an event.

Route information

Method

Endpoint

Role

Purpose

GET

/api/events/{eventId}/route

Authenticated

View route information.

POST

/api/events/{eventId}/route

Organiser

Add route information.

PUT

/api/events/{eventId}/route

Organiser

Update route information.

DELETE

/api/events/{eventId}/route

Organiser

Delete route information.

Authorisation rules

Public users may browse events and register/login.

Only Organisers may manage events and categories.

Only Organisers may view all event enrolments.

Participants may access only their own enrolments and results.

Only Organisers may capture or modify results.

API authorization is the main security control. The MVC interface must reflect the same permissions.