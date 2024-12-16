// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBfIEM4YjCWYiqFxX_kmEgnZ8dQGdekDRs',
    appId: '1:349182635614:web:611cddb4be89b620a78ecf',
    messagingSenderId: '349182635614',
    projectId: 'new-bookie',
    authDomain: 'new-bookie.firebaseapp.com',
    storageBucket: 'new-bookie.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTWqSX3thBdJ9eacrhJ8ctkzPVW8WVpnY',
    appId: '1:349182635614:android:d4e882d24db1c974a78ecf',
    messagingSenderId: '349182635614',
    projectId: 'new-bookie',
    storageBucket: 'new-bookie.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDmo-oE5x5n_GI9-H_n2Wjm1uefW1Smdd4',
    appId: '1:349182635614:ios:672e0e00572e9ca4a78ecf',
    messagingSenderId: '349182635614',
    projectId: 'new-bookie',
    storageBucket: 'new-bookie.firebasestorage.app',
    androidClientId: '349182635614-nd7cp9avs85atd5anbffig3oaukaqs3i.apps.googleusercontent.com',
    iosClientId: '349182635614-1nh6ql5k120qtcdejot6eoumsb46fd36.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterBaseApp',
  );

}