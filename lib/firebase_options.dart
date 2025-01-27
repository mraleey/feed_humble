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
        return windows;
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
    apiKey: 'AIzaSyCHELzYh-vf_vEDHBvbrVVBWq94tXN8Yx0',
    appId: '1:991126093083:web:91baaa29e9d612a45ba7be',
    messagingSenderId: '991126093083',
    projectId: 'feedhumble-ccae5',
    authDomain: 'feedhumble-ccae5.firebaseapp.com',
    storageBucket: 'feedhumble-ccae5.appspot.com',
    measurementId: 'G-WRLZS9L2JQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDATsvO1FdWsPiUCEIFM1BNB5qyQj4jodk',
    appId: '1:991126093083:android:c1782988707145e55ba7be',
    messagingSenderId: '991126093083',
    projectId: 'feedhumble-ccae5',
    storageBucket: 'feedhumble-ccae5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_w1m6qRIRfBKW8BlEVvnzoKh20e3uOmg',
    appId: '1:991126093083:ios:a20e68af710c033d5ba7be',
    messagingSenderId: '991126093083',
    projectId: 'feedhumble-ccae5',
    storageBucket: 'feedhumble-ccae5.appspot.com',
    iosClientId: '991126093083-nf8voblshci7tq3mtn71u6v8m5ga15vl.apps.googleusercontent.com',
    iosBundleId: 'com.example.getxConstants',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_w1m6qRIRfBKW8BlEVvnzoKh20e3uOmg',
    appId: '1:991126093083:ios:a20e68af710c033d5ba7be',
    messagingSenderId: '991126093083',
    projectId: 'feedhumble-ccae5',
    storageBucket: 'feedhumble-ccae5.appspot.com',
    iosClientId: '991126093083-nf8voblshci7tq3mtn71u6v8m5ga15vl.apps.googleusercontent.com',
    iosBundleId: 'com.example.getxConstants',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCHELzYh-vf_vEDHBvbrVVBWq94tXN8Yx0',
    appId: '1:991126093083:web:485de460b9c4def15ba7be',
    messagingSenderId: '991126093083',
    projectId: 'feedhumble-ccae5',
    authDomain: 'feedhumble-ccae5.firebaseapp.com',
    storageBucket: 'feedhumble-ccae5.appspot.com',
    measurementId: 'G-7HX98K1E52',
  );
}
