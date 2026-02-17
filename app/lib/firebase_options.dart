// E2E test fixture — dummy Firebase options for web testing.
// This file should be replaced with real config from `flutterfire configure`.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show kIsWeb, TargetPlatform, defaultTargetPlatform;

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
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummy_test_key_for_e2e',
    appId: '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'gaijin-life-navi',
    authDomain: 'gaijin-life-navi.firebaseapp.com',
    storageBucket: 'gaijin-life-navi.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummy_test_key_for_e2e',
    appId: '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'gaijin-life-navi',
    storageBucket: 'gaijin-life-navi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummy_test_key_for_e2e',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'gaijin-life-navi',
    storageBucket: 'gaijin-life-navi.appspot.com',
    iosBundleId: 'com.example.gaijinLifeNavi',
  );
}
