import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jam_scene/styles.dart';
import '../models/instrument_lookup.dart';
import '../components/formatted_date.dart';

class AdResults extends StatelessWidget {
  const AdResults(
      {Key? key,
      required this.results,
      required this.adsPageStateUpdater,
      required this.refreshAds,
      required this.isFiltered})
      : super(key: key);

  final List<dynamic> results;
  final Function adsPageStateUpdater;
  final Function refreshAds;
  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isFiltered
                  ? const Text("Showing filtered ads...")
                  : const Text("Showing most recent ads..."),
              const Spacer(),
              isFiltered
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        refreshAds(true);
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        adsPageStateUpdater(
                            {'_currView': "AdSearch", '_selectedAdId': -1});
                      },
                    ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await refreshAds(false);
            },
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
                      // Text(results[index]['username']),
                      Text(
                          '${results[index]['username']} is looking for ${instrumentLookup[results[index]['instruments'][0]['id']]!}'),
                    ],
                  ),

                  /// instruments
                  trailing: Column(
                    children: [
                      Text(
                        results[index]["city"] + ", " + results[index]["state"],
                        style: Styles.headline7Ital,
                      ),
                      FormattedDateFromString(
                          date: results[index]["post_date"]),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity,
                  max(50, MediaQuery.of(context).size.width * .08)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Create Your Own Ad"),
              ],
            ),
            onPressed: () {
              adsPageStateUpdater({
                '_currView': 'AdCreate',
              });
            },
          ),
        ),
      ],
    );
  }
}
