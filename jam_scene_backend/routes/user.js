/* eslint-disable no-unused-vars */
const pool = require("../db/db_pool.js");

const searchUsers = (req, res) => {
  // TODO: Search by location & instrument & more?
};

const createUser = (req, res) => {
  var return_obj = {};
  const body = req.body;
  console.log(body);
  // Insert a user query
  const user_query_params = [
    body.user[0].id,
    body.user[0].username,
    body.user[0].first_name,
    body.user[0].last_name,
    body.user[0].email,
    body.user[0].city,
    body.user[0].state,
    body.user[0].zipcode,
    body.user[0].join_date,
    body.user[0].description,
    body.user[0].influences,
    body.user[0].recordings,
    body.user[0].profile_photo,
    body.user[0].avail_mon_am,
    body.user[0].avail_mon_pm,
    body.user[0].avail_tue_am,
    body.user[0].avail_tue_pm,
    body.user[0].avail_wed_am,
    body.user[0].avail_wed_pm,
    body.user[0].avail_thu_am,
    body.user[0].avail_thu_pm,
    body.user[0].avail_fri_am,
    body.user[0].avail_fri_pm,
    body.user[0].avail_sat_am,
    body.user[0].avail_sat_pm,
    body.user[0].avail_sun_am,
    body.user[0].avail_sun_pm,
  ];
  const user_query = `INSERT INTO users(
      id, username, first_name, last_name, email, city, state, zipcode, 
      join_date, description, influences, recordings, profile_photo,
      avail_mon_am, avail_mon_pm, avail_tue_am, avail_tue_pm, 
      avail_wed_am, avail_wed_pm, avail_thu_am, avail_thu_pm,
      avail_fri_am, avail_fri_pm, avail_sat_am, avail_sat_pm,
      avail_sun_am, avail_sun_pm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9,
      $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, 
      $24, $25, $26, $27) RETURNING *;`;

  // Insert a user's instruments query
  const instruments = body.user[0].instruments;
  const inst_query = `INSERT INTO users_instruments(userid, instrumentid)
      VALUES($1, $2);`;

  (async () => {
    // TODO: check id (later username as well?) does not exist already
    // if username exists already: return error code
    // else: insert user

    // Insert a user
    const insert_users = await pool
      .query(user_query, user_query_params)
      .then((result) => {
        // for testing & returning user object:
        // return_obj["user"] = result.rows;
      })
      .catch((err) => {
        console.log(err);
        res.status(500).send("An error occurred.");
      });

    // Insert a user's instruments
    for (let instr_id of instruments) {
      const inst_query_params = [body.user[0].id, instr_id];

      const insert_users_instruments = await pool
        .query(inst_query, inst_query_params)
        .then((result) => {
          // for testing & returning user object:
          // if (return_obj["user"][0]) {
          //   return_obj["user"][0]["instruments"] = result.rows;
          // }
          // res.json(return_obj);
        })
        .catch((err) => {
          console.log(err);
          res.status(500).send("An error occurred.");
        });
    }

    // Return a success code
    res.status(200).send("...");
  })();
};

const getUserById = (req, res) => {
  var return_obj = {};

  const { id } = req.params;
  const query_params = [id];

  const user_query = "SELECT * FROM users WHERE id = $1;";

  const inst_query = `SELECT I.id, I.name FROM 
  users_instruments UI INNER JOIN instruments I ON UI.instrumentID = I.id 
  WHERE UI.userID = $1`;

  (async () => {
    const select_users = await pool
      .query(user_query, query_params)
      .then((result) => {
        return_obj["user"] = result.rows;
      })
      .catch((err) => {
        console.log(err);
        res.status(500).send("An error occurred.");
      });

    const select_inst = await pool
      .query(inst_query, query_params)
      .then((result) => {
        if (return_obj["user"][0]) {
          return_obj["user"][0]["instruments"] = result.rows;
        }

        res.json(return_obj);
      })
      .catch((err) => {
        console.log(err);
        res.status(500).send("An error occurred.");
      });
  })();
};

const updateUser = (req, res) => {
  var return_obj = {};
  const { id } = req.params;
  const body = req.body;
  const query_params = [
    id,
    body.username,
    body.first_name,
    body.last_name,
    body.email,
    body.city,
    body.state,
    body.zipcode,
    body.join_date,
    body.description,
    body.influences,
    body.recordings,
    body.profile_photo,
    body.avail_mon_am,
    body.avail_mon_pm,
    body.avail_tue_am,
    body.avail_tue_pm,
    body.avail_wed_am,
    body.avail_wed_pm,
    body.avail_thu_am,
    body.avail_thu_pm,
    body.avail_fri_am,
    body.avail_fri_pm,
    body.avail_sat_am,
    body.avail_sat_pm,
    body.avail_sun_am,
    body.avail_sun_pm,
  ];
  const user_query = `UPDATE users SET username = $2, first_name = $3,
    last_name = $4, email = $5, city = $6, state = $7, zipcode = $8,
    join_date = $9, description = $10, influences = $11, recordings = $12,
    profile_photo = $13, avail_mon_am = $14, avail_mon_pm = $15,
    avail_tue_am = $16, avail_tue_pm = $17, avail_wed_am = $18,
    avail_wed_pm = $19, avail_thu_am = $20, avail_thu_pm = $21,
    avail_fri_am = $22, avail_fri_pm = $23, avail_sat_am = $24,
    avail_sat_pm = $25, avail_sun_am = $26, avail_sun_pm = $27
    WHERE id = $1 RETURNING *;`;
  return pool
    .query(user_query, query_params)
    .then((result) => {
      return_obj["user"] = result.rows;
      res.json(return_obj);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send("An error occurred.");
    });
};

const deleteUser = (req, res) => {
  const { id } = req.params;
  const query_params = [id];
  const user_query = "DELETE FROM users WHERE id = $1;";
  return pool
    .query(user_query, query_params)
    .then((result) => {
      res.status(200).send("Successfully deleted user");
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send("An error occurred.");
    });
};

module.exports = {
  searchUsers,
  createUser,
  getUserById,
  updateUser,
  deleteUser,
};
