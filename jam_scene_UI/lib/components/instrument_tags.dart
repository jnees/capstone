import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstrumentTag extends StatelessWidget {
  final num iid;

  const InstrumentTag({Key? key, required this.iid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // idea: Decorated Box > Row > (Icon & Text of iid)
    final String fileName = 'instruments/$iid.svg';

    return SizedBox(
      width: 100,
      height: 100,
      child: SvgPicture.asset(
        fileName,
        semanticsLabel: 'Lead Singer',
        color: Colors.black,
      ),
    );
  }
}
