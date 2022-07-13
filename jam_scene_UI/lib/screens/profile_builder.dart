import 'package:flutter/material.dart';

class ProfileBuilder extends StatefulWidget {
  const ProfileBuilder({Key? key}) : super(key: key);

  static const routeName = '/profilebuilder';

  @override
  State<ProfileBuilder> createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  @override
  Widget build(BuildContext context) {
    return const Text("Let's get started!");
  }
}
