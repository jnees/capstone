import "dart:convert";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/styles.dart';
import '../models/instrument_lookup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdCreate extends StatefulWidget {
  const AdCreate(
      {Key? key, required this.adsPageStateUpdater, required this.refreshAds})
      : super(key: key);
  final Function adsPageStateUpdater;
  final Function refreshAds;

  @override
  State<AdCreate> createState() => _AdCreateState();
}

class _AdCreateState extends State<AdCreate> {
  // State Variables for for form.
  final _adCreateFormKey = GlobalKey<FormState>();
  bool sun = false;
  bool mon = false;
  bool tue = false;
  bool wed = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  String instrument = "Lead Singer";
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  _loadSearchResults() async {
    Map<String, dynamic> formData = {};
    formData['posted_by'] = FirebaseAuth.instance.currentUser!.uid;
    formData['city'] = _cityController.text;
    formData['state'] = _stateController.text;
    formData['zip_code'] = _zipController.text;
    formData['title'] = _titleController.text;
    formData['description'] = _descriptionController.text;
    formData['avail_mon_am'] = mon;
    formData['avail_mon_pm'] = mon;
    formData['avail_tue_am'] = tue;
    formData['avail_tue_pm'] = tue;
    formData['avail_wed_am'] = wed;
    formData['avail_wed_pm'] = wed;
    formData['avail_thu_am'] = thu;
    formData['avail_thu_pm'] = thu;
    formData['avail_fri_am'] = fri;
    formData['avail_fri_pm'] = fri;
    formData['avail_sat_am'] = sat;
    formData['avail_sat_pm'] = sat;
    formData['post_date'] = DateTime.now().toString();
    formData['instruments'] = [
      instrumentLookup.keys.firstWhere((k) => instrumentLookup[k] == instrument,
          orElse: () => -1)
    ];

    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = Uri.parse('https://jam-scene-app.herokuapp.com/ads');
    var response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: json.encode(formData));
    if (response.statusCode == 200) {
      widget.adsPageStateUpdater({'_currView': 'Results'});
      widget.refreshAds(true);
    } else {
      debugPrint("Error: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Navigation back to Results page.
      Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.adsPageStateUpdater({
              '_currView': 'Results',
              '_selectedAdId': -1,
            });
          },
        ),
        const Text('Back to results'),
      ]),
      // Create Ad Form
      Expanded(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: _adCreateFormKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Create An Ad",
                        style: Styles.titleLarge,
                      ),
                    ],
                  ),
                ),
                const SectionHeader(text: "Instrument"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("I'm looking for..."),
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
                            for (MapEntry e in instrumentLookup.entries)
                              DropdownMenuItem(
                                value: e.value,
                                child: Text(e.value),
                              ),
                          ]),
                    ],
                  ),
                ),
                const SectionHeader(text: "Near Location"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "City",
                      border: OutlineInputBorder(),
                    ),
                    controller: _cityController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a city";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "State Abbrev.",
                      border: OutlineInputBorder(),
                    ),
                    controller: _stateController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a state abbreviation";
                      } else if (value.length != 2) {
                        return "Please enter a valid abbreviation, like 'CA' or 'WA'.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Near zipcode",
                      hintText: "90210",
                      border: OutlineInputBorder(),
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
                ),
                const SectionHeader(text: "Ad Details"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 90,
                    minLines: 1,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please add a title to your ad.";
                      } else if (value.length > 90) {
                        return "Limit 90 characters.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 500,
                    minLines: 2,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: "Ad Description",
                      border: OutlineInputBorder(),
                    ),
                    controller: _descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter some text";
                      } else if (value.length > 500) {
                        return "Limit 500 characters.";
                      }
                      return null;
                    },
                  ),
                ),
                const SectionHeader(text: "Required Availability"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
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
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _loadSearchResults();
                      },
                      child: const Text("Post Your Ad")),
                ),
              ]),
            ),
          ),
        ),
      )
    ]);
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
