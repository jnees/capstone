import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/test_users.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  final profileData = grungeBob;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
  final List<Map<String, Object>> profileData;
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
        children: const [
          MainContent(profileData: grungeBob),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "Ads"),
            BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
    );
  }
}

class WebProfilePage extends StatefulWidget {
  final List<Map<String, Object>> profileData;
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
        NavigationRail(
          selectedIndex: 0,
          onDestinationSelected: (index) {},
          destinations: const [
            NavigationRailDestination(
              icon: Tooltip(message: "Profile", child: Icon(Icons.person)),
              label: Text("Profile"),
            ),
            NavigationRailDestination(
              icon: Tooltip(
                  message: "Search Profiles", child: Icon(Icons.search)),
              label: Text("Search"),
            ),
            NavigationRailDestination(
              icon: Tooltip(message: "Ads", child: Icon(Icons.newspaper)),
              label: Text("Ads"),
            ),
            NavigationRailDestination(
              icon: Tooltip(message: "Messages", child: Icon(Icons.mail)),
              label: Text("Messages"),
            ),
            NavigationRailDestination(
              icon: Tooltip(message: "Settings", child: Icon(Icons.settings)),
              label: Text("Settings"),
            ),
            NavigationRailDestination(
              icon:
                  Tooltip(message: "Sign out", child: Icon(Icons.exit_to_app)),
              label: Text("Sign Out"),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        MainContent(
          profileData: widget.profileData,
        )
      ]),
    );
  }
}

class MainContent extends StatelessWidget {
  final List<Map<String, Object>> profileData;
  const MainContent({Key? key, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = profileData[0]['username'] as String;
    String description = profileData[0]['description'] as String;
    List location = [
      profileData[0]['city'] as String,
      profileData[0]['state'] as String
    ];
    String influences = profileData[0]['influences'] as String;
    String recordings = profileData[0]['recordings'] as String;

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
                      Text(username),
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
                  Flexible(child: Text(description)),
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
                      const Text("Influences"),
                      Text(influences),
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
                      const Text("Recordings"),
                      Text(recordings),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 3000),
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
