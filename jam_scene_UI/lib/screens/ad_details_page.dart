import 'package:flutter/material.dart';

class AdDetails extends StatefulWidget {
  const AdDetails(
      {Key? key, required this.adsPageStateUpdater, required this.id})
      : super(key: key);

  final Function adsPageStateUpdater;
  final String id;

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //row with back button and title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
            ],
          ),
        ),
        Text("Ad Details page for ${widget.id}"),
      ],
    );
  }
}
