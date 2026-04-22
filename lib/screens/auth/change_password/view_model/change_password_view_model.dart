import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/material.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final SharedWebService sharedWebService = SharedWebService.instance();

  String _errorText = '';
  bool _passwordError = false;
  bool _newPasswordError = false;
  bool _confirmPasswordError = false;
  bool _isPasswordShow = false;
  bool _isNewPasswordShow = false;
  bool _isConfirmPasswordShow = false;
  bool _isLoading = false;

  // Getters
  String get errorText => _errorText;
  bool get passwordError => _passwordError;
  bool get newPasswordError => _newPasswordError;
  bool get confirmPasswordError => _confirmPasswordError;
  bool get isPasswordShow => _isPasswordShow;
  bool get isNewPasswordShow => _isNewPasswordShow;
  bool get isConfirmPasswordShow => _isConfirmPasswordShow;
  bool get isLoading => _isLoading;

  void updateErrorText(String error) {
    _errorText = error;
    notifyListeners();
  }

  void updateCurrentPasswordError(bool value, String errorText) {
    _passwordError = value;
    _errorText = errorText;
    notifyListeners();
  }

  void updateNewPasswordError(bool value, String errorText) {
    _newPasswordError = value;
    _errorText = errorText;
    notifyListeners();
  }

  void updateConfirmPasswordError(bool value, String errorText) {
    _confirmPasswordError = value;
    _errorText = errorText;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordShow = !_isPasswordShow;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordShow = !_isNewPasswordShow;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordShow = !_isConfirmPasswordShow;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    // Reset error states
    _passwordError = false;
    _newPasswordError = false;
    _confirmPasswordError = false;
    _errorText = '';

    notifyListeners();
  }

  Future<StatusMessageResponse> changePassword(BuildContext context) async {
    final String oldPassword = currentPasswordController.text;
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;
    try {
      final response = await sharedWebService.changePassword(
        oldPassword: oldPassword,
        password: newPassword,
        newConfirmPassword: confirmPassword,
      );
      return response;
    } catch (e) {
      updateErrorText('Failed to change password. Please try again.');
      return StatusMessageResponse(
          status: 400, message: 'Failed to change password. Please try again.');
    }
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
