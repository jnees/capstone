const createAd = async (database, req) => {
  const body = req.body;
  const ad_query_params = [
    body.posted_by,
    body.city,
    body.state,
    body.zip_code,
    body.post_date,
    body.title,
    body.description,
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
  console.log("hey");
  try {
    const ad_result = await database.addNewAdObj(ad_query_params);
    await database.addNewAdInstRelation(ad_result.id, body.instruments);
  } catch (error) {
    return error;
  }
};

const getAds = async (database) => {
  try {
    const all_ads = await database.getAllAdObjs();
    for (let ad_index in all_ads) {
      const inst_array = await database.getInstByAdId([all_ads[ad_index].id]);
      all_ads[ad_index]["instruments"] = inst_array;
    }
    return all_ads;
  } catch (error) {
    return error;
  }
};

const deleteAd = async (database, req) => {
  const adId = req.params.id;

  try {
    const deleted_id = await database.deleteAdObj(adId);
    return deleted_id;
  } catch (error) {
    return error;
  }
};

const updateAd = async (database, req) => {
  const body = req.body;
  const adId = req.params.id;
  const update_params = [
    adId,
    body.city,
    body.state,
    body.zip_code,
    body.title,
    body.description,
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
    body.avail_sun_pm
  ];

  const instruments = body.instruments;

  try {
    const updated_id = await database.updateAdObj(update_params);
    await database.deleteAdInstRelations(adId);
    await database.addNewAdInstRelation(adId, instruments);
    return updated_id;
  } catch (error) {
    return error;
  }
};

const searchAds = async (database, req) => {
  const body = req.body;
  const query_params1 = [
    body.days.sun,
    body.days.mon,
    body.days.tue,
    body.days.wed,
    body.days.thu,
    body.days.fri,
    body.days.sat,
    body.city,
    body.state,
    body.instrument
  ];
  const query_params2 = [
    body.city,
    body.state,
    body.instrument
  ];
  const query_params3 = [
    body.state,
    body.instrument
  ];
  const query_params4 = [
    body.instrument
  ];

  try {
    const ads_array = database.getAdSearchInfo(query_params1, query_params2, query_params3, query_params4);
    return ads_array;
  } catch (error) {
    return error;
  }
};

module.exports = {
  createAd,
  getAds,
  deleteAd,
  updateAd,
  searchAds
};