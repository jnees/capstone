import 'package:flutter/material.dart';
import '../screens/profile_page.dart';
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
    const ProfilePage(),
    const SearchPage(),
    const AdsPage(),
    const MessagesPage(),
    const SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              NavigationRail(
                onDestinationSelected: (index) =>
                    setState(() => currentIndex = index),
                selectedIndex: currentIndex,
                destinations: const [
                  NavigationRailDestination(
                    icon:
                        Tooltip(message: "Profile", child: Icon(Icons.person)),
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
                    icon: Tooltip(
                        message: "Settings", child: Icon(Icons.settings)),
                    label: Text("Settings"),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: screens[currentIndex]),
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
