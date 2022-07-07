import 'package:flutter/material.dart';

class HorizontalOrDivider extends StatelessWidget {
  const HorizontalOrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rowHeight = MediaQuery.of(context).size.height * .05;

    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 30.0, right: 15),
            child: Divider(
              color: Colors.black,
              height: rowHeight,
              thickness: 1.25,
            )),
      ),
      const Text(
        "OR",
        style: TextStyle(fontSize: 18),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15, right: 30.0),
            child: Divider(
              color: Colors.black,
              height: rowHeight,
              thickness: 1.25,
            )),
      ),
    ]);
  }
}
