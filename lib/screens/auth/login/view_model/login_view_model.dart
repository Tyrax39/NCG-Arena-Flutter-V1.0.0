import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/constant/app_environment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  String? emailError;
  String? passwordError;
  bool loginValidator() {
    bool isValid = true;

    // Validate New Password
    if (loginEmail.text.isEmpty) {
      emailError = "Email is required";
      isValid = false;
    } else {
      emailError = null;
    }

    // Validate New Password
    if (loginPassword.text.isEmpty) {
      passwordError = "Password is required";
      isValid = false;
    } else {
      passwordError = null;
    }

    notifyListeners();
    return isValid;
  }

  void clearEmailError() {
    emailError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    passwordError = null;
    notifyListeners();
  }

  void clearTextFields() {
    loginEmail.clear();
    loginPassword.clear();
    notifyListeners();
  }

  Future<LoginAuthenticationResponse> login() async {
    final String email = loginEmail.text;
    final String password = loginPassword.text;
    String deviceType = Platform.isAndroid ? "Android" : "iOS";
    String? deviceId = await _firebaseMessaging.getToken();
    deviceId ??= "";
    try {
      final response = await sharedWebService.login(
        email: email,
        password: password,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      debugPrint('device id---------------------$deviceId');
      return response;
    } on SocketException catch (error) {
      debugPrint(error.toString());
      return LoginAuthenticationResponse(
        null,
        400,
        'Cannot reach the local API server at ${AppEnvironment.apiBaseUrl}. Start Apache and MySQL in XAMPP, then try again.',
      );
    } on TimeoutException catch (error) {
      debugPrint(error.toString());
      return LoginAuthenticationResponse(
        null,
        400,
        'The API server timed out while logging in. Please try again in a moment.',
      );
    } on ClientException catch (error) {
      debugPrint(error.toString());
      return LoginAuthenticationResponse(
        null,
        400,
        'Login failed because the app could not reach ${AppEnvironment.apiBaseUrl}.',
      );
    } on FormatException catch (error) {
      debugPrint(error.toString());
      return LoginAuthenticationResponse(
        null,
        400,
        error.message.toString(),
      );
    } catch (error) {
      debugPrint(error.toString());
      return LoginAuthenticationResponse(null, 400, error.toString());
    }
  }

  Future<LoginAuthenticationResponse> socialLogin(token, provider) async {
    try {
      final response =
          await sharedWebService.socialLogin(token: token, provider: provider);
      debugPrint('response-----------$response');
      if (response.status == 200 && response.user != null) {
        await SharedPreferenceHelper.instance().insertUser(response.user!);
      }
      return response;
    } catch (error) {
      log(error.toString());
      return LoginAuthenticationResponse(null, 400, "Something went wrong");
    }
  }

  Future<LoginAuthenticationResponse> appleLogin(email, name) async {
    try {
      final response =
          await sharedWebService.appleLogin(email: email, name: name);
      if (response.status == 200 && response.user != null) {
        await SharedPreferenceHelper.instance().insertUser(response.user!);
      }
      return response;
    } catch (error) {
      // Handle the error as needed
      log(error.toString());
      return LoginAuthenticationResponse(null, 400, "Something went wrong");
    }
  }

  Future<LoginAuthenticationResponse> firebaseLogin({
    required String email,
    required String firebaseUid,
    required String idToken,
    String name = '',
  }) async {
    String deviceType = Platform.isAndroid ? "Android" : "iOS";
    String? deviceId = await _firebaseMessaging.getToken();
    deviceId ??= "";

    try {
      final response = await sharedWebService.firebaseLogin(
        email: email,
        firebaseUid: firebaseUid,
        idToken: idToken,
        name: name,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      if (response.status == 200 && response.user != null) {
        await SharedPreferenceHelper.instance().insertUser(response.user!);
      }
      return response;
    } catch (error) {
      log(error.toString());
      return LoginAuthenticationResponse(null, 400, "Something went wrong");
    }
  }
}

class LoginResponse {
  final int status;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  // Add fromJson factory constructor if needed
}

class LoginData {
  final String? emailVerifiedAt;
  final int isProfileComplete;
  // ... other user data fields

  LoginData({
    this.emailVerifiedAt,
    required this.isProfileComplete,
    // ... other fields
  });

  // Add fromJson factory constructor if needed
}
