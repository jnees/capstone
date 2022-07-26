const createUser = async (database, req) => {
  const body = req.body;
  const user_query_params = [
    body.uid,
    body.username,
    body.first_name,
    body.last_name,
    body.email,
    body.city,
    body.state,
    body.zip_code,
    body.join_date,
    body.description,
    body.influences,
    body.recordings,
    body.photo,
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

  try {
    const user_result = await database.addNewUserObj(user_query_params);
    await database.addNewUserInstRelation(body.uid, body.instruments);
    return user_result;
  } catch (error) {
    return error;
  }
};

const getUserById = async (database, req) => {
  var return_obj = {};
  try {
    const user_obj = await database.getUserObjById([req.params.id]);
    return_obj["user"] = user_obj;

    const inst_array = await database.getInstByUserId([req.params.id]);
    const review_array = await database.getReviewsByUserId([req.params.id]);

    if (return_obj["user"][0]) {
      return_obj["user"][0]["instruments"] = inst_array;
      return_obj["user"][0]["reviews"] = review_array;
    }
    return return_obj;
  } catch (error) {
    return error;
  };
};

const getAllUsers = async (database) => {
  try {
    const users = await database.getAllUsers();
    return users;
  } catch (error) {
    return error;
  }
};

const updateUser = async (database, req) => {
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
    body.zip_code,
    body.join_date,
    body.description,
    body.influences,
    body.recordings,
    body.photo,
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

  try {
    const updated_id = await database.updateUserObj(query_params);

    // Get instruments currently recorded for this user and delete them
    const old_instrument_objs = await database.getInstByUserId(id);
    const old_instruments = [];
    for (let inst_obj in old_instrument_objs) {
      old_instruments.push(old_instrument_objs[inst_obj]["id"]);
    }
    await database.deleteUserInstRelation(id, old_instruments);

    // Then add the new instruments for this user
    await database.addNewUserInstRelation(id, body.instruments);
    return updated_id;
  } catch (error) {
    return error;
  }
};

const deleteUser = async (database, req) => {

  try {
    const deleted_id = await database.deleteUserObj(req.params);
    return deleted_id;
  } catch (error) {
    return error;
  }
};

const userSearch = async (database, req) => {

  const body = req.body;
  const query_params1 = [
    body.days.sun,
    body.days.mon,
    body.days.tue,
    body.days.wed,
    body.days.thu,
    body.days.fri,
    body.days.sat,
    body.zip,
    body.instrument
  ];
  const query_params2 = [
    body.zip,
    body.instrument
  ];
  const query_params3 = [
    body.instrument
  ];
  try {
    const users = await database.getSearchInfo(query_params1, query_params2, query_params3);
    if (users.length > 0) {
      for (let index in users) {
        const inst_array = await database.getInstByUserId(users[index].id);
        users[index]["instruments"] = inst_array;
      }
    }
    return users;
  } catch (error) {
    return error;
  }

};

module.exports = {
  createUser,
  getUserById,
  updateUser,
  deleteUser,
  getAllUsers,
  userSearch
};
