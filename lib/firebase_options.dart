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
    apiKey: 'AIzaSyB2oIauTbtjMeBbY4S-ndzQ2v1jE1NeGM4',
    appId: '1:677367516525:web:1a462738210ecafe52de64',
    messagingSenderId: '677367516525',
    projectId: 'klimbat-launklim',
    authDomain: 'klimbat-launklim.firebaseapp.com',
    storageBucket: 'klimbat-launklim.appspot.com',
    measurementId: 'G-KNFJ7XH3DJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvyylzUaacRs1NatUO3l05DjZ71Xitt4s',
    appId: '1:677367516525:android:a88a19f7e25274f552de64',
    messagingSenderId: '677367516525',
    projectId: 'klimbat-launklim',
    storageBucket: 'klimbat-launklim.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9mgw7MrtauwPxv6bfSL02gXMjTYzsiLg',
    appId: '1:677367516525:ios:9475d165d1f8c78052de64',
    messagingSenderId: '677367516525',
    projectId: 'klimbat-launklim',
    storageBucket: 'klimbat-launklim.appspot.com',
    iosBundleId: 'com.example.klimbatLaunklim',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9mgw7MrtauwPxv6bfSL02gXMjTYzsiLg',
    appId: '1:677367516525:ios:9475d165d1f8c78052de64',
    messagingSenderId: '677367516525',
    projectId: 'klimbat-launklim',
    storageBucket: 'klimbat-launklim.appspot.com',
    iosBundleId: 'com.example.klimbatLaunklim',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2oIauTbtjMeBbY4S-ndzQ2v1jE1NeGM4',
    appId: '1:677367516525:web:3c1a8b742f03241152de64',
    messagingSenderId: '677367516525',
    projectId: 'klimbat-launklim',
    authDomain: 'klimbat-launklim.firebaseapp.com',
    storageBucket: 'klimbat-launklim.appspot.com',
    measurementId: 'G-KQQXZDQNMN',
  );
}
