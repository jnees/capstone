import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jam_scene/styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _logOut() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
    }
  }

  void _deleteAccount() async {
    Navigator.pop(context, 'Delete');
    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url = Uri.parse('https://jam-scene-app.herokuapp.com/user/$uid');
    var response = await http.delete(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      _logOut();
    } else {
      debugPrint("Error deleting account");
    }
  }

  Widget deleteWarning() {
    return AlertDialog(
      elevation: 24,
      title: const Text('Delete Account?'),
      content: const Text('This is action is permanent cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _deleteAccount,
          child: const Text('Delete'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "User Settings",
              style: Styles.titleMedium,
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(onPressed: _logOut, child: const Text("Log Out")),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () => showDialog(
                    builder: (_) => deleteWarning(),
                    context: context,
                    barrierDismissible: true),
                child: const Text("Delete Account")),
          ),
        ],
      ),
    );
  }
}
