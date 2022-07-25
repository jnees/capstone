import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mock_ad_results.dart';
import '../models/instrument_lookup.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key}) : super(key: key);
  static const routeName = '/ads';

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  // Using mock data for layout building.
  late List<Map<String, dynamic>> results;
  String currView = 'Results';
  String selectedAdId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAds();
  }

  void _getAds() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      results = mockAds;
      currView = 'Results';
    });
  }

  void adsPageStateUpdater(Map<String, dynamic> stateChanges) {
    setState(() {
      if (stateChanges.containsKey('_currView')) {
        currView = stateChanges['_currView'];
      }
      if (stateChanges.containsKey('_selectedAdId')) {
        selectedAdId = stateChanges['_selectedAdId'];
      }
    });
  }

  // Main View Handler for the Ads Tab.
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (currView == 'Results') {
        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return AdResults(
            results: results,
            adsPageStateUpdater: adsPageStateUpdater,
          );
        }
      } else if (currView == 'AdDetails') {
        return AdDetails(
          id: selectedAdId,
          adsPageStateUpdater: adsPageStateUpdater,
        );
      } else {
        return const Text("Error try again");
      }
    });
  }
}

class AdResults extends StatelessWidget {
  const AdResults(
      {Key? key, required this.results, required this.adsPageStateUpdater})
      : super(key: key);

  final List<Map<String, dynamic>> results;
  final Function adsPageStateUpdater;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Showing x results..."),
              const Spacer(),
              const Text("Filter Ads"),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  adsPageStateUpdater({'_showSearch': true});
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black45,
              thickness: 2,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  adsPageStateUpdater({
                    '_currView': 'AdDetails',
                    '_selectedAdId': results[index]['id'],
                  });
                },
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(results[index]['profile_photo']),
                ),
                title: Text(results[index]['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(results[index]['username']),
                    Text(instrumentLookup[results[index]['instrument']]!),
                  ],
                ),

                /// instruments
                trailing: Column(
                  children: [
                    Text(results[index]["city"] +
                        ", " +
                        results[index]["state"]),
                    Text(results[index]["post_date"]),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
