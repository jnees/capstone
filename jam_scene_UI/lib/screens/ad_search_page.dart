import 'package:flutter/material.dart';

class AdSearch extends StatefulWidget {
  const AdSearch({Key? key, required this.adsPageStateUpdater})
      : super(key: key);

  final Function adsPageStateUpdater;

  @override
  State<AdSearch> createState() => _AdSearchState();
}

class _AdSearchState extends State<AdSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
          ],
        ),
        const Text("Ad Search form goes here"),
      ],
    );
  }
}
