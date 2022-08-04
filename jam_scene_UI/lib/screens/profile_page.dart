import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/components/instrument_tags.dart';
import 'package:jam_scene/components/visual_components.dart';
import 'package:jam_scene/screens/new_user_form.dart';
import 'package:jam_scene/styles.dart';
import '../models/profile_data.dart';
import '../components/formatted_date.dart';
import '../components/availability_table.dart';
import '../screens/edit_profile_form.dart';

class ProfilePage extends StatefulWidget {
  final String? otherUserId;
  const ProfilePage({Key? key, this.otherUserId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileData profileData;
  List location = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool loading = true;
  bool newUser = false;
  TextEditingController messageController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  late bool ownProfile;
  bool editingProfile = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      ownProfile = widget.otherUserId == null;
    });
    _fetchProfileData();
  }

  String? getConvoId() {
    if (widget.otherUserId == null) {
      return null;
    }
    List<String> users = [uid, widget.otherUserId!];
    users.sort();
    return "${users[0]}+${users[1]}";
  }

  void _sendMessage() async {
    if (widget.otherUserId == null || messageController.text.isEmpty) {
      return;
    }
    var message = {
      'convoId': getConvoId(),
      'senderId': uid,
      'receiverId': widget.otherUserId,
      'body': messageController.text,
      'time_sent': DateTime.now().toString(),
    };

    Uri url = Uri.parse('https://jam-scene-app.herokuapp.com/messages/');
    var response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: json.encode(message));
    if (response.statusCode == 200) {
      messageController.clear();
    }
  }

  void _submitReview() async {
    if (reviewController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> review = {
      "for_user": profileData.id,
      "by_user": uid,
      "time_posted": DateTime.now().toString(),
      "description": reviewController.text,
    };

    Uri url = Uri.parse('https://jam-scene-app.herokuapp.com/reviews');
    var response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: json.encode(review));
    if (response.statusCode == 200) {
      reviewController.clear();
      _fetchProfileData();
    }
  }

  void _showMessageForm() {
    showModalBottomSheet(
      backgroundColor: Styles.salmonJamTint2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) => Column(
        children: [
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Send a message to ${profileData.username}",
                style: Styles.headline6),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Form(
              key: GlobalKey<FormState>(),
              child: TextFormField(
                autofocus: true,
                minLines: 5,
                maxLines: 6,
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              child: const Text('Send'),
              onPressed: () {
                Navigator.of(context).pop();
                _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewForm() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Review ${profileData.username}?",
                style: Styles.headline6),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: GlobalKey<FormState>(),
              child: TextFormField(
                minLines: 4,
                maxLines: 6,
                autofocus: true,
                controller: reviewController,
                decoration: InputDecoration(
                    labelText: 'Review',
                    border: const OutlineInputBorder(),
                    hintText:
                        "What is great about jamming with ${profileData.username}?"),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop();
              _submitReview();
            },
          ),
        ],
      ),
    );
  }

  void _fetchProfileData() async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = 'https://jam-scene-app.herokuapp.com/user/$uid';

    // If we're looking at our own profile, use the user's id, else use the other user's id.
    if (widget.otherUserId != null && widget.otherUserId != "") {
      url = 'https://jam-scene-app.herokuapp.com/user/${widget.otherUserId}';
    }

    var uri = Uri.parse(url);
    var response = await http.get(uri, headers: {'Authorization': token});
    if (jsonDecode(response.body)['user'].isEmpty) {
      if (!mounted) {
        return;
      }
      return setState(() {
        loading = false;
        newUser = true;
      });
    }

    if (!mounted) {
      return;
    }
    setState(() {
      profileData = ProfileData.fromJson(jsonDecode(response.body)['user'][0]);
      loading = false;
      location = [profileData.city, profileData.state];
    });
  }

  void _deleteReview(reviewId) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    Uri uri = Uri.parse('https://jam-scene-app.herokuapp.com/review/$reviewId');
    var response = await http.delete(uri, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      _fetchProfileData();
    }
  }

  void _warnDeleteReview(reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteReview(reviewId);
            },
          ),
        ],
      ),
    );
  }

  void profileStateSetter(Map<String, dynamic> stateChanges) {
    setState(() {
      if (stateChanges.containsKey('edittingProfile')) {
        editingProfile = stateChanges['edittingProfile'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : newUser
            ? const NewUserForm()
            : editingProfile
                ? EditProfileForm(
                    profileData: profileData,
                    profileStateSetter: profileStateSetter)
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          profileData.profilePhoto),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(profileData.username,
                                        style: Styles.titleMedium),
                                    Text(
                                      location.join(", "),
                                      style: Styles.headline6Ital,
                                    ),
                                  ],
                                ),
                              ),
                              if (ownProfile) const SizedBox(width: 20),
                              if (ownProfile)
                                IconButton(
                                  tooltip: "Edit Profile",
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      editingProfile = true;
                                    });
                                  },
                                ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: ColoredBar(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(
                                profileData.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 8,
                                style: Styles.titleSmall,
                              )),
                            ],
                          ),
                          const SizedBox(height: 10),
                          !ownProfile
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showMessageForm();
                                      },
                                      child: const Text("Send Message"),
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      "Influences",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    profileData.influences,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ))
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3.0),
                                      child: Text("Recordings",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Text(profileData.recordings),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.0),
                                child: Text("Instruments",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: -5,
                            spacing: 10,
                            children: [
                              for (var instrument in profileData.instruments)
                                InstrumentTag(iid: instrument['id']),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text("Availability",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Styles.charcoal,
                                        width: 3,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: AvailabilityTable(
                                          profileData: profileData),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: Text("Reviews",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          for (var review in profileData.reviews)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(review['profile_photo']),
                                    ),
                                    trailing:
                                        review['by_user'] == uid || ownProfile
                                            ? IconButton(
                                                tooltip: "Delete Review",
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  _warnDeleteReview(
                                                      review['reviewid']);
                                                },
                                              )
                                            : null,
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(review['by_username']),
                                        const SizedBox(width: 10.0),
                                        FormattedDateFromString(
                                            date: review['time_posted']),
                                      ],
                                    ),
                                    title: Text(review["description"]),
                                  ),
                                )
                              ],
                            ),
                          if (!ownProfile)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showReviewForm();
                                  },
                                  child: const Text("Add a Review"),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
  }
}
