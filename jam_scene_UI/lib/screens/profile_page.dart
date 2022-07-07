import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("JamScene")),
        body: Center(
            child: Column(
          children: [
            Text("${FirebaseAuth.instance.currentUser}"),
            ElevatedButton(
                onPressed: (() => (signOut())), child: const Text("Sign Out"))
          ],
        )));
  }
}
