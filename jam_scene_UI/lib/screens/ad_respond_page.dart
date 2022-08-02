import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jam_scene/styles.dart';

class AdRespond extends StatefulWidget {
  const AdRespond(
      {Key? key, required this.adsPageStateUpdater, required this.adDetails})
      : super(key: key);
  final Function adsPageStateUpdater;
  final Map<String, dynamic> adDetails;

  @override
  State<AdRespond> createState() => _AdRespondState();
}

class _AdRespondState extends State<AdRespond> {
  final GlobalKey adRespondFormKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();

  String getConvoId() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<String> users = [uid, widget.adDetails['posted_by']];
    users.sort();
    return "${users[0]}+${users[1]}";
  }

  void sendMessage(BuildContext context) async {
    if (messageController.text.isEmpty) {
      return;
    }
    var message = {
      'convoId': getConvoId(),
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.adDetails['posted_by'],
      'body': messageController.text,
      'time_sent': DateTime.now().toString(),
    };

    var url = Uri.parse('https://jam-scene-app.herokuapp.com/messages/');
    var response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: json.encode(message));
    if (response.statusCode == 200) {
      messageController.clear();
      widget.adsPageStateUpdater({'_currView': 'AdDetails'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Styles.salmonJamTint2,
        child: Column(
          children: [
            // back button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    widget.adsPageStateUpdater({
                      '_currView': 'AdDetails',
                    });
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Responding to user ${widget.adDetails['username']}'),
            ),
            // response form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Form(
                key: adRespondFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: messageController,
                      maxLines: null,
                      minLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // send button
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        child: const Text('Send'),
                        onPressed: () {
                          sendMessage(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
