import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthHelper {
  GoogleAuthHelper._();

  static Future<void>? _initialization;

  static Future<void> initialize() {
    return _initialization ??= GoogleSignIn.instance.initialize();
  }

  static Future<GoogleSignInAccount?> authenticate() async {
    await initialize();

    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      return null;
    }

    try {
      return await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (error) {
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
        case GoogleSignInExceptionCode.uiUnavailable:
          return null;
        case GoogleSignInExceptionCode.clientConfigurationError:
        case GoogleSignInExceptionCode.providerConfigurationError:
        case GoogleSignInExceptionCode.userMismatch:
        case GoogleSignInExceptionCode.unknownError:
          rethrow;
      }
    }
  }

  static Future<void> signOut() async {
    await initialize();
    await GoogleSignIn.instance.signOut();
  }
}
