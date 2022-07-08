const express = require("express");
const app = express();
const db = require("./db/index.js");
require("dotenv").config();
const pool = require("./db/db_pools.js");

// Add req.body to all requests
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/users", db.getUsers);

/*eslint-disable no-unused-vars*/
app.get("/make-table", (req, res) => {
  const makeUsers = "CREATE TABLE IF NOT EXISTS users \
    id SERIAL PRIMARY KEY,\
    email text NOT NULL,\
    first_name text,\
    last_name text,\
    location text,\
    influences text,\
    recordings text,\
    description text,\
    join_date timestamp,\
    instruments integer REFERENCES instruments,\
    availability_mon_am boolean, \
    availability_mon_pm boolean, \
    availability_tue_am boolean, \
    availability_tue_pm boolean, \
    availability_wed_am boolean, \
    availability_wed_pm boolean, \
    availability_thu_am boolean, \
    availability_thu_pm boolean, \
    availability_fri_am boolean, \
    availability_fri_pm boolean, \
    availability_sat_am boolean, \
    availability_sat_pm boolean, \
    availability_sun_am boolean, \
    availability_sun_pm boolean, \
    profile_photo text";

  pool.query(makeUsers).then(console.log("did query")).catch((err) => console.log(err));
});

app.get("/", (req, res) => {
  res.send("Hello World!!!");
});

module.exports = app;
