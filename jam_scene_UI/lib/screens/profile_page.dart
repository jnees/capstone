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
    return Scaffold(
        appBar: AppBar(title: const Text("JamScene")),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return const WebProfilePage();
            } else {
              return const MobileProfilePage();
            }
          },
        ));
  }
}

class MobileProfilePage extends StatelessWidget {
  const MobileProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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

class WebProfilePage extends StatelessWidget {
  const WebProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
