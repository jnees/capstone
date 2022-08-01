import "dart:convert";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../screens/chat_conversations_page.dart';
import '../screens/chat_messages_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late String currView = 'Loading';
  late List<dynamic> conversations = [];
  bool dbError = false;
  String selectedConversation = '';
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _getConversations();
  }

  void _getConversations() async {
    setState(() {
      currView = "Loading";
    });

    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = Uri.parse(
        'https://jam-scene-app.herokuapp.com/conversations/$currentUid');
    var response =
        await http.get(url, headers: {'content-type': 'application/json'});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        conversations = data;
        currView = "Conversations";
      });
    } else {
      setState(() {
        dbError = true;
      });
    }
  }

  void messagesTabStateUpdater(Map<String, dynamic> stateChanges) {
    setState(() {
      if (stateChanges.containsKey('_currView')) {
        currView = stateChanges['_currView'];
      }
      if (stateChanges.containsKey('_selectedConversation')) {
        selectedConversation = stateChanges['_selectedConversation'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      switch (currView) {
        case 'Loading':
          return const Center(child: CircularProgressIndicator());
        case 'Conversations':
          return ConversationsPage(
              conversations: conversations,
              messagesTabStateUpdater: messagesTabStateUpdater);
        case 'Messages':
          return ChatMessagesPage(
              selectedConversation: selectedConversation,
              messagesTabStateUpdater: messagesTabStateUpdater);
        default:
          return Center(
            child: Text('Error: Unknown view: $currView'),
          );
      }
    });
  }
}
