function app(database) {
  const express = require("express");
  const exp_app = express();
  const cors = require("cors");
  const users = require("./routes/user.js");
  const reviews = require("./routes/reviews.js");
  const ads = require("./routes/ads.js");

  // Add req.body to all requests
  exp_app.use(express.json());
  exp_app.use(express.urlencoded({ extended: true }));
  exp_app.use(cors({ origin: "*" }));

  // Add logging middleware
  exp_app.use((req, res) => {
    console.log('Request received:')
    console.log(req.url)
    console.log(req.method)
    console.log(req.body)
  })

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

  // Review Routes:
  exp_app.post("/reviews", async (req, res) => {
    await reviews.createReview(database, req)
      .then((result) => {
        res.send(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.get("/reviews/:id", async (req, res) => {
    await reviews.getReviewsForUser(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.put("/review/:id", async (req, res) => {
    await reviews.updateReview(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.delete("/review/:id", async (req, res) => {
    await reviews.deleteReview(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  // Ads Routes: 

  exp_app.post("/ads", async (req, res) => {
    await ads.createAd(database, req)
      .then((result) => {
        res.send(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.get("/ads", async (req, res) => {
    await ads.getAds(database)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.put("/ad/:id", async (req, res) => {
    await ads.updateAd(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.delete("/ad/:id", async (req, res) => {
    await ads.deleteAd(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  exp_app.post("/ads/search", async (req, res) => {
    await ads.searchAds(database, req)
      .then((result) => {
        res.json(result);
      })
      .catch((error) => {
        res.send(error);
      });
  });

  // Generic Home route
  exp_app.get("/", (req, res) => {
    res.send("Hello World!!!");
  });

  return exp_app;
}

module.exports = app;
