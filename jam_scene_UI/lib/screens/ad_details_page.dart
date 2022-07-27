import 'package:flutter/material.dart';
import '../models/instrument_lookup.dart';

class AdDetails extends StatefulWidget {
  const AdDetails(
      {Key? key, required this.adsPageStateUpdater, required this.adDetails})
      : super(key: key);

  final Function adsPageStateUpdater;
  final Map<String, dynamic> adDetails;

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                      '_selectedAdId': -1,
                    });
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => {
              widget.adsPageStateUpdater({
                '_currView': 'Profile',
                '_selectedUserId': widget.adDetails['posted_by'],
              })
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.adDetails['profile_photo']),
              radius: MediaQuery.of(context).size.height * .1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.adDetails['title'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text("Posted by: ${widget.adDetails['username']}"),
          Text(
              "Looking for ${instrumentLookup[widget.adDetails['instruments'][0]['id']]}"),
          Text(widget.adDetails['city'] + ', ' + widget.adDetails['state']),
          Text(widget.adDetails['post_date']),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("${widget.adDetails['description']}"),
          ),

          ElevatedButton.icon(
              onPressed: () {
                widget.adsPageStateUpdater({'_currView': 'Respond'});
              },
              icon: const Icon(Icons.mail),
              label: const Text("Respond")),
        ],
      ),
    );
  }
}
