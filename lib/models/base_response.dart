class IBaseResponse {
  final int status;
  final String message;
  final LoginResult? result;  // or whatever you named your result class

  IBaseResponse({
    required this.status,
    required this.message,
    this.result,
  });
}

class LoginResult {
  final String? emailVerifiedAt;
  final int isProfileComplete;
  // ... other fields

  LoginResult({
    this.emailVerifiedAt,
    required this.isProfileComplete,
    // ... other fields
  });
} 