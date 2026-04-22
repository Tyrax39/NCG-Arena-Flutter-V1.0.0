import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class EditProfileViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  TextEditingController username = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController ageDisplayController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController twitchController = TextEditingController();
  TextEditingController discordController = TextEditingController();
  TextEditingController usertypeController = TextEditingController();

  String _imageLogoPath = "";
  String profile_image = "";
  String cover_image = "";

  String get imageLogoPath => _imageLogoPath;
  set imageLogoPathSet(String value) {
    _imageLogoPath = value;
  }

  void newImageLogoPath(String pickedImagePath) {
    imageLogoPathSet = pickedImagePath;
    notifyListeners();
  }

  String _headerImagePath = "";
  String get headerImagePath => _headerImagePath;
  set imageHeaderPathSet(String value) {
    _headerImagePath = value;
  }

  void newImageHeaderPath(String pickedImagePath) {
    imageHeaderPathSet = pickedImagePath;
    notifyListeners();
  }

  Map<int, String> userRoles = {
    1: 'Streamer',
    2: 'Caster (Commentator)',
    3: 'Tournament Organiser',
    4: 'Tournament Moderator',
    5: 'Content creator',
    6: 'Influencer',
    7: 'Player',
    8: 'Coach',
  };

  Set<int> selectedUserRoles = {};

  void updateSelectedRoles(Set<int> roles) {
    selectedUserRoles = roles;
    usertypeController.text =
        roles.map((roleId) => userRoles[roleId] ?? '').join(', ');
    notifyListeners();
  }

  // int? selectedRoleId;
  //
  // void setSelectedRole(String role) {
  //   selectedRoleId = roleName[role];
  //   notifyListeners();
  // }

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
    // Set user-friendly display format for UI
    ageDisplayController.text =
        DateFormat("MMM dd, yyyy").format(value).toUpperCase();

    // Store ISO format for backend and date picker
    ageController.text = DateFormat("yyyy-MM-dd").format(value);

    // Notify listeners to update UI
    notifyListeners();
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
    _usernameErrorText = hasError ? errorText : '';
    notifyListeners();
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

  UserDataModel? userData;

  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    print('user------ ❌❌❌❌❌❌❌${user!.userType}');
    print('user------ ❌❌❌❌❌❌❌${user.dateOfBirth}');
    firstNameController.text = user.firstName ?? "";
    lastNameController.text = user.lastName ?? "";
    emailController.text = user.email ?? "";
    aboutController.text = user.about ?? "";
    selectedGender = user.gender ?? "";

    // Format date of birth if exists
    if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
      try {
        // Keep as ISO format for parsing later
        ageController.text = user.dateOfBirth!;

        // Set the display format
        DateTime dob = DateTime.parse(user.dateOfBirth!);
        ageDisplayController.text =
            DateFormat("MMM dd, yyyy").format(dob).toUpperCase();
      } catch (e) {
        ageController.text = "";
        ageDisplayController.text = "";
      }
    } else {
      ageController.text = "";
      ageDisplayController.text = "";
    }

    username.text = user.username ?? "";
    profile_image = user.profileImage ?? "";
    cover_image = user.cover ?? "";
    selectedUserRoles.clear(); // Clear previous roles
    if (user.userType != null) {
      var roles = user.userType!.split(',');
      for (var role in roles) {
        int roleId = int.tryParse(role.trim()) ?? -1;
        if (roleId != -1 && userRoles.containsKey(roleId)) {
          selectedUserRoles.add(roleId);
        }
      }
    }
    notifyListeners();
  }

  // Validate username format
  bool isValidUsername(String username) {
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }

  // Improved username check
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

    if (value != userData?.username) {
      // Only check if username changed
      bool isAvailable = await checkUsername(username: value);
      if (!isAvailable) {
        updateEmailValidate(true, 'This username is already taken');
      } else {
        updateEmailValidate(false, '');
      }
    } else {
      updateEmailValidate(false, '');
    }
  }

  String? _aboutError;
  String? get aboutError => _aboutError;

  // Validate about text
  bool isValidAbout() {
    final text = aboutController.text.trim();
    if (text.isEmpty) {
      _aboutError = 'About section is required';
      notifyListeners();
      return false;
    }

    if (text.length < 10) {
      _aboutError = 'About section must be at least 10 characters';
      notifyListeners();
      return false;
    }

    if (text.length > 500) {
      _aboutError = 'About section cannot exceed 500 characters';
      notifyListeners();
      return false;
    }

    _aboutError = null;
    notifyListeners();
    return true;
  }

  void validateAbout() {
    isValidAbout();
  }

  // Improve createProfile method
  Future<IBaseResponse> createProfile(BuildContext context) async {
    try {
      if (!isValidAbout()) {
        return StatusMessageResponse(
          status: '400',
          message: "Please provide a valid about section",
        );
      }

      if (selectedUserRoles.isEmpty) {
        return StatusMessageResponse(
          status: '400',
          message: "Please select at least one user role",
        );
      }
      final selectedRolesString = selectedUserRoles.join(',');
      final response = await sharedWebService.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        username: username.text.trim(),
        userType: selectedRolesString,
        about: aboutController.text.trim(),
        dob: ageController.text,
        phone: phoneController.text,
        gender: selectedGender == 'Select Gender' ? '' : selectedGender,
        image: _imageLogoPath.isNotEmpty ? _imageLogoPath : "",
        cover: _headerImagePath.isNotEmpty ? _headerImagePath : "",
      );

      if (response.status == 200 && response.user != null) {
        await SharedPreferenceHelper.instance().insertUser(response.user!);
      }
      return response;
    } catch (error) {
      debugPrint('Profile update error: $error');
      return StatusMessageResponse(
        status: '400',
        message: "Failed to update profile. Please try again.",
      );
    }
  }
}
