const express = require("express");
const app = express();
const cors = require("cors");
require("dotenv").config();
/* eslint-disable no-unused-vars */
const pool = require("./db/db_pool.js");
const db = require("./db/user_queries");

// Initialize Firebase Admin for server-side auth
const admin = require("firebase-admin");
const serviceAccount = require("./firebase-key.json");
admin.initializeApp({
  credential: admin.credential.cert({
    "project_id": process.env.FIREBASE_PROJECT_ID,
    "private_key": process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, "\n"),
    "client_email": process.env.FIREBASE_CLIENT_EMAIL
  })
});

app.use(cors({ origin: "*" }));

// Add req.body to all requests
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/test-server-auth", (req, res) => {
  const token = req.headers.authorization;
  const new_token = token.split(" ");
  admin.auth().verifyIdToken(new_token[1])
    .then((decodedToken) => {
      const uid = decodedToken.uid;
      console.log(uid);
      res.send("success!");
    })
    .catch((error) => {
      res.send(error);
    });
});

// User Routes:
app.get("/users", db.searchUsers);
app.post("/users", db.createUser);
app.get("/user/:id", db.getUserById);
app.put("/user/:id", db.updateUser);
app.delete("/user/:id", db.deleteUser);

app.get("/", (req, res) => {
  res.send("Hello World!!!");
});

module.exports = app;
