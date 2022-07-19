import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/screens/new_user_form.dart';
import '../models/profile_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileData profileData;
  List location = [];
  // String uid = 'r4nD0mSt1ng2';
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
    var url = Uri.parse('https://jam-scene-app.herokuapp.com/user/$uid');
    var response = await http.get(url, headers: {'Authorization': token});
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
                padding: const EdgeInsets.all(18.0),
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
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(profileData.profilePhoto),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profileData.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(location.join(", ")),
                              Row(
                                children: const [
                                  Text("🎸"),
                                  Text("🥁"),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child: Text(profileData.description)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Send Message"),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Influences",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(profileData.influences),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Recordings",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(profileData.recordings),
                            ],
                          ),
                        ],
                      ),
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
                          SizedBox(
                            width: 350,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }
}
