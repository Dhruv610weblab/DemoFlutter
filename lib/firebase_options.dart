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
    apiKey: 'AIzaSyBNKIHxtu-Qf72L-74x8r3J7EB__aVadPQ',
    appId: '1:1036689460058:web:631c92043ce6cac4d38163',
    messagingSenderId: '1036689460058',
    projectId: 'fir-video-64242',
    authDomain: 'fir-video-64242.firebaseapp.com',
    storageBucket: 'fir-video-64242.appspot.com',
    measurementId: 'G-S2LYM04X26',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPHPWKcsRELyInT7c0yT2gNm36dmf_lYw',
    appId: '1:1036689460058:android:3616949f65bcf51ad38163',
    messagingSenderId: '1036689460058',
    projectId: 'fir-video-64242',
    storageBucket: 'fir-video-64242.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMPmzD2hvh-sL-EryGECSaXE0wC-T65jU',
    appId: '1:1036689460058:ios:4ec0c4ef16f98194d38163',
    messagingSenderId: '1036689460058',
    projectId: 'fir-video-64242',
    storageBucket: 'fir-video-64242.appspot.com',
    iosClientId: '1036689460058-r6iheciu63t0hvk6if0n7gpgog50or96.apps.googleusercontent.com',
    iosBundleId: 'com.example.videokit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMPmzD2hvh-sL-EryGECSaXE0wC-T65jU',
    appId: '1:1036689460058:ios:4ec0c4ef16f98194d38163',
    messagingSenderId: '1036689460058',
    projectId: 'fir-video-64242',
    storageBucket: 'fir-video-64242.appspot.com',
    iosClientId: '1036689460058-r6iheciu63t0hvk6if0n7gpgog50or96.apps.googleusercontent.com',
    iosBundleId: 'com.example.videokit',
  );
}