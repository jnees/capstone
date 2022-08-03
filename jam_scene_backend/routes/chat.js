const getConversations = async (database, req) => {
  const id_params = [req.params.id];
  try {
    const conversation = await database.getConvosByUserId(id_params);
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
    console.log(convoId);
    if (convoId === false) {
      console.log("doesn't exist");
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
