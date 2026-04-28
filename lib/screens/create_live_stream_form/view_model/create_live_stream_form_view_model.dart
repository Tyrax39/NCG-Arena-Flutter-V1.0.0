import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class CreateLiveStreamFormViewModel extends ChangeNotifier {
  final SharedPreferenceHelper _sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  final SharedWebService _sharedWebService = SharedWebService.instance();

  final TextEditingController nameController = TextEditingController();

  String? nameError;
  String? logoError;
  String? messageError;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _imagePath = "";
  String get imagePath => _imagePath;

  void setImagePath(String path) {
    _imagePath = path;
    logoError = null;
    notifyListeners();
  }

  void clearForm() {
    nameController.clear();
    _imagePath = "";
    nameError = null;
    logoError = null;
    messageError = null;
    notifyListeners();
  }

  bool validateForm() {
    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError = LocaleKeys.streamTitleIsRequired.tr();
      isValid = false;
    } else {
      nameError = null;
    }

    if (_imagePath.isEmpty) {
      logoError = LocaleKeys.thumbnailImageIRequired.tr();
      isValid = false;
    } else {
      logoError = null;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> createLiveStreaming(
      {required String channelName,
      required String channelId,
      required BuildContext context}) async {
    if (!validateForm()) return;
    final user = await _sharedPreferenceHelper.user;
    if (user == null) {
      messageError = "User not logged in";
      notifyListeners();
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _sharedWebService.createLiveStream(
          channelName, channelId, nameController.text.trim(), _imagePath);
      if (response.data?.agoraChannelName != null &&
          response.data?.agoraToken != null) {
        Navigator.pushNamed(context, MyRoutes.liveStreamScreen, arguments: [
          response.data!.id,
          response.data!.userId,
          true,
          response.data!.agoraToken,
          response.data!.agoraChannelName,
        ]);
        clearForm();
      } else {
        messageError = "Failed to create live stream";
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('Error creating live stream: $e\n$stackTrace');
      messageError = "An error occurred while creating live stream";
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
