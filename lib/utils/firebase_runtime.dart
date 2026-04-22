import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseRuntime {
  FirebaseRuntime._();

  static bool _isInitialized = false;
  static Object? _lastError;

  static bool get isInitialized => _isInitialized;

  static String get socialAuthUnavailableMessage {
    if (kDebugMode && _lastError != null) {
      return 'Social login is unavailable: $_lastError';
    }

    return 'Social login is temporarily unavailable on this build.';
  }

  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await Firebase.initializeApp();
      _isInitialized = true;
      _lastError = null;
    } catch (error, stackTrace) {
      _isInitialized = false;
      _lastError = error;
      debugPrint('Firebase initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> initializeBackground() async {
    if (_isInitialized) {
      return;
    }

    try {
      await Firebase.initializeApp();
      _isInitialized = true;
    } catch (error, stackTrace) {
      debugPrint('Firebase background initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}