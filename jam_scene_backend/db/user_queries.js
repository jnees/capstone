/* eslint-disable no-unused-vars */
const pool = require("./db_pool.js");

const searchUsers = (req, res) => {
  // TODO: Search by location & instrument
};

const createUser = (req, res) => {
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
    body.avail_tues_am,
    body.avail_tues_pm,
    body.avail_wed_am,
    body.avail_wed_pm,
    body.avail_thurs_am,
    body.avail_thurs_pm,
    body.avail_fri_am,
    body.avail_fri_pm,
    body.avail_sat_am,
    body.avail_sat_pm,
    body.avail_sun_am,
    body.avail_sun_pm,
  ];
  const query = `INSERT INTO users(
      id, username, first_name, last_name, email, city, state, zipcode, 
      join_date, description, influences, recordings, profile_photo,
      avail_mon_am, avail_mon_pm, avail_tues_am, avail_tues_pm, 
      avail_wed_am, avail_wed_pm, avail_thurs_am, avail_thurs_pm,
      avail_fri_am, avail_fri_pm, avail_sat_am, avail_sat_pm,
      avail_sun_am, avail_sun_pm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9,
      $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, 
      $24, $25, $26, $27);`;
  return pool
    .query(query, query_params)
    .then((result) => {
      res.status(200).send("Successfully created user");
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

  const inst_query = `SELECT UI.userID, I.name FROM 
  users_instruments UI INNER JOIN instruments I ON UI.instrumentID = I.id 
  WHERE UI.userID = $1`;

  (async () => {
    const select_users = await pool
      .query(user_query, query_params)
      .then((result) => {
        // res.json(result.rows);   // old
        return_obj["user"] = result.rows;
      })
      .catch((err) => {
        console.log(err);
        res.status(500).send("An error occurred.");
      });

    const select_inst = await pool
      .query(inst_query, query_params)
      .then((result) => {
        // res.json(result.rows);
        return_obj["instruments"] = result.rows;

        // extract instr name
        // for (row in result.rows) {
        //   console.log(result.rows[row].name);
        // }

        // console.log(return_obj); // test

        // console.log(JSON.stringify(return_obj)); // test
        res.json(return_obj);
      })
      .catch((err) => {
        console.log(err);
        res.status(500).send("An error occurred.");
      });
  })();

  // select_users = pool
  //   .query(query, query_params)
  //   .then((result) => {
  //     // res.json(result.rows);
  //     return_obj["user"] = result.rows;
  //     // console.log(JSON.stringify(return_obj)); // test
  //     res.json(return_obj);
  //   })
  //   .catch((err) => {
  //     console.log(err);
  //     res.status(500).send("An error occurred.");
  //   });

  // const inst_query = `SELECT UI.userID, I.name FROM
  //   users_instruments UI INNER JOIN instruments I ON UI.instrumentID = I.id
  //   WHERE UI.userID = $1`;

  // console.log(return_obj);

  // res.json_return;
};

const updateUser = (req, res) => {
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
  // TODO:
};

module.exports = {
  searchUsers,
  createUser,
  getUserById,
  updateUser,
  deleteUser,
};
