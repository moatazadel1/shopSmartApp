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
    apiKey: 'AIzaSyDppbRnKqwLmPCRGfR_UARKlPY2RpGVcbI',
    appId: '1:658847833241:web:ba47a0272d426172d62c08',
    messagingSenderId: '658847833241',
    projectId: 'smart-shoppe-f5bed',
    authDomain: 'smart-shoppe-f5bed.firebaseapp.com',
    storageBucket: 'smart-shoppe-f5bed.appspot.com',
    measurementId: 'G-E6V5K25E0V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeYETFwZolw4-pycyFFQFT8Cqp_dhCWHQ',
    appId: '1:658847833241:android:e0779a49f287acabd62c08',
    messagingSenderId: '658847833241',
    projectId: 'smart-shoppe-f5bed',
    storageBucket: 'smart-shoppe-f5bed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcJdzqPBOOmF64IyQD48n-U9KCApV-ZVk',
    appId: '1:658847833241:ios:a808464daba4f8a3d62c08',
    messagingSenderId: '658847833241',
    projectId: 'smart-shoppe-f5bed',
    storageBucket: 'smart-shoppe-f5bed.appspot.com',
    androidClientId: '658847833241-2cr1aorjudvlno70b3k4mjq2ijpg3u13.apps.googleusercontent.com',
    iosClientId: '658847833241-mvhtuegr6kqnenebjt3ri84ah454qt23.apps.googleusercontent.com',
    iosBundleId: 'com.example.adminPanel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCcJdzqPBOOmF64IyQD48n-U9KCApV-ZVk',
    appId: '1:658847833241:ios:230f23395323157dd62c08',
    messagingSenderId: '658847833241',
    projectId: 'smart-shoppe-f5bed',
    storageBucket: 'smart-shoppe-f5bed.appspot.com',
    androidClientId: '658847833241-2cr1aorjudvlno70b3k4mjq2ijpg3u13.apps.googleusercontent.com',
    iosClientId: '658847833241-b1f4dpu1n2gvvb3euevd0vctsbcdaiv2.apps.googleusercontent.com',
    iosBundleId: 'com.example.adminPanel.RunnerTests',
  );
}
