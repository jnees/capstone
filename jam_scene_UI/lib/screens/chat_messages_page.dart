import "dart:convert";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ChatMessagesPage extends StatefulWidget {
  const ChatMessagesPage(
      {Key? key,
      required this.selectedConversation,
      required this.messagesTabStateUpdater})
      : super(key: key);

  final String selectedConversation;
  final Function messagesTabStateUpdater;

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  bool loadingMessages = true;
  List<dynamic> messages = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController messageController = TextEditingController();
  final chatFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updateMessages();
  }

  void _updateMessages() async {
    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var url = Uri.parse(
        'https://jam-scene-app.herokuapp.com/messages/${widget.selectedConversation}');
    var response = await http.get(url,
        headers: {'content-type': 'application/json', 'authorization': token});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        messages = data;
        loadingMessages = false;
      });
    } else {
      debugPrint(response.statusCode.toString());
      setState(() {
        loadingMessages = false;
      });
    }
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }

    // Build message body
    var message = {
      'convoId': widget.selectedConversation,
      'senderId': uid,
      'receiverId': widget.selectedConversation
          .split('+')
          .firstWhere((element) => element != uid),
      'body': messageController.text,
      'time_sent': DateTime.now().toString(),
    };

    messages.add(message);

    var body = json.encode(message);

    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    Uri url = Uri.parse('https://jam-scene-app.herokuapp.com/messages');

    final response = await http.post(url,
        body: body,
        headers: {'content-type': 'application/json', 'authorization': token});

    if (response.statusCode == 200) {
      _updateMessages();
      messageController.clear();
    } else {
      debugPrint("Error sending message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    widget.messagesTabStateUpdater({
                      '_currView': 'Conversations',
                      '_selectedConversation': "",
                    });
                  },
                ),
              ],
            ),
          ),
          loadingMessages
              ? const Expanded(
                  flex: 9, child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  flex: 9,
                  child: NotificationListener(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollEndNotification) {
                        _updateMessages();
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () async {
                        _updateMessages();
                      },
                      child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return messages[index]["senderid"] == uid
                                ? SenderChatMessage(message: messages[index])
                                : ReceiverChatMessage(message: messages[index]);
                          }),
                    ),
                  ),
                ),
          Form(
              key: chatFormKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            sendMessage();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class SenderChatMessage extends StatelessWidget {
  const SenderChatMessage({Key? key, required this.message}) : super(key: key);
  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: CircleAvatar(
        backgroundImage: NetworkImage(message['sender_photo']),
      ),
      title: FractionallySizedBox(
        alignment: Alignment.centerRight,
        widthFactor: 0.86,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message['body'],
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}

class ReceiverChatMessage extends StatelessWidget {
  const ReceiverChatMessage({Key? key, required this.message})
      : super(key: key);
  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(message['sender_photo']),
        ),
        title: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.86,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message['body'],
              ),
            )),
      ),
    );
  }
}
