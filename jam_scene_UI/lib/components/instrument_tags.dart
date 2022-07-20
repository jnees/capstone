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
    final String fileName = 'instruments/$iid.svg';
    final String photoName = 'instruments/$iid.png';

    // new idea: use chips
    return Chip(
        avatar: Container(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset(
            fileName,
            semanticsLabel: '${instrumentNames[iid]}',
            color: Colors.black,
          ),
        ),
        label: Text("${instrumentNames[iid]}")
    );

    // idea: Decorated Box > Row > (Icon & Text of iid)

    // return ConstrainedBox(
    //   constraints: const BoxConstraints(
    //     maxHeight: 40,
    //     minHeight: 40,
    //     maxWidth: 140,
    //     minWidth: 100,
    //   ),
    //   child: DecoratedBox(
    //     decoration: BoxDecoration(
    //       border: Border.all(
    //         color: Colors.blue,
    //         width: 1,
    //       ),
    //       color: Colors.blue,
    //       borderRadius: BorderRadius.circular(25),
    //     ),
    //     child: Row(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 8.0),
    //           child: SvgPicture.asset(
    //             fileName,
    //             semanticsLabel: '${instrumentNames[iid]}',
    //             color: Colors.black,
    //           ),
    //         ),
    //         Text('${instrumentNames[iid]}')
    //       ],
    //     ),
    //   ),
    // );
  }
}
