import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jam_scene/components/visual_components.dart';
import 'package:jam_scene/styles.dart';
import 'package:http/http.dart' as http;
import '../models/instrument_lookup.dart';
import '../components/formatted_date.dart';

class AdDetails extends StatefulWidget {
  const AdDetails(
      {Key? key, required this.adsPageStateUpdater, required this.adDetails})
      : super(key: key);

  final Function adsPageStateUpdater;
  final Map<String, dynamic> adDetails;

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  final GlobalKey adRespondFormKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  late bool creatorView;

  @override
  void initState() {
    super.initState();
    _isCreator();
  }

  String? getConvoId() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<String> users = [uid, widget.adDetails['posted_by']];
    users.sort();
    return "${users[0]}+${users[1]}";
  }

  void _sendMessage() async {
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

  void _isCreator() {
    var user = FirebaseAuth.instance.currentUser!.uid;
    if (user == widget.adDetails['posted_by']) {
      setState(() {
        creatorView = true;
      });
    } else {
      setState(() {
        creatorView = false;
      });
    }
  }

  void _showMessageForm() {
    showModalBottomSheet(
      backgroundColor: Styles.salmonJamTint2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) => Column(
        children: [
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Send a message to ${widget.adDetails['username']}",
                style: Styles.headline6),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Form(
              key: adRespondFormKey,
              child: TextFormField(
                minLines: 5,
                maxLines: 6,
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              child: const Text('Send'),
              onPressed: () {
                Navigator.of(context).pop();
                _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //row with back button and title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    widget.adsPageStateUpdater({
                      '_currView': 'Results',
                      '_selectedAdId': -1,
                    });
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: ColoredBar(),
          ),
          GestureDetector(
            onTap: () => {
              widget.adsPageStateUpdater({
                '_currView': 'Profile',
                '_selectedUserId': widget.adDetails['posted_by'],
              })
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.adDetails['profile_photo']),
              radius: MediaQuery.of(context).size.height * .08,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.adDetails['title'],
              style: Styles.titleMedSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Text(
              "${widget.adDetails['description']}",
              style: Styles.titleSmallest,
            ),
          ),
          const SizedBox(height: 10),
          Text("Posted by: ${widget.adDetails['username']}"),
          Text(
              "Looking for ${instrumentLookup[widget.adDetails['instruments'][0]['id']]}"),
          Text(
            widget.adDetails['city'] + ', ' + widget.adDetails['state'],
            style: Styles.headline7Ital,
          ),
          FormattedDateFromString(date: widget.adDetails['post_date']),
          const SizedBox(height: 10),
          creatorView
              ? ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  label: const Text('Delete Ad'),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    _showMessageForm();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Styles.charcoal,
                  ),
                  icon: const Icon(Icons.mail),
                  label: const Text("Respond")),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: ColoredBar(),
          ),
        ],
      ),
    );
  }
}
