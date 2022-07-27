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

const getMessages = async (database, req) => {
  const convoId_params = [req.params.id];
  try {
    const messages = await database.getMessagesByConvoId(convoId_params);
    return messages;
  } catch (error) {
    return error;
  }
};

const sendMessage = async (database, req) => {
  const body = req.body;
  const convo_params = [
    body.convoId,
    body.senderId,
    body.receiverId
  ];
  const message_params = [
    body.convoId,
    body.senderId,
    body.receiverId,
    body.body,
    body.time_sent
  ];

  try {
    const convoId = await database.checkConvoObjById([body.convoId]);
    if (convoId === "0") {
      await database.createConvoObj(convo_params);
    }
    const sent_id = await database.sendMessageExisting(message_params);
    return sent_id;
  } catch (error) {
    return error;
  }

};

module.exports = {
  getConversations,
  getMessages,
  sendMessage
};
