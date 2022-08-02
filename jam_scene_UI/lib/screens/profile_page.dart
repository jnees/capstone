import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/components/instrument_tags.dart';
import 'package:jam_scene/components/visual_components.dart';
import 'package:jam_scene/screens/new_user_form.dart';
import 'package:jam_scene/styles.dart';
import '../models/profile_data.dart';
import '../components/formatted_date.dart';
// import '../components/instrument_tags.dart';

class ProfilePage extends StatefulWidget {
  final String? otherUserId;
  const ProfilePage({Key? key, this.otherUserId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileData profileData;
  List location = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool loading = true;
  bool newUser = false;
  TextEditingController messageController = TextEditingController();
  late bool ownProfile;

  @override
  void initState() {
    super.initState();
    setState(() {
      ownProfile = widget.otherUserId == null;
    });
    _fetchProfileData();
  }

  String? getConvoId() {
    if (widget.otherUserId == null) {
      return null;
    }
    List<String> users = [uid, widget.otherUserId!];
    users.sort();
    return "${users[0]}+${users[1]}";
  }

  void _sendMessage() async {
    if (widget.otherUserId == null) {
      return;
    }
    var message = {
      'convoId': getConvoId(),
      'senderId': uid,
      'receiverId': widget.otherUserId,
      'body': messageController.text,
      'time_sent': DateTime.now().toString(),
    };

    var url = Uri.parse('https://jam-scene-app.herokuapp.com/messages/');
    var response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: json.encode(message));
    if (response.statusCode == 200) {
      messageController.clear();
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
            child: Text("Send a message to ${profileData.username}",
                style: Styles.headline6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Form(
              key: GlobalKey<FormState>(),
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

  void _fetchProfileData() async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = 'https://jam-scene-app.herokuapp.com/user/$uid';

    // If we're looking at our own profile, use the user's id, else use the other user's id.
    if (widget.otherUserId != null && widget.otherUserId != "") {
      url = 'https://jam-scene-app.herokuapp.com/user/${widget.otherUserId}';
    }

    var uri = Uri.parse(url);
    var response = await http.get(uri, headers: {'Authorization': token});
    if (jsonDecode(response.body)['user'].isEmpty) {
      if (!mounted) {
        return;
      }
      return setState(() {
        loading = false;
        newUser = true;
      });
    }

    if (!mounted) {
      return;
    }
    setState(() {
      profileData = ProfileData.fromJson(jsonDecode(response.body)['user'][0]);
      loading = false;
      location = [profileData.city, profileData.state];
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : newUser
            ? const NewUserForm()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(profileData.profilePhoto),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profileData.username,
                                  style: Styles.titleMedium),
                              Text(
                                location.join(", "),
                                style: Styles.headline6Ital,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: ColoredBar(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Text(
                            profileData.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 8,
                            style: Styles.titleSmall,
                          )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      !ownProfile
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showMessageForm();
                                  },
                                  child: const Text("Send Message"),
                                )
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                  "Influences",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                profileData.influences,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                  child: Text("Recordings",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(profileData.recordings),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: Text("Instruments",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: -5,
                        spacing: 10,
                        children: [
                          for (var instrument in profileData.instruments)
                            InstrumentTag(iid: instrument['id']),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.0),
                                child: Text("Availability",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Styles.charcoal,
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Table(
                                    children: [
                                      const TableRow(children: [
                                        Text("Day",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("AM",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("PM",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                      TableRow(children: [
                                        const Text("Sunday"),
                                        profileData.availSunAm
                                            ? const Text("✅")
                                            : const Text("-"),
                                        profileData.availSunPm
                                            ? const Text("✅")
                                            : const Text("-"),
                                      ]),
                                      TableRow(children: [
                                        const Text("Monday"),
                                        profileData.availMonAm
                                            ? const Text("✅")
                                            : const Text("-"),
                                        profileData.availMonPm
                                            ? const Text("✅")
                                            : const Text("-"),
                                      ]),
                                      TableRow(children: [
                                        const Text("Tuesday"),
                                        profileData.availTueAm
                                            ? const Text("✅")
                                            : const Text("-"),
                                        profileData.availTuePm
                                            ? const Text("✅")
                                            : const Text("-"),
                                      ]),
                                      TableRow(children: [
                                        const Text("Wednesday"),
                                        profileData.availWedAm
                                            ? const Text("✅")
                                            : const Text("-"),
                                        profileData.availWedPm
                                            ? const Text("✅")
                                            : const Text("-"),
                                      ]),
                                      TableRow(children: [
                                        const Text("Thursday"),
                                        profileData.availThuAm
                                            ? const Text("✅")
                                            : const Text("-"),
                                        profileData.availThuPm
                                            ? const Text("✅")
                                            : const Text("-"),
                                      ]),
                                      TableRow(children: [
                                        const Text("Friday"),
                                        profileData.availFriAm
                                            ? const Text("✅")
                                            : const Text("-"),
                                        profileData.availFriPm
                                            ? const Text("✅")
                                            : const Text("-"),
                                      ]),
                                      TableRow(children: [
                                        const Text("Saturday"),
                                        profileData.availSatAm
                                            ? const Text("✅")
                                            : const Text("-"),
                                        profileData.availSatPm
                                            ? const Text("✅")
                                            : const Text("-"),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.0),
                        child: Text("Reviews",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      for (var review in profileData.reviews)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(review['profile_photo']),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review['by_user']),
                                    FormattedDateFromString(
                                        date: review['time_posted']),
                                  ],
                                ),
                                subtitle: Text(review["description"]),
                              ),
                            ),
                            const Divider()
                          ],
                        ),
                    ],
                  ),
                ),
              );
  }
}
