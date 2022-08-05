import 'package:flutter/material.dart';
import '../models/instrument_lookup.dart';

class AdSearch extends StatefulWidget {
  const AdSearch(
      {Key? key,
      required this.adsPageStateUpdater,
      required this.setFilter,
      required this.clearFilter})
      : super(key: key);

  final Function adsPageStateUpdater;
  final Function setFilter;
  final Function clearFilter;

  @override
  State<AdSearch> createState() => _AdSearchState();
}

class _AdSearchState extends State<AdSearch> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  String instrument = "Lead Singer";

  void _filterSearchResults() {
    widget.setFilter(
        zipcode: _zipController.text,
        city: _cityController.text,
        state: _stateController.text,
        instrument: instrument);

    widget.adsPageStateUpdater({
      '_currView': 'Results',
      '_selectedAdId': -1,
    });
  }

  @override
  Widget build(BuildContext context) {
    final adSearchFormKey = GlobalKey<FormState>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _filterSearchResults,
            ),
            const Text('Back to results'),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: adSearchFormKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Filter",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Instrument"),
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                        onPressed: () {
                          _filterSearchResults();
                        },
                        child: const Text("Apply Filter")),
                  ),
                ]),
              ),
            ),
          ),
        )
      ],
    );
  }
}
