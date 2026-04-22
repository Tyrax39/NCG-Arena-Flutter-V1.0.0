import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class ContactUsViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  SharedWebService sharedWebService = SharedWebService.instance();

  String? nameError;
  String? emailError;
  String? messageError;

  bool contactValidator() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      nameError = "Name is required";
      isValid = false;
    } else {
      nameError = null;
    }

    if (emailController.text.isEmpty) {
      emailError = "Email is required";
      isValid = false;
    } else {
      emailError = null;
    }

    if (messageController.text.isEmpty) {
      messageError = "Message is required";
      isValid = false;
    } else {
      messageError = null;
    }

    notifyListeners();
    return isValid;
  }

  Future<IBaseResponse> contactUs({
    required String name,
    required String email,
    required String message,
  }) async {
    final previousUser = await sharedPreferenceHelper.user;
    if (previousUser != null) {
      try {
        final response = await sharedWebService.contactUsApi(
            previousUser.id.toString(), name, message, email);
        return response;
      } catch (e, stackTrace) {
        debugPrint('Error sending contact information: $e\n$stackTrace');
        return StatusMessageResponse(
            status: 400, message: 'Error sending contact information');
      }
    }
    return StatusMessageResponse(
        status: 400, message: 'Error sending contact information');
  }
}
