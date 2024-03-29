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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB4vGx83iR6ugGpPpKxfh1l5vRttYjJ6WI',
    appId: '1:782025733647:web:f725bc3eba3b3f8bad557a',
    messagingSenderId: '782025733647',
    projectId: 'familyshare-b1d47',
    authDomain: 'familyshare-b1d47.firebaseapp.com',
    storageBucket: 'familyshare-b1d47.appspot.com',
    measurementId: 'G-1V875CDGDR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBESxQR_Yw0xEcGZblB_oeVc0G068eseUA',
    appId: '1:782025733647:android:ba42bf0204997a21ad557a',
    messagingSenderId: '782025733647',
    projectId: 'familyshare-b1d47',
    storageBucket: 'familyshare-b1d47.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBl5pOtNlH7BwYAkh33xDkEior8frBdWpk',
    appId: '1:782025733647:ios:217fac8df0b81a8ead557a',
    messagingSenderId: '782025733647',
    projectId: 'familyshare-b1d47',
    storageBucket: 'familyshare-b1d47.appspot.com',
    iosClientId: '782025733647-l4ppqrt3d6nfoegfdgvke2k88jhfm7eb.apps.googleusercontent.com',
    iosBundleId: 'com.example.familyshare',
  );
}
