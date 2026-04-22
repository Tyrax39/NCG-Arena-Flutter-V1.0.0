import 'dart:async';
import 'dart:io';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SelectionViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<LoginAuthenticationResponse> socialLogin(token, provider) async {
    try {
      final response =
          await sharedWebService.socialLogin(token: token, provider: provider);
      if (response.status == 200 && response.user != null) {
        await SharedPreferenceHelper.instance().insertUser(response.user!);
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
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
      debugPrint(error.toString());
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
      debugPrint(error.toString());
      return LoginAuthenticationResponse(null, 400, "Something went wrong");
    }
  }
}
