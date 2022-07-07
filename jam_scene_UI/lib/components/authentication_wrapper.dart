import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/profile_page.dart';
import '../screens/login_page.dart';

class AuthticationWrapper extends StatefulWidget {
  const AuthticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthticationWrapper> createState() => _AuthticationWrapperState();
}

class _AuthticationWrapperState extends State<AuthticationWrapper> {
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          currentUser = null;
        });
      } else {
        setState(() {
          currentUser = user;
        });
      }
    });
    return FirebaseAuth.instance.currentUser == null
        ? const LoginPage()
        : const ProfilePage();
  }
}
