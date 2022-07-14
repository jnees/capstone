import 'package:flutter/material.dart';

class TempNewProfilePage extends StatefulWidget {
  const TempNewProfilePage({Key? key}) : super(key: key);

  @override
  State<TempNewProfilePage> createState() => _TempNewProfilePageState();
}

class _TempNewProfilePageState extends State<TempNewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("New Profile Page"),
    );
  }
}
