const express = require("express");
const app = express();
const pool = require("./db/db_pool.js");
const users = require("./routes/user.js");

// Add req.body to all requests
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/*eslint-disable no-unused-vars*/
app.get("/test", (req, res) => {
  const getTest = "SELECT * FROM testTable;";
  return pool
    .query(getTest)
    .then((result) => {
      res.json(result.rows);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send("An error occurred trying to query testTable");
    });
});

// User Routes:
app.get("/users", users.searchUsers);
app.post("/users", users.createUser);
app.get("/user/:id", users.getUserById);
app.put("/user/:id", users.updateUser);
app.delete("/user/:id", users.deleteUser);

app.get("/", (req, res) => {
  res.send("Hello World!!!");
});

module.exports = app;