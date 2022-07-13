/* eslint-disable no-unused-vars */
const pool = require("./db_pool.js");

const searchUsers = (req, res) => {
  // TODO: Search by location & instrument & more?
};

const createUser = (req, res) => {
  var return_obj = {};
  const body = req.body;
  const query_params = [
    body.id,
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
  const user_query = `INSERT INTO users(
      id, username, first_name, last_name, email, city, state, zipcode, 
      join_date, description, influences, recordings, profile_photo,
      avail_mon_am, avail_mon_pm, avail_tue_am, avail_tue_pm, 
      avail_wed_am, avail_wed_pm, avail_thu_am, avail_thu_pm,
      avail_fri_am, avail_fri_pm, avail_sat_am, avail_sat_pm,
      avail_sun_am, avail_sun_pm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9,
      $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, 
      $24, $25, $26, $27) RETURNING *;`;

  // TODO: Figure out a way to insert a users instruments
  // const inst_query_params = [body.id, body.instrumentid];
  // const inst_query = `INSERT INTO users_instruments(userid, instrumentid)
  // VALUES($1, $2), (??);`;

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
  // TODO: Update user
  const { id } = req.params;
  const body = req.body;
  const query_params = [id, body.email];
  const query = "UPDATE users SET email = $1 WHERE id = $2;";
  return pool
    .query(query, query_params)
    .then((result) => {
      res.status(200).send("Successfully updated user");
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send("An error occurred.");
    });
};

const deleteUser = (req, res) => {
  // TODO: Delete user
};

module.exports = {
  searchUsers,
  createUser,
  getUserById,
  updateUser,
  deleteUser,
};
