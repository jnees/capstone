function app(database) {
  const express = require("express");
  const exp_app = express();
  const cors = require("cors");
  const users = require("./routes/user.js");
  const reviews = require("./routes/reviews.js");
  const ads = require("./routes/ads.js");
  const chat = require("./routes/chat.js");

  // Initialize Firebase Admin for server-side auth
  const admin = require("firebase-admin");

  admin.initializeApp({
    credential: admin.credential.cert({
      "project_id": process.env.FIREBASE_PROJECT_ID,
      "private_key": JSON.parse(process.env.FIREBASE_PRIVATE_KEY),
      "client_email": process.env.FIREBASE_CLIENT_EMAIL
    })
  });

  // Add req.body to all requests
  exp_app.use(express.json());
  exp_app.use(express.urlencoded({ extended: true }));
  exp_app.use(cors({ origin: "*" }));

  // User Routes:
  exp_app.post("/users/search", async (req, res) => {
    // Check header
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await users.userSearch(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  exp_app.post("/users", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await users.createUser(database, req)
        .then((result) => {
          res.send(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
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
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await users.updateUser(database, req)
        .then((result) => {
          res.send(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  exp_app.delete("/user/:id", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await users.deleteUser(database, req)
        .then((result) => {
          res.send(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
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
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await reviews.createReview(database, req)
        .then((result) => {
          res.send(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
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
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await reviews.updateReview(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  exp_app.delete("/review/:id", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await reviews.deleteReview(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  // Ads Routes: 

  exp_app.post("/ads", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await ads.createAd(database, req)
        .then((result) => {
          res.send(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
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
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await ads.updateAd(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  exp_app.delete("/ad/:id", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await ads.deleteAd(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
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

  // Chat Routes:

  exp_app.get("/conversations/:id", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await chat.getConversations(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  exp_app.get("/messages/:id", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await chat.getMessages(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  exp_app.post("/messages", async (req, res) => {
    if (!req.headers.authorization) {
      return res.status(401).send("Unauthorized");
    }
    const token = req.headers.authorization;
    let auth = true;
    await admin.auth().verifyIdToken(token, true)
      .then(() => { })
      .catch((error) => {
        console.log(error);
        auth = false;
        res.status(401).send(error);
        return;
      });

    if (auth) {
      await chat.sendMessage(database, req)
        .then((result) => {
          res.json(result);
        })
        .catch((error) => {
          res.send(error);
        });
    }
  });

  // Generic Home route
  exp_app.get("/", (req, res) => {
    res.send("Hello World!!!");
  });

  return exp_app;
}

module.exports = app;
