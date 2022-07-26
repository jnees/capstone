require("dotenv").config();
const { Pool } = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl:
  {
    rejectUnauthorized: false
  }
});

/* ~~~~~~~~~~~ User Queries ~~~~~~~~~~~ */
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
    console.log("Not all ids added");
  }
  return 1;
};

const deleteUserInstRelation = async function (userId, instruments) {
  const delete_inst_query = `DELETE FROM users_instruments
      WHERE userid = $1 AND instrumentid = $2;`;

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

const getUserObjById = async function (userId_param) {
  const user_query = "SELECT * FROM users WHERE id = $1;";

  try {
    const user_obj = await pool.query(user_query, userId_param);
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

const getInstByUserId = async function (userId_param) {

  const inst_query = `SELECT I.id, I.name FROM 
  users_instruments UI INNER JOIN instruments I ON UI.instrumentID = I.id 
  WHERE UI.userID = $1`;

  try {
    const inst_array = await pool.query(inst_query, userId_param);
    return inst_array.rows;
  } catch (error) {
    return error;
  }
};

/* ~~~~~~~~~~~ Review Queries ~~~~~~~~~~~ */

const addNewReviewObj = async function (create_review_params) {
  const review_query = `INSERT INTO reviews(
    for_user, by_user, time_posted, description) VALUES ($1, $2, to_timestamp($3, 'YYYY-MM-DD HH24: MI: SS'), $4) RETURNING id;`;

  try {
    const review_id = await pool.query(review_query, create_review_params);
    return review_id.rows;
  } catch (error) {
    return error;
  }
};

const getReviewsByUserId = async function (user_id) {
  const get_reviews_query = `SELECT * FROM 
  (SELECT reviews.by_user, reviews.for_user, users.username, users.profile_photo, reviews.description, reviews.time_posted 
    FROM users INNER JOIN reviews ON users.id = reviews.by_user) AS S WHERE S.for_user = $1 ORDER BY time_posted DESC;`;

  try {
    const review_array = await pool.query(get_reviews_query, user_id);
    return review_array.rows;
  } catch (error) {
    return error;
  }
};

const updateReviewObj = async function (query_params) {
  const update_review_query = `UPDATE reviews SET description = $2
  WHERE id = $1 RETURNING id;`;

  try {
    const update_review_id = await pool.query(update_review_query, query_params);
    return update_review_id.rows;
  } catch (error) {
    return error;
  }
};

const deleteReviewObj = async function (review_id) {
  const delete_review_query = "DELETE FROM reviews WHERE id = $1;";

  try {
    await pool.query(delete_review_query, [review_id]);
    return review_id;
  } catch (error) {
    return error;
  }
};

/* ~~~~~~~~~~~ Ad Queries ~~~~~~~~~~~ */

const addNewAdObj = async function (create_ad_params) {
  const ad_query = `INSERT INTO ads(
    posted_by, city, state, zipcode, post_date, title, description,
    avail_mon_am, avail_mon_pm, avail_tue_am, avail_tue_pm, 
    avail_wed_am, avail_wed_pm, avail_thu_am, avail_thu_pm,
    avail_fri_am, avail_fri_pm, avail_sat_am, avail_sat_pm,
    avail_sun_am, avail_sun_pm) VALUES ($1, $2, $3, $4, to_timestamp($5, 'YYYY-MM-DD HH24: MI: SS'), $6, $7, $8, 
    $9,
    $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21) RETURNING id;`;

  try {
    const ad_id = await pool.query(ad_query, create_ad_params);
    return ad_id.rows[0];
  } catch (error) {
    return error;
  }
};

const addNewAdInstRelation = async function (adId, instruments) {
  const inst_query = `INSERT INTO ads_instruments(adid, instrumentid)
      VALUES($1, $2) RETURNING instrumentid;`;

  const added_ids = [];
  for (let instr_id of instruments) {
    const inst_query_params = [adId, instr_id];

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
    console.log("Not all ids added");
  }
  return added_ids;
};

const deleteAdInstRelations = async function (adId) {
  const adId_param = [adId];
  const inst_delete = "DELETE FROM ads_instruments WHERE adId = $1";

  try {
    await pool.query(inst_delete, adId_param);
    return adId;
  } catch (error) {
    return error;
  }
};

const getAllAdObjs = async function () {
  const get_all_query = "SELECT * FROM ads ORDER BY post_date DESC;";

  try {
    const all_ads = await pool.query(get_all_query);
    return all_ads.rows;
  } catch (error) {
    return error;
  }
};

const getInstByAdId = async function (adId_param) {

  const inst_query = `SELECT I.id, I.name FROM ads_instruments AI INNER JOIN instruments I 
  ON AI.instrumentID = I.id WHERE AI.adID = $1;`;

  try {
    const inst_array = await pool.query(inst_query, adId_param);
    return inst_array.rows;
  } catch (error) {
    return error;
  }
};

const updateAdObj = async function (update_param) {
  const update_query = `UPDATE ads SET
    city = $2, state = $3, zipcode = $4, title = $5, description = $6,
    avail_mon_am = $7, avail_mon_pm = $8, avail_tue_am = $9, avail_tue_pm = $10, 
    avail_wed_am = $11, avail_wed_pm = $12, avail_thu_am = $13, avail_thu_pm = $14,
    avail_fri_am = $15, avail_fri_pm = $16, avail_sat_am = $17, avail_sat_pm = $18,
    avail_sun_am = $19, avail_sun_pm = $20 WHERE id = $1 RETURNING id;`;

  try {
    const updated_id = await pool.query(update_query, update_param);
    return updated_id;
  } catch (error) {
    return error;
  }
};

const deleteAdObj = async function (adId) {
  const delete_query = "DELETE FROM ads WHERE id = $1;";
  try {
    await pool.query(delete_query, [adId]);
    return adId;
  } catch (error) {
    return error;
  }
};

const getAdSearchInfo = async function (query_params1, query_params2, query_params3, query_params4) {

  const search_query = `SELECT profile_photo, username, A.city, A.state, post_date FROM users U INNER JOIN ads A 
    ON U.id = A.posted_by WHERE A.city = $8 AND A.state = $9 AND (
    (A.avail_mon_am = $2 AND A.avail_mon_am = TRUE) OR (A.avail_mon_pm = $2 AND A.avail_mon_pm = TRUE) OR
    (A.avail_tue_am = $3 AND A.avail_tue_am = TRUE) OR (A.avail_tue_pm = $3 AND A.avail_tue_pm = TRUE) OR (A.avail_wed_am = $4 AND A.avail_wed_am = TRUE) OR
    (A.avail_wed_pm = $4 AND A.avail_wed_pm = TRUE) OR (A.avail_thu_am = $5 AND A.avail_thu_am = TRUE) OR (A.avail_thu_pm = $5 AND A.avail_thu_pm = TRUE) OR
    (A.avail_fri_am = $6 AND A.avail_fri_am = TRUE) OR (A.avail_fri_pm = $6 AND A.avail_fri_pm = TRUE) OR (A.avail_sat_am = $7 AND A.avail_sat_am = TRUE) OR
    (A.avail_sat_pm = $7 AND A.avail_sat_pm = TRUE) OR (A.avail_sun_am = $1 AND A.avail_sun_am = TRUE) OR (A.avail_sun_pm = $1 AND A.avail_sun_pm = TRUE)
  ) AND A.id IN (SELECT AI.adID FROM ads_instruments AI INNER JOIN instruments I 
    ON AI.instrumentid = I.id AND I.id = (SELECT id FROM instruments WHERE name = $10))`;

  const search_query_no_avail = `SELECT profile_photo, username, A.city, A.state, post_date FROM users U INNER JOIN ads A 
  ON U.id = A.posted_by WHERE A.city = $1 AND A.state = $2 AND A.id IN (SELECT AI.adID FROM ads_instruments AI INNER JOIN instruments I 
  ON AI.instrumentid = I.id AND I.id = (SELECT id FROM instruments WHERE name = $3))`;

  const search_query_no_city = `SELECT profile_photo, username, A.city, A.state, post_date FROM users U INNER JOIN ads A 
  ON U.id = A.posted_by WHERE A.state = $1 AND A.id IN (SELECT AI.adID FROM ads_instruments AI INNER JOIN instruments I 
  ON AI.instrumentid = I.id AND I.id = (SELECT id FROM instruments WHERE name = $2))`;

  const search_query_only_inst = `SELECT profile_photo, username, A.city, A.state, post_date FROM users U INNER JOIN ads A 
  ON U.id = A.posted_by WHERE A.id IN (SELECT AI.adID FROM ads_instruments AI INNER JOIN instruments I 
  ON AI.instrumentid = I.id AND I.id = (SELECT id FROM instruments WHERE name = $1))`;

  try {
    let user_results = await pool.query(search_query, query_params1);
    console.log(user_results.rows);
    if (user_results.rows.length === 0) {
      user_results = await pool.query(search_query_no_avail, query_params2);
      console.log("second");
      console.log(user_results.rows);
      if (user_results.rows.length === 0) {
        user_results = await pool.query(search_query_no_city, query_params3);
        console.log("third");
        console.log(user_results.rows);
        if (user_results.rows.length === 0) {
          user_results = await pool.query(search_query_only_inst, query_params4);
          console.log("fourth");
          console.log(user_results.rows);
        }
      }
    }
    return user_results.rows;
  } catch (error) {
    console.log(error);
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
  getSearchInfo,
  addNewReviewObj,
  getReviewsByUserId,
  updateReviewObj,
  deleteReviewObj,
  addNewAdObj,
  addNewAdInstRelation,
  getAllAdObjs,
  getInstByAdId,
  deleteAdObj,
  deleteAdInstRelations,
  updateAdObj,
  getAdSearchInfo
};
