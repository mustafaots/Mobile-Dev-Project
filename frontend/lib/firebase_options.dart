import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for macOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtFdxI211rEpFr9T6LeDPT9E4Cpu5dH_U',
    appId: '1:497504338938:android:99c5b1b51d77c3ba331a43',
    messagingSenderId: '497504338938',
    projectId: 'easy-vacation-57f9f',
    storageBucket: 'easy-vacation-57f9f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtFdxI211rEpFr9T6LeDPT9E4Cpu5dH_U',
    appId: '1:497504338938:ios:99c5b1b51d77c3ba331a43',
    messagingSenderId: '497504338938',
    projectId: 'easy-vacation-57f9f',
    storageBucket: 'easy-vacation-57f9f.firebasestorage.app',
    iosBundleId: 'com.easyvacation.app',
  );
}