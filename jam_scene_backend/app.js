const express = require("express");
const app = express();
const pool = require("./db/db_pools.js");

// Add req.body to all requests
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/*eslint-disable no-unused-vars*/
app.get("/test", (req, res) => {
  const getTest = "SELECT * FROM testTable;";
  return pool.query(getTest).then((result) => {
    res.json(result.rows);
  })
    .catch((err) => {
      console.log(err);
      res.status(500).send("An error occurred trying to query testTable");
    });
});

app.get("/", (req, res) => {
  res.send("Hello World!!!");
});

module.exports = app;
