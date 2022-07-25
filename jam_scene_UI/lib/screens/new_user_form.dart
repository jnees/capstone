// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/styles.dart';
import '../models/instrument_lookup.dart';
import 'dart:convert';

class NewUserForm extends StatefulWidget {
  const NewUserForm({Key? key}) : super(key: key);

  @override
  State<NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _recordingsController = TextEditingController();
  final TextEditingController _influencesController = TextEditingController();

  bool monAmAvail = false;
  bool monPmAvail = false;
  bool tueAmAvail = false;
  bool tuePmAvail = false;
  bool wedAmAvail = false;
  bool wedPmAvail = false;
  bool thuAmAvail = false;
  bool thuPmAvail = false;
  bool friAmAvail = false;
  bool friPmAvail = false;
  bool satAmAvail = false;
  bool satPmAvail = false;
  bool sunAmAvail = false;
  bool sunPmAvail = false;

  Map<int, bool> instruments = {
    1: false, // lead singer
    2: false, // background singer
    3: false, // drums
    4: false, // Guitar
    5: false, // Bass
    6: false, // Cowbell
    7: false, // Piano
    8: false, // Synthesizer
    9: false, // Violin
    10: false, // Saxophone
    11: false, // Bassoon
    12: false, // Flute
    13: false, // Other
  };

  bool loading = false;

  Future<int> _sendToDatabase() async {
    loading = true;

    Map formData = {};
    formData['uid'] = FirebaseAuth.instance.currentUser!.uid;
    formData['username'] = _usernameController.text;
    formData['first_name'] = _firstNameController.text;
    formData['last_name'] = _lastNameController.text;
    formData['email'] = FirebaseAuth.instance.currentUser!.email;
    formData['city'] = _cityController.text;
    formData['state'] = _stateController.text;
    formData['zip_code'] = _zipController.text;
    formData['join_date'] = DateTime.now().toString();
    formData['description'] = _descriptionController.text;
    formData['recordings'] = _recordingsController.text;
    formData['influences'] = _influencesController.text;
    formData['avail_mon_am'] = monAmAvail;
    formData['avail_mon_pm'] = monPmAvail;
    formData['avail_tue_am'] = tueAmAvail;
    formData['avail_tue_pm'] = tuePmAvail;
    formData['avail_wed_am'] = wedAmAvail;
    formData['avail_wed_pm'] = wedPmAvail;
    formData['avail_thu_am'] = thuAmAvail;
    formData['avail_thu_pm'] = thuPmAvail;
    formData['avail_fri_am'] = friAmAvail;
    formData['avail_fri_pm'] = friPmAvail;
    formData['avail_sat_am'] = satAmAvail;
    formData['avail_sat_pm'] = satPmAvail;
    formData['avail_sun_am'] = sunAmAvail;
    formData['avail_sun_pm'] = sunPmAvail;
    formData['instruments'] = [];
    formData['photo'] = FirebaseAuth.instance.currentUser!.photoURL;

    for (var key in instruments.keys) {
      if (instruments[key]! == true) {
        formData['instruments'].add(key);
      }
    }

    var response = await http.post(
      Uri.parse('https://jam-scene-app.herokuapp.com/users'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': token
      },
      body: json.encode(formData),
    );
    loading = false;

    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Get ready to rock! Tell us about yourself."),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Select a username',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  controller: _usernameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter your first name',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                  controller: _firstNameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter your last name',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                  controller: _lastNameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter your city ',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                  controller: _cityController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your state',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter a state';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter your zipcode',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter a zipcode';
                    }
                    return null;
                  },
                  controller: _zipController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tell us about yourself',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Tell us more...';
                    } else {
                      return null;
                    }
                  },
                  controller: _descriptionController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Who are your influences?',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'What do you listen to?';
                    }
                    return null;
                  },
                  controller: _influencesController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Links to recordings',
                  ),
                  validator: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'You can add links to recordings here';
                    }
                    return null;
                  },
                  controller: _recordingsController,
                ),
              ),
              const Text("What instruments do you play?"),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Styles.salmonJam,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView(
                          children: List.generate(instruments.length, (index) {
                        return CheckboxListTile(
                          title: Text(instrumentLookup[index + 1]!),
                          value: instruments[index + 1],
                          onChanged: (bool? value) {
                            setState(() {
                              instruments[index + 1] = !instruments[index + 1]!;
                            });
                          },
                        );
                      })),
                    ),
                  )),
              const Text("When can you jam?"),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 400,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Styles.salmonJam,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView(
                        children: [
                          CheckboxListTile(
                            title: const Text("Monday AM"),
                            value: monAmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                monAmAvail = !monAmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Monday PM"),
                            value: monPmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                monPmAvail = !monPmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Tuesday AM"),
                            value: tueAmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                tueAmAvail = !tueAmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Tuesday PM"),
                            value: tuePmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                tuePmAvail = !tuePmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Wednesday AM"),
                            value: wedAmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                wedAmAvail = !wedAmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Wednesday PM"),
                            value: wedPmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                wedPmAvail = !wedPmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Thursday AM"),
                            value: thuAmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                thuAmAvail = !thuAmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Thursday PM"),
                            value: thuPmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                thuPmAvail = !thuPmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Friday AM"),
                            value: friAmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                friAmAvail = !friAmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Friday PM"),
                            value: friPmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                friPmAvail = !friPmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Saturday AM"),
                            value: satAmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                satAmAvail = !satAmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Saturday PM"),
                            value: satPmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                satPmAvail = !satPmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Sunday AM"),
                            value: sunAmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                sunAmAvail = !sunAmAvail;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Sunday PM"),
                            value: sunPmAvail,
                            onChanged: (bool? value) {
                              setState(() {
                                sunPmAvail = !sunPmAvail;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState!.validate()) {
                              _sendToDatabase().then(
                                (status) {
                                  if (status == 200) {
                                    Navigator.of(context)
                                        .pushReplacementNamed("/");
                                  }
                                },
                              );
                            }
                          },
                          child: const Text('Submit'),
                        )),
            ],
          ),
        ));
  }
}
