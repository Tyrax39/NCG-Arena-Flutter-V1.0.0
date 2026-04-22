import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final SharedWebService sharedWebService = SharedWebService.instance();

  String? newPasswordError;
  String? confirmPasswordError;
  bool newPasswordValidator() {
    bool isValid = true;

    // Validate New Password
    if (newPasswordController.text.isEmpty) {
      newPasswordError = "New Password is required";
      isValid = false;
    } else {
      newPasswordError = null;
    }

    // Validate Confirm Password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError = "Confirm Password is required";
      isValid = false;
    } else if (confirmPasswordController.text != newPasswordController.text) {
      confirmPasswordError = "Passwords do not match";
      isValid = false;
    } else {
      confirmPasswordError = null;
    }

    notifyListeners();
    return isValid;
  }

  void clearNewPasswordError() {
    newPasswordError = null;
    notifyListeners();
  }

  void clearConfirmPasswordError() {
    confirmPasswordError = null;
    notifyListeners();
  }

  Future<IBaseResponse> createNewPasswordApi(String email) async {
    try {
      final response = await sharedWebService.createNewPassword(
        email: email,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
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
}
