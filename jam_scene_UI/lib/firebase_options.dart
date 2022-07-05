// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAL0e6x82vvsxgnHowYuZnGG8ixDswlDeA',
    appId: '1:996660872089:web:7aa74e06ed952f44228908',
    messagingSenderId: '996660872089',
    projectId: 'jamscene-410d6',
    authDomain: 'jamscene-410d6.firebaseapp.com',
    storageBucket: 'jamscene-410d6.appspot.com',
    measurementId: 'G-7F9SC6K9XC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBogwQmBNpn_YB2hPpMXb-rY564jcJJlL4',
    appId: '1:996660872089:android:114c42f5b3132bf2228908',
    messagingSenderId: '996660872089',
    projectId: 'jamscene-410d6',
    storageBucket: 'jamscene-410d6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDc1mU37wFRSU1lO9D31RxwbQ4nl3Em2G4',
    appId: '1:996660872089:ios:c0ee9bd470476ce9228908',
    messagingSenderId: '996660872089',
    projectId: 'jamscene-410d6',
    storageBucket: 'jamscene-410d6.appspot.com',
    iosClientId: '996660872089-iutmileiirbuorno23ehfh99g0h9gevg.apps.googleusercontent.com',
    iosBundleId: 'com.example.jamScene',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDc1mU37wFRSU1lO9D31RxwbQ4nl3Em2G4',
    appId: '1:996660872089:ios:c0ee9bd470476ce9228908',
    messagingSenderId: '996660872089',
    projectId: 'jamscene-410d6',
    storageBucket: 'jamscene-410d6.appspot.com',
    iosClientId: '996660872089-iutmileiirbuorno23ehfh99g0h9gevg.apps.googleusercontent.com',
    iosBundleId: 'com.example.jamScene',
  );
}