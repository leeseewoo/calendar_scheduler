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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHfP5Z0-XXYNWtkAZNWr1fCTCBpx3i6UA',
    appId: '1:776173185408:android:11cffc07f88dc41fb07965',
    messagingSenderId: '776173185408',
    projectId: 'my-project-449b5',
    databaseURL: 'https://my-project-449b5-default-rtdb.firebaseio.com',
    storageBucket: 'my-project-449b5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_m7uqsoY8ceRk6EQy9hChHoxh_yKFhnk',
    appId: '1:776173185408:ios:5bcafa53174a90f4b07965',
    messagingSenderId: '776173185408',
    projectId: 'my-project-449b5',
    databaseURL: 'https://my-project-449b5-default-rtdb.firebaseio.com',
    storageBucket: 'my-project-449b5.appspot.com',
    iosBundleId: 'com.flysonitstime.calendarScheduler',
  );
}
