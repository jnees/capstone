const getConversations = async (database, req) => {
  const id_params = [req.params.id];
  try {
    const conversation = await database.getConvosByUserId(id_params);
    for (let convo_index in conversation) {
      const latest_message = await database.getLatestMessage([conversation[convo_index].convoid]);
      conversation[convo_index]["latest_message"] = latest_message;
    }
    return conversation;
  } catch (error) {
    return error;
  }
};

module.exports = {
  getConversations
};
