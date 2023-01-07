# JamScene - CS467 Capstone Project

![JamScene Logo Image](jam_scene_UI/assets/images/JamSceneLogoRaised.png)


## Description
---

For our Oregon State University CS467 Capstone Project, our team chose to create JamScene, a cross-platform social media app (iOS, Android, & Web) designed to facilitate community and communication between musicians. Our project allowed our team to practice and display skills in user experience, aesthetic design, database design, API development, and team problem solving to produce an attractive and functional app designed to meet a specific user need.


## Installation
---

Our app uses Google to manage users, so we encourage you to create an account for testing using either the registration form or the ‘sign-in with google’ button on the login page. 

**Running on iOS (preferred):**

**01/06/2023 - App is currently offline/archived due to Heroku policy change which removed Postgres from the free hosting tier.**
 
[Join our beta test on TestFlight](https://testflight.apple.com/join/KM8Otdy5): 
 
**Running on Web:**

[JamScene Website](https://jamscene-410d6.firebaseapp.com/)

## Usage
---

[Watch Demo Video](https://youtu.be/xKTJWvaWKm8)

![App Overview Image](jam_scene_UI/assets/images/JamSceneAppOverview.png)


## Authors
---

**Solange Coughlin** - @SolangeCoughlin

- Setup Github Actions for server linting and automated testing
- Setup server project by assembling needed dependencies and creating initial ‘Hello World’ route
- Refactored User routes developed by Wes to allow automated API testing without requiring database access
- Wrote automated tests for all routes during API development
- Wrote SQL queries for requests relating to our user search route, as well as all routes relating to user reviews, ads, and messaging within the app
- Wrote all routes for requests relating to user reviews, ads, and messaging.


**Wes MacDonald** - @wrmacdonald

- Initial PostgreSQL database creation & connection with the Back End server.
- Setup Back End server hosting on Heroku.
- Setup initial CRUD for user routes that interacted with Heroku hosted database.
- Designed & Implemented Front End styling, including layout, color palette & font design. 


**Joshua Nees** - @jnees

- Designed UI mock-ups.
- Built user interface for iOS, Android, and Web
- Integrated Firebase for user management, authentication, storage, and hosting.
- Launched web hosting, iOS TestFlight Beta Test, and Google Play Android Beta Test
