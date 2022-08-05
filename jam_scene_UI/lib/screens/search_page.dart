import "dart:convert";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:jam_scene/components/visual_components.dart';
import 'package:jam_scene/models/instrument_lookup.dart';
import 'package:jam_scene/styles.dart';
import '../screens/profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const routeName = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // State variables
  final _formkey = GlobalKey<FormState>();
  bool sun = false;
  bool mon = false;
  bool tue = false;
  bool wed = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  String instrument = "Lead Singer";
  final TextEditingController _zipController = TextEditingController();
  List<dynamic> results = [];
  bool showSearchForm = true;
  String? currUserSelection;
  bool showingProfile = false;

  // Helper functions
  void _loadSearchResults() async {
    // Get form information for request body
    Map<String, dynamic> formData = {};
    formData["zip"] = _zipController.text;
    formData["instrument"] = instrument;
    formData["days"] = {
      "sun": sun,
      "mon": mon,
      "tue": tue,
      "wed": wed,
      "thu": thu,
      "fri": fri,
      "sat": sat
    };

    // Send request to server
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = Uri.parse('https://jam-scene-app.herokuapp.com/users/search');
    var response = await http.post(url,
        body: json.encoder.convert(formData),
        headers: {'content-type': 'application/json'});
    if (response.statusCode == 200) {
      var data = response.body;
      setState(() {
        results = json.decode(data);
        showSearchForm = false;
      });
    } else {
      debugPrint("Error: ${response.body}");
    }
  }

  void _showSelectedProfile(otherUserUid) {
    // Takes the user to the profile page of the selected user
    setState(() {
      showingProfile = true;
      currUserSelection = otherUserUid;
    });
  }

  Widget _buildSearchResults(context) {
    // Generates list of users to display in search results
    return Column(
      children: [
        Row(
          children: [
            // Back button functionality changes based on page state.
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // if on profile page, go back to results
                if (showingProfile) {
                  setState(() {
                    showingProfile = false;
                  });
                  // if on results page, go back to search form
                } else {
                  setState(() {
                    showSearchForm = true;
                  });
                }
              },
            ),
            showingProfile ? const Text("Search Results") : const Spacer(),
            const Spacer(),
            !showingProfile
                ? Text("${results.length} Search Results...")
                : const Spacer(),
          ],
        ),
        showingProfile
            ? Expanded(
                child: Row(
                  children: [
                    Expanded(child: selectedProfile(currUserSelection)),
                  ],
                ),
              )
            : Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black45,
                    thickness: 2,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        _showSelectedProfile(results[index]['id']);
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(results[index]["profile_photo"]),
                      ),
                      title: Text(results[index]["username"]),
                      subtitle: Column(
                        children: [
                          Text(
                            results[index]['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Wrap(spacing: 10, runSpacing: -5, children: [
                            for (var instrument in results[index]
                                ["instruments"])
                              Chip(
                                  label: Text(instrument['name']),
                                  backgroundColor: Colors.grey[300]),
                          ]),
                        ],
                      ),
                      trailing: Text(
                        results[index]["city"] + ", " + results[index]["state"],
                        style: Styles.headline7Ital,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !showSearchForm
          ? _buildSearchResults(context)
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: ColoredBar(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Search for Musicians",
                            style: Styles.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Styles.charcoal,
                            width: 3.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            height: 400,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Text("Looking for..."),
                                      const Spacer(),
                                      DropdownButton(
                                          value: instrument,
                                          onChanged: (selectedValue) {
                                            if (selectedValue is String) {
                                              setState(() {
                                                instrument = selectedValue;
                                              });
                                            }
                                          },
                                          items: [
                                            for (var i
                                                in instrumentLookup.values)
                                              DropdownMenuItem(
                                                value: i,
                                                child: Text(i),
                                              ),
                                          ]),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Near zipcode",
                                    hintText: "90210",
                                  ),
                                  controller: _zipController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter a zipcode";
                                    }
                                    return null;
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Must be available..."),
                                ),
                                Wrap(
                                  children: [
                                    FractionallySizedBox(
                                        widthFactor: .45,
                                        child: CheckboxListTile(
                                          value: sun,
                                          title: const Text("Sun"),
                                          onChanged: (value) {
                                            setState(() {
                                              sun = value as bool;
                                            });
                                          },
                                        )),
                                    FractionallySizedBox(
                                      widthFactor: .45,
                                      child: CheckboxListTile(
                                        value: mon,
                                        title: const Text("Mon"),
                                        onChanged: (value) {
                                          setState(() {
                                            mon = value as bool;
                                          });
                                        },
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: .45,
                                      child: CheckboxListTile(
                                        value: tue,
                                        title: const Text("Tue"),
                                        onChanged: (value) {
                                          setState(() {
                                            tue = value as bool;
                                          });
                                        },
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: .45,
                                      child: CheckboxListTile(
                                        value: wed,
                                        title: const Text("Wed"),
                                        onChanged: (value) {
                                          setState(() {
                                            wed = value as bool;
                                          });
                                        },
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: .45,
                                      child: CheckboxListTile(
                                        value: thu,
                                        title: const Text("Thu"),
                                        onChanged: (value) {
                                          setState(() {
                                            thu = value as bool;
                                          });
                                        },
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: .45,
                                      child: CheckboxListTile(
                                        value: fri,
                                        title: const Text("Fri"),
                                        onChanged: (value) {
                                          setState(() {
                                            fri = value as bool;
                                          });
                                        },
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: .45,
                                      child: CheckboxListTile(
                                        value: sat,
                                        title: const Text("Sat"),
                                        onChanged: (value) {
                                          setState(() {
                                            sat = value as bool;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _loadSearchResults();
                                    },
                                    child: const Text("Search"))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

Widget selectedProfile(selectedUid) {
  return SingleChildScrollView(
    child: ProfilePage(
      otherUserId: selectedUid,
    ),
  );
}
