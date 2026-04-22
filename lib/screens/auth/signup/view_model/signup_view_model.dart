import 'dart:async';
import 'dart:io';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/countries.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TextEditingController signupFirstName = TextEditingController();
  TextEditingController signupLastName = TextEditingController();
  TextEditingController signupEmail = TextEditingController();
  TextEditingController signupName = TextEditingController();
  TextEditingController signupPassword = TextEditingController();
  TextEditingController signupCPassword = TextEditingController();

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool signupValidator() {
    bool isValid = true;

    // Validate First Name
    if (signupFirstName.text.isEmpty) {
      firstNameError = "First name is required";
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(signupFirstName.text)) {
      firstNameError = LocaleKeys.nameCanOnlyContainAlphabets.tr();
      isValid = false;
    } else {
      firstNameError = null;
    }

    // Validate Last Name
    if (signupLastName.text.isEmpty) {
      lastNameError = "Last name is required";
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(signupLastName.text)) {
      firstNameError = LocaleKeys.nameCanOnlyContainAlphabets.tr();
      isValid = false;
    } else {
      lastNameError = null;
    }

    // Validate Password
    if (signupEmail.text.isEmpty) {
      emailError = "Email is required";
      isValid = false;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(signupEmail.text)) {
      emailError = "Enter a valid email";
    } else {
      emailError = null;
    }
    // Validate Password
    if (signupPassword.text.isEmpty) {
      passwordError = "Password is required";
      isValid = false;
    } else if (signupPassword.text.length < 8) {
      passwordError = "Password must be at least 6 characters long";
      isValid = false;
    } else {
      passwordError = null;
    }

    // Validate Confirm Password (Ensuring it matches Password)
    if (signupCPassword.text.isEmpty) {
      confirmPasswordError = "Confirm Password is required";
      isValid = false;
    } else if (signupCPassword.text != signupPassword.text) {
      confirmPasswordError = "Password not match";
      isValid = false;
    } else {
      confirmPasswordError = null;
    }

    notifyListeners();
    return isValid;
  }

  void clearFirstNamerror() {
    firstNameError = null;
    notifyListeners();
  }

  void clearLastNameError() {
    lastNameError = null;
    notifyListeners();
  }

  void clearEmailError() {
    emailError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    passwordError = null;
    notifyListeners();
  }

  void clearConfirmPasswordError() {
    confirmPasswordError = null;
    notifyListeners();
  }

  String _emailErrorText = '';
  String get emailErrorText => _emailErrorText;

  void updateEmailValidate(bool hasError, String errorText) {
    _emailErrorText = hasError ? errorText : '';
    notifyListeners();
  }

  Future<bool> checkEmailUsername({email, username}) async {
    try {
      final response = await sharedWebService.checkUsernameEmail(
          email: email, username: username);
      if (response.status == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  late Timer _timer;
  int _seconds = 0;
  int get seconds => _seconds;

  void startTimer() {
    _seconds = 60;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    // _timer.cancel();
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

  void resetTimer() {
    _timer.cancel();
    _startTimer();
    notifyListeners();
  }

  bool _isStayLoginValue = false;

  bool get isStayLoginValue => _isStayLoginValue;
  set isStayLoginValue(bool value) {
    _isStayLoginValue = value;
    notifyListeners();
  }

  String countryCode = "CA";
  String flagEmoji = '🇺🇸';
  String phoneCode = "+1";

  void addPhoneValue(
    String cCode,
    String pCode,
    String fEmoji,
  ) {
    countryCode = cCode;
    phoneCode = pCode;
    flagEmoji = fEmoji;
    notifyListeners();
  }

  void clearTextfeilds() {
    signupName.clear();
    signupEmail.clear();
    signupPassword.clear();
    signupCPassword.clear();
    notifyListeners();
  }

  Future<IBaseResponse> signup(BuildContext context) async {
    final firstName = signupFirstName.text;
    final lastName = signupLastName.text;
    final email = signupEmail.text;
    final password = signupPassword.text;
    final confirmPassword = signupCPassword.text;

    try {
      final response = await sharedWebService.signup(
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
      );

      print('response---- ${response.toString()}');
      if (response.status == 200 && response.user != null) {
        await SharedPreferenceHelper.instance().insertUser(response.user!);
      }
      return response;
    } catch (error) {
      print('error ---- ${error}');
      return StatusMessageResponse(
        status: '400',
        message: "Failed to sign up",
      );
    }
  }

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

int maxValidLength(String countryCode) {
  Map<String, dynamic>? selectedCountry = Countries.allCountries.first;

  if (selectedCountry['max_length'] != null) {
    return selectedCountry['max_length'] as int;
  } else {
    return 15;
  }
}
