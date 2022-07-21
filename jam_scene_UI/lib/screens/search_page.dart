import "dart:convert";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:jam_scene/models/instrument_lookup.dart';
import '../components/instrument_tags.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const routeName = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formkey = GlobalKey<FormState>();
  bool showSearchForm = true;
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

    debugPrint("Sending req with body: ${json.encoder.convert(formData)}");

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

  Widget _buildSearchResults() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  showSearchForm = true;
                });
              },
            ),
            const Spacer(),
            Text("${results.length} Search Results..."),
          ],
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
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(results[index]["profile_photo"]),
                ),
                title: Text(results[index]["username"]),
                subtitle: Wrap(spacing: 3, runSpacing: -10, children: [
                  for (var instrument in results[index]["instruments"])
                    InstrumentTag(iid: instrument['id']),
                ]),
                trailing: Text(
                    results[index]["city"] + ", " + results[index]["state"]),
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
          ? _buildSearchResults()
          : Form(
              key: _formkey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Find Musicians"),
                    ],
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
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
                                        for (var i in instrumentLookup.values)
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
    );
  }
}
