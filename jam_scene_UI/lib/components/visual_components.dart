import 'package:flutter/material.dart';
import 'package:jam_scene/styles.dart';

class ColoredBar extends StatelessWidget {
  const ColoredBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      width: MediaQuery.of(context).size.width * 0.98,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: Styles.salmonJam,
        ),
      ));
  }
}