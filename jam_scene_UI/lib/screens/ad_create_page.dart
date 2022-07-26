import 'package:flutter/material.dart';
import '../models/instrument_lookup.dart';

class AdCreate extends StatefulWidget {
  const AdCreate({Key? key, required this.adsPageStateUpdater})
      : super(key: key);
  final Function adsPageStateUpdater;

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

  _loadSearchResults() {}

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
              '_selectedAdId': '',
            });
          },
        ),
        const Text('Back to results'),
      ]),
      // Create Ad Form
      Expanded(
        child: SingleChildScrollView(
          child: Form(
            key: _adCreateFormKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Create an ad",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                  minLines: 4,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: "What are you looking for?",
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Must be available..."),
              ),
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
              ElevatedButton(
                  onPressed: () {
                    _loadSearchResults();
                  },
                  child: const Text("Post Ad")),
            ]),
          ),
        ),
      )
    ]);
  }
}
