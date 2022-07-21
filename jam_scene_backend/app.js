function app(database) {
  const express = require("express");
  const exp_app = express();
  const cors = require("cors");
  const users = require("./routes/user.js");

  // Add req.body to all requests
  exp_app.use(express.json());
  exp_app.use(express.urlencoded({ extended: true }));
  exp_app.use(cors({ origin: "*" }));

  // User Routes:
  exp_app.post("/users/search", async (req, res) => {
    await users.userSearch(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });
  exp_app.post("/users", async (req, res) => {
    await users.createUser(database, req)
      .then((result) => {
        res.send(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });
  exp_app.get("/user/:id", async (req, res) => {
    await users.getUserById(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });
  exp_app.put("/user/:id", async (req, res) => {
    await users.updateUser(database, req)
      .then((result) => {
        res.send(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });
  exp_app.delete("/user/:id", async (req, res) => {
    await users.deleteUser(database, req)
      .then((result) => {
        res.send(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });
  exp_app.get("/all_users", async (req, res) => {
    await users.getAllUsers(database)
      .then((result) => {
        res.send(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.get("/", (req, res) => {
    res.send("Hello World!!!");
  });
  return exp_app;
}

module.exports = app;
