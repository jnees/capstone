import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/JamSceneLogoRaised.png',
      height: MediaQuery.of(context).size.height * .35,
    );
  }
}
