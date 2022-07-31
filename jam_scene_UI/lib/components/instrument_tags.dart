import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jam_scene/styles.dart';

// Reference:
// Icons used from https://www.smashingmagazine.com/?p=250833

class InstrumentTag extends StatelessWidget {
  final int iid;
  final instrumentNames = {
    1: "Lead Singer",
    2: "Background Singer",
    3: "Drums",
    4: "Guitar",
    5: "Bass",
    6: "Cowbell",
    7: "Piano",
    8: "Synthesizer",
    9: "Violin",
    10: "Saxophone",
    11: "Bassoon",
    12: "Flute",
    13: "Other",
  };

  final colors = {
    1: Styles.tag1,
    2: Styles.tag2,
    3: Styles.tag3,
    4: Styles.tag4,
    5: Styles.tag5,
    6: Styles.tag6,
    7: Styles.tag7,
    8: Styles.tag8,
    9: Styles.tag9,
    10: Styles.tag10,
    11: Styles.tag11,
    12: Styles.tag12,
    13: Styles.tag13,
  };

  InstrumentTag({Key? key, required this.iid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fileName;
    iid < 1 || iid > 13
        ? fileName = 'assets/instruments/13.svg'
        : fileName = 'assets/instruments/$iid.svg';

    return Chip(
        backgroundColor: colors[iid],
        avatar: Container(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset(
            fileName,
            color: Colors.grey[800],
          ),
        ),
        label: Text("${instrumentNames[iid]}",
            style: const TextStyle(color: Colors.white)));
  }
}
