// File generated from Firebase project configuration.
// Re-run FlutterFire configuration if Firebase app IDs or platforms change.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase is configured only for Android and iOS in this project.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase is configured only for Android and iOS in this project.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVU9mQTW8qNN94WAENqLYJHchzI-lwyA4',
    appId: '1:544772728837:android:9dedbae23c26ca8fa2d46c',
    messagingSenderId: '544772728837',
    projectId: 'vehicle-washing-application',
    storageBucket: 'vehicle-washing-application.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCM4eSQeE-uUtNORxl9RYH1JIF2QHrEg54',
    appId: '1:544772728837:ios:0466e254df1c2697a2d46c',
    messagingSenderId: '544772728837',
    projectId: 'vehicle-washing-application',
    storageBucket: 'vehicle-washing-application.firebasestorage.app',
    iosBundleId: 'com.kauwatech.vwa',
  );
}
