import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/components/visual_components.dart';
import 'package:jam_scene/styles.dart';
import '../models/instrument_lookup.dart';
import '../components/formatted_date.dart';

class AdDetails extends StatefulWidget {
  const AdDetails(
      {Key? key,
      required this.adsPageStateUpdater,
      required this.adDetails,
      required this.refreshAds})
      : super(key: key);

  final Function adsPageStateUpdater;
  final Map<String, dynamic> adDetails;
  final Function refreshAds;

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  late bool creatorView;

  @override
  void initState() {
    super.initState();
    _isCreator();
  }

  void _isCreator() {
    var user = FirebaseAuth.instance.currentUser!.uid;
    if (user == widget.adDetails['posted_by']) {
      setState(() {
        creatorView = true;
      });
    } else {
      setState(() {
        creatorView = false;
      });
    }
  }

  void _warnDeleteAd(adId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ad'),
        content: const Text('Are you sure you want to delete this ad?'),
        actions: [
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.pop(context);
              _deleteAd(adId);
            },
          ),
        ],
      ),
    );
  }

  void _deleteAd(adId) async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = Uri.parse('https://jam-scene-app.herokuapp.com/ad/$adId');
    var response = await http.delete(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      widget.adsPageStateUpdater({'_currView': 'Results'});
      widget.refreshAds(true);
    } else {
      debugPrint("Error: ${response.body}");
    }
  }

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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: ColoredBar(),
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
              radius: MediaQuery.of(context).size.height * .08,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.adDetails['title'],
              style: Styles.titleMedSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Text(
              "${widget.adDetails['description']}",
              style: Styles.titleSmallest,
            ),
          ),
          const SizedBox(height: 10),
          Text("Posted by: ${widget.adDetails['username']}"),
          Text(
              "Looking for ${instrumentLookup[widget.adDetails['instruments'][0]['id']]}"),
          Text(
            widget.adDetails['city'] + ', ' + widget.adDetails['state'],
            style: Styles.headline7Ital,
          ),
          FormattedDateFromString(date: widget.adDetails['post_date']),
          const SizedBox(height: 10),
          creatorView
              ? ElevatedButton.icon(
                  onPressed: () {
                    _warnDeleteAd(widget.adDetails['id']);
                  },
                  icon: const Icon(Icons.delete),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  label: const Text('Delete Ad'),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    widget.adsPageStateUpdater({'_currView': 'Respond'});
                  },
                  icon: const Icon(Icons.mail),
                  label: const Text("Respond")),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: ColoredBar(),
          ),
        ],
      ),
    );
  }
}
