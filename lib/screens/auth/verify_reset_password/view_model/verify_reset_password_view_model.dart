import 'dart:async';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/utils/countries.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/material.dart';

class VerifyResetPasswordViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  TextEditingController resetOtpController = TextEditingController();

  late Timer _timer;
  int _seconds = 60;
  int get seconds => _seconds;

  void startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        notifyListeners();
      } else {
        _seconds--;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  void resetTimer() {
    _timer.cancel();
    startTimer();
    notifyListeners();
  }

  Future<IBaseResponse> resetOtpVerifyApi(String email) async {
    try {
      final response = await sharedWebService.resetOtpVerify(
        email: email,
        otp: resetOtpController.text,
      );
      print('response in reset email---- ${response.toString()}');
      return response;
    } catch (error) {
      print('error -- ${error}');
      return StatusMessageResponse(
        status: '400',
        message: "Failed to sign up",
      );
    }
  }

  Future<StatusMessageResponse> resendOtp(String email) async {
    try {
      final response = await sharedWebService.resendOtp(
        email: email,
      );
      print('reponse in view model -------------$response');
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return StatusMessageResponse(
        status: 400,
        message: "Something went wrong",
      );
    }
  }
}
