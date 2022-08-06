import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/styles.dart';
import 'package:jam_scene/components/visual_components.dart';
import '../models/instrument_lookup.dart';
import '../models/profile_data.dart';
import 'dart:convert';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm(
      {Key? key, required this.profileData, required this.profileStateSetter})
      : super(key: key);
  final ProfileData profileData;
  final Function profileStateSetter;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser?.uid;
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

  // Init state sets default values for the form fields.
  @override
  void initState() {
    super.initState();
    _cityController.text = widget.profileData.city;
    _stateController.text = widget.profileData.state;
    _zipController.text = widget.profileData.zipcode;
    _descriptionController.text = widget.profileData.description;
    _recordingsController.text = widget.profileData.recordings;
    _influencesController.text = widget.profileData.influences;
    monAmAvail = widget.profileData.availMonAm;
    monPmAvail = widget.profileData.availMonPm;
    tueAmAvail = widget.profileData.availTueAm;
    tuePmAvail = widget.profileData.availTuePm;
    wedAmAvail = widget.profileData.availWedAm;
    wedPmAvail = widget.profileData.availWedPm;
    thuAmAvail = widget.profileData.availThuAm;
    thuPmAvail = widget.profileData.availThuPm;
    friAmAvail = widget.profileData.availFriAm;
    friPmAvail = widget.profileData.availFriPm;
    satAmAvail = widget.profileData.availSatAm;
    satPmAvail = widget.profileData.availSatPm;
    sunAmAvail = widget.profileData.availSunAm;
    sunPmAvail = widget.profileData.availSunPm;
    for (int i = 0; i < widget.profileData.instruments.length; i++) {
      instruments[widget.profileData.instruments[i]['id']] = true;
    }
  }

  bool loading = false;

  getDefaultImageURL() async {
    var url = await FirebaseStorage.instance
        .refFromURL("gs://jamscene-410d6.appspot.com/blank_profile.png")
        .getDownloadURL();
    return url;
  }

  Future<int> _sendUpdatesToDatabase() async {
    loading = true;
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return 0;

    String? photoURL = FirebaseAuth.instance.currentUser?.photoURL;
    // Set a default profile image if none is provided by the user's google account.
    photoURL ??= await getDefaultImageURL();

    Map formData = {};
    formData['uid'] = FirebaseAuth.instance.currentUser!.uid;
    formData['username'] = widget.profileData.username;
    formData['first_name'] = widget.profileData.firstName;
    formData['last_name'] = widget.profileData.lastName;
    formData['email'] = widget.profileData.email;
    formData['city'] = _cityController.text;
    formData['state'] = _stateController.text;
    formData['zip_code'] = _zipController.text;
    formData['join_date'] = widget.profileData.joinDate.toString();
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
    formData['photo'] = photoURL;

    for (var key in instruments.keys) {
      if (instruments[key]! == true) {
        formData['instruments'].add(key);
      }
    }

    var response = await http.put(
      Uri.parse(
          'https://jam-scene-app.herokuapp.com/user/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      },
      body: json.encode(formData),
    );
    loading = false;

    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    // back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        widget.profileStateSetter({'edittingProfile': false});
                      },
                    ),
                    const Text(
                      "Update your profile details:",
                      style: Styles.titleMedium,
                    ),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.all(20.0), child: ColoredBar()),
                Padding(
                  padding: const EdgeInsets.all(20.0),
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
                  padding: const EdgeInsets.all(20.0),
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
                  padding: const EdgeInsets.all(20.0),
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
                  padding: const EdgeInsets.all(20.0),
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
                  padding: const EdgeInsets.all(20.0),
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
                  padding: const EdgeInsets.all(20.0),
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "What instruments do you play?",
                        style: Styles.headline6,
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 270,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Styles.salmonJam,
                            width: 3.0,
                          ),
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView(
                            children:
                                List.generate(instruments.length, (index) {
                          return CheckboxListTile(
                            title: Row(
                              children: [
                                Text(instrumentLookup[index + 1]!),
                              ],
                            ),
                            value: instruments[index + 1],
                            onChanged: (bool? value) {
                              setState(() {
                                instruments[index + 1] =
                                    !instruments[index + 1]!;
                              });
                            },
                          );
                        })),
                      ),
                    )),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "When can you jam?",
                        style: Styles.headline6,
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 270,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Styles.salmonJam,
                            width: 3.0,
                          ),
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
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0)),
                              padding: const EdgeInsets.all(20.0),
                              textStyle: Styles.titleMedium,
                              primary: Styles.charcoal,
                            ),
                            onPressed: () {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState!.validate()) {
                                _sendUpdatesToDatabase().then(
                                  (status) {
                                    if (status == 200) {
                                      Navigator.of(context)
                                          .pushReplacementNamed("/");
                                    }
                                  },
                                );
                              }
                            },
                            child: const Text('Update'),
                          )),
                const SizedBox(height: 20),
              ],
            ),
          )),
    );
  }
}
