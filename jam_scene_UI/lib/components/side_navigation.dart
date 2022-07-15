import 'package:flutter/material.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      onDestinationSelected: (index) {},
      destinations: const [
        NavigationRailDestination(
          icon: Tooltip(message: "Profile", child: Icon(Icons.person)),
          label: Text("Profile"),
        ),
        NavigationRailDestination(
          icon: Tooltip(message: "Search Profiles", child: Icon(Icons.search)),
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
          icon: Tooltip(message: "Sign out", child: Icon(Icons.exit_to_app)),
          label: Text("Sign Out"),
        ),
      ],
    );
  }
}
