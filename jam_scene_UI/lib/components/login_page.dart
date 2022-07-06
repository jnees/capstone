import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/*
  Login and registration forms are contained in this widget.
  
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSigningUp = false;

  void _setIsLoading() {
    // Toggles loading state.
    setState(() {
      _isLoading = !_isLoading;
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

      // Update the user's display name
      await credential.user!.updateDisplayName(_usernameController.text);

      return credential;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      _setIsLoading();
      return null;
    }
  }

  // Account Log In Handler
  Future<UserCredential?> _loginWithEmailAndPassword() async {
    _setIsLoading();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      _setIsLoading();
      return null;
    }
  }

  late ImageProvider texture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const Texture(),
            Center(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Logo()],
                  ),
                  if (_isSigningUp)
                    SizedBox(
                      height: 75,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (String? input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                          controller: _usernameController,
                          decoration: _textInputBoxDecoration("Username"),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 75,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: _textInputBoxDecoration("Email"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 75,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: _textInputBoxDecoration("Password"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 24),
                          primary: const Color(0xFFF5A986)),
                      onPressed: () async {
                        _isSigningUp
                            ? await _signUpWithEmailAndPassword()
                            : await _loginWithEmailAndPassword();

                        if (FirebaseAuth.instance.currentUser != null) {
                          // ignore: avoid_print
                          print(FirebaseAuth.instance.currentUser);
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(_isSigningUp ? 'Sign Up' : 'Log In'),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isSigningUp = !_isSigningUp;
                        });
                      },
                      child: _isSigningUp
                          ? const Text(
                              "Sign in with an existing account",
                              style: TextStyle(color: Colors.black),
                            )
                          : const Text("Register for an account",
                              style: TextStyle(color: Colors.black)))
                ]),
              ),
            )
          ],
        ));
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/JamSceneLogo.png',
      height: MediaQuery.of(context).size.height * .40,
    );
  }
}

class Texture extends StatelessWidget {
  const Texture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/JamSceneTexture.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}

InputDecoration _textInputBoxDecoration(label) {
  return InputDecoration(
    label: Text(label),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    fillColor: const Color.fromARGB(255, 248, 247, 247),
    filled: true,
  );
}
