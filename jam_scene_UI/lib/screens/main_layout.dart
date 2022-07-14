import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/side_navigation.dart';
import '../screens/temp_new_profile_page.dart';
import '../screens/search_page.dart';
import '../screens/ads_page.dart';
import '../screens/messages_page.dart';
import '../screens/settings_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  final screens = [
    const TempNewProfilePage(),
    const SearchPage(),
    const AdsPage(),
    const MessagesPage(),
    const SettingsPage()
  ];

  // Token for solange
  String token = "loading";

  void getToken() async {
    // print('getting token');
    FirebaseAuth.instance.currentUser?.getIdToken().then((token) {
      // print(token);
      setState(() {
        token = token;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SideNavigation(),
                  VerticalDivider(thickness: 1, width: 1),
                  Text("Web Layout"),
                ]),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("JamScene"),
            ),
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                onTap: (index) => setState(() => currentIndex = index),
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Profile"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: "Search"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.newspaper), label: "Ads"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.mail), label: "Messages"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                ]),
          );
        }
      },
    );
  }
}
