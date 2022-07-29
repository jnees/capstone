import "dart:convert";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../screens/chat_conversations_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late String currView = 'Conversations';
  late List<dynamic> conversations = [];
  bool dbError = false;
  // final currentUid = FirebaseAuth.instance.currentUser!.uid;
  final currentUid = 'e97ce146-41ce-4d51-b3ca-46566775b131';

  @override
  void initState() {
    super.initState();
    _getConversations();
  }

  void _getConversations() async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = Uri.parse(
        'https://jam-scene-app.herokuapp.com/conversations/$currentUid');
    var response =
        await http.get(url, headers: {'content-type': 'application/json'});

    debugPrint(response.body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        conversations = data;
      });
    } else {
      setState(() {
        dbError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      switch (currView) {
        case 'Conversations':
          return ConversationsPage(conversations: conversations);

        default:
          return Center(
            child: Text('Error: Unknown view: $currView'),
          );
      }
    });
  }
}
