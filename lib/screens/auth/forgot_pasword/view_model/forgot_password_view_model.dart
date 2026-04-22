import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  final TextEditingController emailController = TextEditingController();

  String? emailError;
  bool emailValidator() {
    bool isValid = true;

    // Validate New Password
    if (emailController.text.isEmpty) {
      emailError = "Email is required";
      isValid = false;
    } else {
      emailError = null;
    }

    notifyListeners();
    return isValid;
  }

  void clearEmailError() {
    emailError = null;
    notifyListeners();
  }

  Future<StatusMessageResponse> forgotPassword() async {
    final String email = emailController.text.trim();

    try {
      final response = await sharedWebService.forgotPassword(
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

  void clearTextField() {
    emailController.clear();
    notifyListeners();
  }
}
