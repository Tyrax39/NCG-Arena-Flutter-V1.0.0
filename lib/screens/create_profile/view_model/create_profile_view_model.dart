import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CreateProfileViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  TextEditingController username = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  // Error Variables
  String? usernameError;
  String? roleError;
  String? genderError;
  String? dobError;
  String? phoneError;
  String? imageError;

  // Validator for Create Profile
  bool profileValidator() {
    bool isValid = true;

    // Username Validation
    if (username.text.isEmpty) {
      usernameError = "Username is required";
      isValid = false;
    } else if (username.text.length < 3) {
      usernameError = "Username must be at least 3 characters";
      isValid = false;
    } else {
      usernameError = null;
    }

    // Role Validation
    if (selectedRoleId == null) {
      roleError = "Please select a role";
      isValid = false;
    } else {
      roleError = null;
    }

    // Gender Validation
    if (selectedGender == "Select Gender") {
      genderError = "Please select a gender";
      isValid = false;
    } else {
      genderError = null;
    }

    // Date of Birth Validation
    if (ageController.text.isEmpty) {
      dobError = "Please select your date of birth";
      isValid = false;
    } else {
      dobError = null;
    }

    // Phone Validation
    if (phoneController.text.isEmpty) {
      phoneError = "Phone number is required";
      isValid = false;
    } else if (!RegExp(r'^\d{7,15}$').hasMatch(phoneController.text)) {
      phoneError = "Enter a valid phone number";
      isValid = false;
    } else {
      phoneError = null;
    }

    // Image Validation
    if (imagePath.isEmpty) {
      imageError = "Please select a profile image";
      isValid = false;
    } else {
      imageError = null;
    }

    notifyListeners();
    return isValid;
  }



  void clearImageError() {
    imageError = null;
    notifyListeners();
  }

  void clearRoleError() {
    roleError = null;
    notifyListeners();
  }

  void clearUsernameError() {
    usernameError = null;
    notifyListeners();
  }

  void clearPhoneError() {
    phoneError = null;
    notifyListeners();
  }

  void clearGenderError() {
    genderError = null;
    notifyListeners();
  }

  void clearDobError() {
    dobError = null;
    notifyListeners();
  }

  String _imagePath = "";
  String get imagePath => _imagePath;
  set imagePathSet(String value) {
    _imagePath = value;
  }

  void newImagePath(String pickedImagePath) {
    imagePathSet = pickedImagePath;
    notifyListeners();
  }

  Map<String, int> roleName = {
    'Streamer': 1,
    'Caster (Commentator)': 2,
    'Tournament Organizer': 3,
    'Tournament Moderator': 4,
    'Content Creator': 5,
    'Influencer': 6,
    'Player': 7,
    'Coach': 8,
  };

  int? selectedRoleId;

  void setSelectedRole(String role) {
    selectedRoleId = roleName[role];
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

  void onSelectAgeExpiry(DateTime value) {
    // Display date in "Dec 10, 2022" format on UI
    ageController.text = DateFormat("MMM dd, yyyy").format(value).toUpperCase();
    print(DateFormat("MMM dd, yyyy").format(value).toUpperCase());
    // Store the selected date for backend in a different variable
    ageController.text = DateFormat("yyyy-MM-dd").format(value);
  }

  List<String> selectGender = [
    'Male',
    'Female',
  ];
  String selectedGender = 'Select Gender';

  void setSelectedGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  String _usernameErrorText = '';
  String get usernameErrorText => _usernameErrorText;

  void updateEmailValidate(bool hasError, String errorText) {
    usernameError = hasError ? errorText : '';
    notifyListeners();
  }

  Future<void> validateUsername(String value) async {
    if (value.isEmpty) {
      updateEmailValidate(true, 'Username is required');
      return;
    }

    if (!isValidUsername(value)) {
      updateEmailValidate(true,
          'Username must be 3-20 characters and can only contain letters, numbers and underscore');
      return;
    }

    // if (value != userData?.username) {
      // Only check if username changed
      bool isAvailable = await checkUsername(username: value);
      if (!isAvailable) {
        updateEmailValidate(true, 'This username is already taken');
      } else {
        updateEmailValidate(false, '');
      }
    // } else {
    //   updateEmailValidate(false, '');
    // }
  }
  bool isValidUsername(String username) {
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }

  Future<bool> checkUsername({email, username}) async {
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

  Future<IBaseResponse> createProfile(BuildContext context) async {
    try {
      final response = await sharedWebService.updateProfile(
        username: username.text.toString(),
        userType: selectedRoleId!.toString(),
        dob: ageController.text.toString(),
        phone: phoneController.text.toString(),
        gender: selectedGender,
        image: imagePath,
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
}
