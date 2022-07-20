import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Reference:
// Icons used from https://www.smashingmagazine.com/?p=250833

class InstrumentTag extends StatelessWidget {
  final num iid;
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

  InstrumentTag({Key? key, required this.iid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check that iid is a valid instrument
    if (iid >= 1 && iid <= 13) {
      final String fileName = 'instruments/$iid.svg';

      return Chip(
        avatar: Container(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset(
            fileName,
            color: Colors.black,
          ),
        ),
        label: Text("${instrumentNames[iid]}"));
    } else {
      // if iid is not a valid instrument, 
      // use the "Other" instrument (iid = 13)
      const num otherIid = 13;
      const String fileName = 'instruments/$otherIid.svg';

      return Chip(
        avatar: Container(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset(
            fileName,
            color: Colors.black,
          ),
        ),
        label: const Text("Other"));
    }
  }
}
