// File generated to provide Firebase configuration for web platform
// This file should be generated using: flutterfire configure
// For now, using manual configuration based on google-services.json

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCjM3ECahBp40_ZHLln2ofvOjZF8_8yu8o',
    appId: '1:349120585515:web:default',
    messagingSenderId: '349120585515',
    projectId: 'restaurant-app-1771020358',
    authDomain: 'restaurant-app-1771020358.firebaseapp.com',
    storageBucket: 'restaurant-app-1771020358.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjM3ECahBp40_ZHLln2ofvOjZF8_8yu8o',
    appId: '1:349120585515:android:e5bea03576614570cd6f6e',
    messagingSenderId: '349120585515',
    projectId: 'restaurant-app-1771020358',
    storageBucket: 'restaurant-app-1771020358.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjM3ECahBp40_ZHLln2ofvOjZF8_8yu8o',
    appId: '1:349120585515:ios:default',
    messagingSenderId: '349120585515',
    projectId: 'restaurant-app-1771020358',
    storageBucket: 'restaurant-app-1771020358.firebasestorage.app',
    iosBundleId: 'com.example.app1771020358',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCjM3ECahBp40_ZHLln2ofvOjZF8_8yu8o',
    appId: '1:349120585515:macos:default',
    messagingSenderId: '349120585515',
    projectId: 'restaurant-app-1771020358',
    storageBucket: 'restaurant-app-1771020358.firebasestorage.app',
    iosBundleId: 'com.example.app1771020358',
  );
}
