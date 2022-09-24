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
    apiKey: 'AIzaSyCUMpD0BIMmKm0MBHn-8RtY6-dh6uWdt-o',
    appId: '1:404772091775:web:dc0aff4a658090e5be4c4a',
    messagingSenderId: '404772091775',
    projectId: 'map-box-92438',
    authDomain: 'map-box-92438.firebaseapp.com',
    storageBucket: 'map-box-92438.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJUV74r3q0C2t5pO3xCgHX1Cz-GMbaETQ',
    appId: '1:404772091775:android:1a150a1e6f63950fbe4c4a',
    messagingSenderId: '404772091775',
    projectId: 'map-box-92438',
    storageBucket: 'map-box-92438.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGhbRNxG68UW4l0Opvo9nWCtc_QMkvUYc',
    appId: '1:404772091775:ios:25c07eb4b1114202be4c4a',
    messagingSenderId: '404772091775',
    projectId: 'map-box-92438',
    storageBucket: 'map-box-92438.appspot.com',
    iosClientId: '404772091775-5ltmiesrhohsk3uinq4m19ovv80ueear.apps.googleusercontent.com',
    iosBundleId: 'com.example.mapboxNavigation',
  );
}