import 'package:flutter/material.dart';

class AdCreate extends StatefulWidget {
  const AdCreate({Key? key, required this.adsPageStateUpdater})
      : super(key: key);
  final Function adsPageStateUpdater;

  @override
  State<AdCreate> createState() => _AdCreateState();
}

class _AdCreateState extends State<AdCreate> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.adsPageStateUpdater({
              '_currView': 'Results',
              '_selectedAdId': '',
            });
          },
        ),
        const Text('Back to results'),
      ]),
      const Center(child: Text("Ad Create form goes here")),
    ]);
  }
}
