import 'package:flutter/material.dart';

class BackgroundTexture extends StatelessWidget {
  const BackgroundTexture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/JamSceneTexture.png',
        fit: BoxFit.cover,
        alignment: Alignment.center,
        repeat: ImageRepeat.repeat,
      ),
    );
  }
}
