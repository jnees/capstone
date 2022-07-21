import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    1: const Color.fromRGBO(3, 217, 158, 1),
    2: const Color.fromRGBO(242, 8, 25, 1),
    3: const Color.fromRGBO(255, 167, 23, 1),
    4: const Color.fromRGBO(45, 188, 0, 1),
    5: const Color.fromRGBO(197, 18, 232, 1),
    6: const Color.fromRGBO(57, 83, 212, 1),
    7: const Color.fromRGBO(3, 217, 158, 1),
    8: const Color.fromRGBO(242, 8, 25, 1),
    9: const Color.fromRGBO(255, 167, 23, 1),
    10: const Color.fromRGBO(45, 188, 0, 1),
    11: const Color.fromRGBO(197, 18, 232, 1),
    12: const Color.fromRGBO(57, 83, 212, 1),
    13: const Color.fromRGBO(3, 217, 158, 1),
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
