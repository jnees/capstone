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

module.exports = {
  createReview,
  getReviewsForUser
};