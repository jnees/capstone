import 'package:flutter/material.dart';
import '../screens/profile_page.dart';

class AdProfileWrapper extends StatefulWidget {
  const AdProfileWrapper(
      {Key? key,
      required this.adsPageStateUpdater,
      required this.selectedUserId})
      : super(key: key);
  final Function adsPageStateUpdater;
  final String selectedUserId;

  @override
  State<AdProfileWrapper> createState() => _AdProfileWrapperState();
}

class _AdProfileWrapperState extends State<AdProfileWrapper> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  widget.adsPageStateUpdater({
                    '_currView': 'AdDetails',
                  });
                },
              ),
              const Text("Back to ad results")
            ],
          ),
          ProfilePage(
            otherUserId: widget.selectedUserId,
          ),
        ],
      ),
    );
  }
}
