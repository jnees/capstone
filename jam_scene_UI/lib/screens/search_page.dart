import "package:flutter/material.dart";
import 'package:jam_scene/components/instrument_tags.dart';

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

  String instrument = "Bass";
  final TextEditingController _zipController = TextEditingController();

  List results = [
    {
      "name": "Johnny Jams",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/780"
    },
    {
      "name": "Sally Strings",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/600"
    },
    {
      "name": "Dave Doodles",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/660"
    },
    {
      "name": "Bobby Bongs",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/640"
    },
    {
      "name": "Cindy Crayons",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/690"
    },
    {
      "name": "Yasmin Yarns",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/540"
    },
    {
      "name": "Chud Chords",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/680"
    },
    {
      "name": "Fanny Flicks",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/620"
    },
    {
      "name": "Nancy Nails",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "https://www.placecage.com/200/200"
    },
    {
      "name": "Uriah Cheapens",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "http://placebeard.it/720"
    },
    {
      "name": "Annie Oranges",
      "instruments": ["Drums", "Guitar", "Bass"],
      "location": "New York, NY",
      "image": "https://www.placecage.com/200/200"
    },
    {
      "name": "Ella Eggs",
      "instruments": ["Drums", "Guitar", "Piano"],
      "location": "New York, NY",
      "image": "http://placebeard.it/780"
    },
    {
      "name": "Brad Bagels",
      "instruments": ["Drums", "Guitar"],
      "location": "New York, NY",
      "image": "http://placebeard.it/790"
    },
    {
      "name": "Kylie Kickdrum",
      "instruments": ["Flute"],
      "location": "New York, NY",
      "image": "http://placebeard.it/800"
    }
  ];

  void _loadSearchResults() {
    setState(() {
      showSearchForm = false;
    });
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
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(results[index]["image"]),
                ),
                title: Text(results[index]["name"]),
                subtitle: Text(results[index]["instruments"].join(", ")),
                trailing: Text(results[index]["location"]),
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
                                      items: const [
                                        DropdownMenuItem(
                                          value: "Drums",
                                          child: Text("Drums"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Guitar",
                                          child: Text("Guitar"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Bass",
                                          child: Text("Bass"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Piano",
                                          child: Text("Piano"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Flute",
                                          child: Text("Flute"),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: const [
                                  InstrumentTag(iid: 1),
                                  InstrumentTag(iid: 2),
                                  InstrumentTag(iid: 3),
                                ],
                              )
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
