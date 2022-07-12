import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const WebProfilePage();
        } else {
          return const MobileProfilePage();
        }
      },
    );
  }
}

class MobileProfilePage extends StatefulWidget {
  const MobileProfilePage({Key? key}) : super(key: key);

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
      body: const Text("Mobile Profile Page"),
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
  const WebProfilePage({Key? key}) : super(key: key);

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
      body: Row(children: [
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
        const MainContent()
      ]),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text("${FirebaseAuth.instance.currentUser}"),
          ElevatedButton(
              onPressed: (() => (FirebaseAuth.instance.signOut())),
              child: const Text("Sign Out"))
        ],
      ),
    );
  }
}
