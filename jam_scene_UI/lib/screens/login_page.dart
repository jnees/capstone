import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import '../components/horizontal_or_divider.dart';
import '../components/logo.dart';
import '../components/background_texture.dart';
import '../models/google_sign_in_functions.dart';
import '../screens/password_recovery.dart';

/*
  Login and registration forms are contained in this widget. Note that this
  widget does not have its own route. App uses AuthticationWrapper to route to
  login/registration.
  
  Reference: 
  This widget was derived from the Google Firebase Auth quickstart
  example, which can be found here: 
  https://github.com/firebase/quickstart-flutter/blob/main/authentication/lib/src/login_page.dart
*/

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool passwordRecovery = false;
  bool _isLoading = false;
  bool _isSigningUp = false;

  void _setIsLoading() {
    // Toggles loading state.
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void loginStateUpdater(Map<String, dynamic> stateChanges) {
    setState(() {
      if (stateChanges.containsKey('passwordRecovery')) {
        passwordRecovery = stateChanges['passwordRecovery'];
      }
    });
  }

  // Account Creation Handler
  Future<UserCredential?> _signUpWithEmailAndPassword() async {
    _setIsLoading();
    try {
      // Attempt to get a new credential from Firebase
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      return credential;
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      _setIsLoading();
      debugPrint(e.message);
      return null;
    }
  }

  // Account Log In Handler (Email/Password)
  Future<UserCredential?> _loginWithEmailAndPassword() async {
    _setIsLoading();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      return credential;
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      _setIsLoading();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // Stack Allows Background Texture to be under form.
        body: SingleChildScrollView(
          child: Stack(
            children: [
              const BackgroundTexture(),
              passwordRecovery
                  ? PasswordRecovery(
                      loginStateSetter: loginStateUpdater,
                    )
                  : Column(
                      children: [
                        const Logo(),
                        Form(
                          key: _formKey,
                          child:
                              Column(mainAxisSize: MainAxisSize.max, children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 450,
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: _textInputBoxDecoration("Email"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 450,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration:
                                      _textInputBoxDecoration("Password"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 450,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isSigningUp = !_isSigningUp;
                                            });
                                          },
                                          child: _isSigningUp
                                              ? const Text(
                                                  "Use Existing Sign In",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              : const Text("Register",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15))),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              passwordRecovery = true;
                                            });
                                          },
                                          child: const Text("Forgot password?",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Empty Space
                            const SizedBox(
                              width: 450,
                              height: 30,
                            ),
                            // Sign In Button
                            SizedBox(
                              width: 400,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0)),
                                    textStyle: const TextStyle(
                                      fontSize: 28,
                                    ),
                                    primary: const Color(0xFFF5A986)),
                                onPressed: () async {
                                  _isSigningUp
                                      ? await _signUpWithEmailAndPassword()
                                      : await _loginWithEmailAndPassword();

                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {}
                                },
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(_isSigningUp ? 'Sign Up' : 'Log In'),
                              ),
                            ),
                            const SizedBox(
                              width: double.maxFinite,
                              child: Padding(
                                padding: EdgeInsets.all(22.0),
                                child: HorizontalOrDivider(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                  width: 300,
                                  height: 60,
                                  child: SignInButton(
                                    Buttons.Google,
                                    onPressed: signInWithGoogle,
                                  )),
                            ),
                            const SizedBox(
                              height: 300,
                            ),
                          ]),
                        ),
                      ],
                    )
            ],
          ),
        ));
  }
}

InputDecoration _textInputBoxDecoration(label) {
  return InputDecoration(
    label: Text(label),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
    fillColor: const Color.fromARGB(255, 248, 247, 247),
    filled: true,
  );
}

rowHeight(context) {
  return MediaQuery.of(context).size.height * .05;
}
