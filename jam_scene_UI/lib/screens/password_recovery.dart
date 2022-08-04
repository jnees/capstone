import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jam_scene/styles.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({Key? key, required this.loginStateSetter})
      : super(key: key);
  final Function loginStateSetter;

  @override
  State<PasswordRecovery> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  void _sendRecoveryEmail(email) async {
    // Sends a recovery email to the user.
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Key recoveryFormKey = GlobalKey<FormState>();
  final TextEditingController recoveryEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return password recovery form
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: recoveryFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Recover Your Password.',
                textAlign: TextAlign.center,
                style: Styles.titleMedium,
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: TextFormField(
                    controller: recoveryEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      fillColor: Color.fromARGB(255, 248, 247, 247),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email.';
                      }
                      return null;
                    }),
              ),
              //submit button
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: .5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        widget.loginStateSetter({'passwordRecovery': false});
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Send Recovery Email'),
                      onPressed: () {
                        if (recoveryEmailController.text.isNotEmpty) {
                          _sendRecoveryEmail(recoveryEmailController.text);
                          widget.loginStateSetter({'passwordRecovery': false});
                          // show message that recovery email has been sent
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.only(bottom: 50.0),
                              content: Text(
                                  "Recovery message sent to ${recoveryEmailController.text}"),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
