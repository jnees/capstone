import 'package:flutter/material.dart';

class AdRespond extends StatefulWidget {
  const AdRespond(
      {Key? key, required this.adsPageStateUpdater, required this.adDetails})
      : super(key: key);
  final Function adsPageStateUpdater;
  final Map<String, dynamic> adDetails;

  @override
  State<AdRespond> createState() => _AdRespondState();
}

class _AdRespondState extends State<AdRespond> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // back button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  widget.adsPageStateUpdater({
                    '_currView': 'AdDetails',
                  });
                },
              )
            ],
          ),
          Text('Responding to user ${widget.adDetails['username']}'),
        ],
      ),
    );
  }
}
