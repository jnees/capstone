import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/profile_data.dart';
import '../components/side_navigation.dart';
import '../components/bottom_navigation.dart';

class ProfilePage extends StatefulWidget {
  final String? id;
  const ProfilePage({Key? key, this.id}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileData profileData;
  String uid = 'r4nD0mSt1ng2';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  void _fetchProfileData() async {
    var url = Uri.parse('https://jam-scene-app.herokuapp.com/user/$uid');
    var response = await http.get(url);
    setState(() {
      profileData = ProfileData.fromJson(jsonDecode(response.body)['user'][0]);
      loading = false;
    });
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return WebProfilePage(profileData: profileData);
              } else {
                return MobileProfilePage(profileData: profileData);
              }
            },
          );
  }
}

class MobileProfilePage extends StatefulWidget {
  final ProfileData profileData;
  const MobileProfilePage({Key? key, required this.profileData})
      : super(key: key);

  @override
  State<MobileProfilePage> createState() => _MobileProfilePageState();
}

class _MobileProfilePageState extends State<MobileProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JamScene"),
      ),
      body: Column(
        children: [
          MainContent(profileData: widget.profileData),
        ],
      ),
      bottomNavigationBar: BottomNavigation(context: context),
    );
  }
}

class WebProfilePage extends StatefulWidget {
  final ProfileData profileData;
  const WebProfilePage({Key? key, required this.profileData}) : super(key: key);

  @override
  State<WebProfilePage> createState() => _WebProfilePageState();
}

class _WebProfilePageState extends State<WebProfilePage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SideNavigation(),
        const VerticalDivider(thickness: 1, width: 1),
        MainContent(
          profileData: widget.profileData,
        )
      ]),
    );
  }
}

class MainContent extends StatelessWidget {
  final ProfileData profileData;
  const MainContent({Key? key, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List location = [profileData.city, profileData.state];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              "https://picsum.photos/id/1025/200/200"),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profileData.username,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("AM",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("PM",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 2000),
              Text("${FirebaseAuth.instance.currentUser}"),
              ElevatedButton(
                  onPressed: (() => (FirebaseAuth.instance.signOut())),
                  child: const Text("Sign Out"))
            ],
          ),
        ),
      ),
    );
  }
}
