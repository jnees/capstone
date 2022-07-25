import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jam_scene/screens/profile_builder.dart';
import 'package:jam_scene/styles.dart';
import 'firebase_options.dart';
import 'components/authentication_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final routes = {
    AuthenticationWrapper.routeName: (context) => const AuthenticationWrapper(),
    ProfileBuilder.routeName: (context) => const ProfileBuilder()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AuthenticationWrapper.routeName,
      title: 'JamScene',
      routes: routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Styles.charcoal,
          secondary: Styles.salmonJam
        )
      ),
    );
  }
}
