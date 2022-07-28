import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/components/instrument_tags.dart';
import 'package:jam_scene/components/visual_components.dart';
import 'package:jam_scene/screens/new_user_form.dart';
import 'package:jam_scene/styles.dart';
import '../models/profile_data.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
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
      return setState(() {
        loading = false;
        newUser = true;
      });
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
                                  style: Styles.titleMedium
                                  ),
                              Text(
                                location.join(", "),
                                style: Styles.headline6_i,
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
                                maxLines: 4,
                                style: Styles.titleSmall,
                                )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Send Message"),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Influences",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  profileData.influences,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
                                const Text("Recordings",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                          Text("Instruments",
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: -10,
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
                              Text("Availability",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 1000),
                    ],
                  ),
                ),
              );
  }
}
