const express = require("express");
const app = express();
const db = require("./db/index.js");

// Add req.body to all requests
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/users", db.getUsers);

app.get("/", (req, res) => {
  res.send("Hello World!!!");
});

module.exports = app;
