const createReview = async (database, req) => {
  const body = req.body;
  const create_review_params = [
    body.for_user,
    body.by_user,
    body.time_posted,
    body.description
  ];

  try {
    const review_id = await database.addNewReviewObj(create_review_params);
    return review_id;
  } catch (error) {
    return error;
  }
};

const getReviewsForUser = async (database, req) => {
  const user_id = req.params.id;

  try {
    const review_array = await database.getReviewsByUserId([user_id]);
    return review_array;
  } catch (error) {
    return error;
  }
};

const updateReview = async (database, req) => {
  const body = req.body;
  const query_params = [
    req.params.id,
    body.description
  ];

  try {
    const updated_review_id = await database.updateReviewObj(query_params);
    return updated_review_id;
  } catch (error) {
    return error;
  }
};

const deleteReview = async (database, req) => {
  const review_id = req.params.id;
  try {
    const deleted_id = await database.deleteReviewObj(review_id);
    return deleted_id;
  } catch (error) {
    return error;
  }
};

module.exports = {
  createReview,
  getReviewsForUser,
  updateReview,
  deleteReview
};