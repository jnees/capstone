require("dotenv").config();
const { Pool } = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl:
  {
    rejectUnauthorized: false
  }
});

const deleteUserObj = async function (req_params) {
  const { id } = req_params;
  const delete_query = "DELETE FROM users WHERE id = $1;";

  try {
    await pool.query(delete_query, [id]);
    return id;
  } catch (error) {
    return error;
  }
};

const addNewUserObj = async function (query_params) {
  const user_query = `INSERT INTO users(
    id, username, first_name, last_name, email, city, state, zipcode, 
    join_date, description, influences, recordings, profile_photo,
    avail_mon_am, avail_mon_pm, avail_tue_am, avail_tue_pm, 
    avail_wed_am, avail_wed_pm, avail_thu_am, avail_thu_pm,
    avail_fri_am, avail_fri_pm, avail_sat_am, avail_sat_pm,
    avail_sun_am, avail_sun_pm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 
    to_timestamp($9, 'YYYY-MM-DD HH24: MI: SS'),
    $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, 
    $24, $25, $26, $27) RETURNING id;`;

  try {
    const userId = await pool.query(user_query, query_params);
    return userId.rows;
  } catch (error) {
    return error;
  }
};

const addNewUserInstRelation = async function (userId, instruments) {
  const inst_query = `INSERT INTO users_instruments(userid, instrumentid)
      VALUES($1, $2) RETURNING instrumentid;`;

  const added_ids = [];
  for (let instr_id of instruments) {
    const inst_query_params = [userId, instr_id];

    await pool
      .query(inst_query, inst_query_params)
      .then((result) => {
        added_ids.push(result);
      })
      .catch((err) => {
        console.log(err);
        return err;
      });
  }
  // Check length of added_ids against original instruments list to see if any were missed
  if (added_ids.length !== instruments.length) {
    console.log("not all ids added");
  }
  return 1;
};

const deleteUserInstRelation = async function (userId, instruments) {
  const delete_inst_query = `DELETE FROM users_instruments
      WHERE userid = $1 AND instrumentid = $2;`;

  // const deleted_ids = [];
  for (let instr_id of instruments) {
    const inst_query_params = [userId, instr_id];

    await pool
      .query(delete_inst_query, inst_query_params)
      .then((result) => {
        console.log(result);
      })
      .catch((err) => {
        console.log(err);
        return err;
      });
  }
  return 1;
};

const updateUserObj = async function (query_params) {

  const user_query = `UPDATE users SET username = $2, first_name = $3,
    last_name = $4, email = $5, city = $6, state = $7, zipcode = $8,
    join_date = to_timestamp($9, 'YYYY-MM-DD HH24: MI: SS'), 
    description = $10, influences = $11, recordings = $12,
    profile_photo = $13, avail_mon_am = $14, avail_mon_pm = $15,
    avail_tue_am = $16, avail_tue_pm = $17, avail_wed_am = $18,
    avail_wed_pm = $19, avail_thu_am = $20, avail_thu_pm = $21,
    avail_fri_am = $22, avail_fri_pm = $23, avail_sat_am = $24,
    avail_sat_pm = $25, avail_sun_am = $26, avail_sun_pm = $27
    WHERE id = $1 RETURNING id;`;

  try {
    const user_id = await pool.query(user_query, query_params);
    return user_id.rows;
  } catch (error) {
    return error;
  }
};

const getAllUsers = async function () {
  const query = "SELECT * FROM users";
  const res = await pool.query(query);
  return res.rows;
};

const getUserObjById = async function (userId) {
  const user_query = "SELECT * FROM users WHERE id = $1;";

  try {
    const user_obj = await pool.query(user_query, [userId]);
    return user_obj.rows;
  } catch (error) {
    return error;
  }
};

const getSearchInfo = async function (query_params1, query_params2, query_params3) {
  const search_query = `SELECT id, username, city, state, profile_photo FROM users WHERE id IN 
  (SELECT id FROM users WHERE ((avail_mon_am = $2 AND avail_mon_am = TRUE) OR (avail_mon_pm = $2 AND avail_mon_pm = TRUE) OR
    (avail_tue_am = $3 AND avail_tue_am = TRUE) OR (avail_tue_pm = $3 AND avail_tue_pm = TRUE) OR (avail_wed_am = $4 AND avail_wed_am = TRUE) OR
    (avail_wed_pm = $4 AND avail_wed_pm = TRUE) OR (avail_thu_am = $5 AND avail_thu_am = TRUE) OR (avail_thu_pm = $5 AND avail_thu_pm = TRUE) OR
    (avail_fri_am = $6 AND avail_fri_am = TRUE) OR (avail_fri_pm = $6 AND avail_fri_pm = TRUE) OR (avail_sat_am = $7 AND avail_sat_am = TRUE) OR
    (avail_sat_pm = $7 AND avail_sat_pm = TRUE) OR (avail_sun_am = $1 AND avail_sun_am = TRUE) OR (avail_sun_pm = $1 AND avail_sun_pm = TRUE)) 
  AND zipcode = $8) AND id IN (SELECT UI.userID FROM users_instruments UI INNER JOIN instruments I 
  ON UI.instrumentid = I.id AND I.id = (SELECT id FROM instruments WHERE name = $9));`;

  const search_query_no_avail = `SELECT id, username, city, state, profile_photo FROM users WHERE id IN 
  (SELECT id FROM users WHERE zipcode = $1) AND id IN (SELECT UI.userID FROM users_instruments UI INNER JOIN instruments I 
  ON UI.instrumentid = I.id AND I.id = (SELECT id FROM instruments WHERE name = $2));`;

  const search_query_only_inst = `SELECT id, username, city, state, profile_photo FROM users WHERE id IN (SELECT UI.userID FROM users_instruments UI INNER JOIN instruments I 
  ON UI.instrumentid = I.id AND I.id = (SELECT id FROM instruments WHERE name = $1));`;

  try {
    let user_results = await pool.query(search_query, query_params1);
    console.log(user_results.rows);
    if (user_results.rows.length === 0) {
      user_results = await pool.query(search_query_no_avail, query_params2);
      console.log("second");
      console.log(user_results.rows);
      if (user_results.rows.length === 0) {
        user_results = await pool.query(search_query_only_inst, query_params3);
        console.log("third");
        console.log(user_results.rows);
      }
    }
    return user_results.rows;
  } catch (error) {
    console.log(error);
    return error;
  }
};

const getInstByUserId = async function (userId) {

  const inst_query = `SELECT I.id, I.name FROM 
  users_instruments UI INNER JOIN instruments I ON UI.instrumentID = I.id 
  WHERE UI.userID = $1`;

  try {
    const inst_array = await pool.query(inst_query, [userId]);
    return inst_array.rows;
  } catch (error) {
    return error;
  }
};

module.exports = {
  getAllUsers,
  getUserObjById,
  getInstByUserId,
  addNewUserObj,
  deleteUserObj,
  addNewUserInstRelation,
  updateUserObj,
  deleteUserInstRelation,
  getSearchInfo
};
