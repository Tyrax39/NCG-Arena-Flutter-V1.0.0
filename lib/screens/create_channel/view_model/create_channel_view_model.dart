import 'dart:developer';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateChannelViewModel extends ChangeNotifier {
  void disposeFunction() {
    quillController.clear();
    socialMedaLinkController.clear();
    channelName.clear();
    _logoImagePath = '';
    _headerImagePath = '';
    notifyListeners();
  }

  final SharedWebService sharedWebService = SharedWebService.instance();

  QuillController quillController = QuillController.basic();

  TextEditingController socialMedaLinkController = TextEditingController();
  TextEditingController channelName = TextEditingController();

  // Fields for error messages
  String? logoError;
  String? headerError;
  String? channelNameError;
  String? descriptionError;

  // Validation method
  bool validateForm() {
    bool isValid = true;

    // Check for logo
    if (imageLogoPath.isEmpty) {
      logoError = "Logo is required";
      isValid = false;
    } else {
      logoError = '';
    }

    // Check for header image
    if (imageHeaderPath.isEmpty) {
      headerError = "Header image is required";
      isValid = false;
    } else {
      headerError = '';
    }

    // Check for organization name
    if (channelName.text.isEmpty) {
      channelNameError = "Channel name is required";
      isValid = false;
    } else {
      channelNameError = '';
    }

    // Check for description
    if (quillController.document.toPlainText().trim().isEmpty) {
      descriptionError = "Description is required";
      isValid = false;
    } else {
      descriptionError = '';
    }

    notifyListeners();
    return isValid;
  }

  void clearLogoError() {
    logoError = '';

    notifyListeners();
  }

  void clearHeaderError() {
    headerError = '';

    notifyListeners();
  }

  void clearDescriptionError() {
    descriptionError = '';

    notifyListeners();
  }

  void clearNameError() {
    channelNameError = '';

    notifyListeners();
  }

  String _logoImagePath = "";
  String get imageLogoPath => _logoImagePath;
  set imageLogoPathSet(String value) {
    _logoImagePath = value;
  }

  void newImageLogoPath(String pickedImagePath) {
    imageLogoPathSet = pickedImagePath;
    notifyListeners();
    clearLogoError();
  }

  String _headerImagePath = "";
  String get imageHeaderPath => _headerImagePath;
  set imageHeaderPathSet(String value) {
    _headerImagePath = value;
  }

  void newImageHeaderPath(String pickedImagePath) {
    imageHeaderPathSet = pickedImagePath;
    notifyListeners();
    clearHeaderError();
  }

  Future<IBaseResponse> createChannel(String orgId) async {
    List aboutdeltaJson = quillController.document.toDelta().toJson();
    String description = DeltaToHTML.encodeJson(aboutdeltaJson).toString();
    try {
      final response = await sharedWebService.createChannel(
        logo: imageLogoPath,
        header_image: imageHeaderPath,
        name: channelName.text,
        description: description,
        org_id: orgId,
      );
      print('response in api-------------${response.organization}');
      if (response.status == 200) {}
      return response;
    } catch (error) {
      log(error.toString());
      return StatusMessageResponse(
        status: 400,
        message: "Invalid Data",
      );
    }
  }
}
