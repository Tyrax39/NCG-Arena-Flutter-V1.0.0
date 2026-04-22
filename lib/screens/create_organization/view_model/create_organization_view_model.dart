import 'dart:developer';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateOrganizationViewModel extends ChangeNotifier {
  void disposeFunction() {
    quillController.clear();
    socialMedaLinkController.clear();
    organizationName.clear();
    facebookController.clear();
    instagramController.clear();
    youtubeController.clear();
    twitchController.clear();
    discordController.clear();
    _logoImagePath = '';
    _headerImagePath = '';
    selectedTypeId = 0;
    notifyListeners();
  }

  final SharedWebService sharedWebService = SharedWebService.instance();

  QuillController quillController = QuillController.basic();

  TextEditingController socialMedaLinkController = TextEditingController();
  TextEditingController organizationName = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController twitchController = TextEditingController();
  TextEditingController discordController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  final PageController pageSliderController = PageController();

  int pagerIndex = 0;

  void updatePagerIndex(int index) {
    pagerIndex = index;
    notifyListeners();
  }

  // Fields for error messages
  String? logoError;
  String? headerError;
  String? organizationNameError;
  String? typeError;
  String? descriptionError;

  // Validation method
  bool validateForm() {
    bool isValid = true;

    // Check for logo
    if (imageLogoPath.isEmpty) {
      logoError = LocaleKeys.logoIsRequired.tr();
      isValid = false;
    } else {
      logoError = null;
    }

    // Check for header image
    if (imageHeaderPath.isEmpty) {
      headerError = LocaleKeys.headerImageIsRequired.tr();
      isValid = false;
    } else {
      headerError = null;
    }

    // Check for organization name
    if (organizationName.text.isEmpty) {
      organizationNameError = LocaleKeys.organizationNameIsRequired.tr();
      isValid = false;
    } else {
      organizationNameError = null;
    }
    print('object--- ${selectedTypeId}');
    // Check for type
    if (selectedTypeId == null) {
      typeError = LocaleKeys.organizationTypeIsRequired.tr();
      isValid = false;
    } else {
      typeError = null;
    }

    // Check for description
    if (quillController.document.toPlainText().trim().isEmpty) {
      descriptionError = LocaleKeys.descriptionIsRequired.tr();
      isValid = false;
    } else {
      descriptionError = null;
    }

    notifyListeners();
    return isValid;
  }

  String _logoImagePath = "";
  String get imageLogoPath => _logoImagePath;
  set imageLogoPathSet(String value) {
    _logoImagePath = value;
  }

  void newImageLogoPath(String pickedImagePath) {
    imageLogoPathSet = pickedImagePath;
    notifyListeners();
  }

  String _headerImagePath = "";
  String get imageHeaderPath => _headerImagePath;
  set imageHeaderPathSet(String value) {
    _headerImagePath = value;
  }

  void newImageHeaderPath(String pickedImagePath) {
    imageHeaderPathSet = pickedImagePath;
    notifyListeners();
  }

  Map<String, int> typeName = {
    'Personal': 1,
    'Business': 2,
  };

  int? selectedTypeId;

  void setSelectedType(String type) {
    selectedTypeId = typeName[type];
    validateForm();
    notifyListeners();
  }

  Map<String, int> socialLinkName = {
    'Twitch': 1,
    'Discord': 2,
    'Website': 3,
  };

  int? selectedSocialLinkId;

  void setSelectedSocialLink(String link) {
    selectedSocialLinkId = socialLinkName[link];
    notifyListeners();
    validateForm();
  }

  Future<IBaseResponse> createOrganization() async {
    List aboutdeltaJson = quillController.document.toDelta().toJson();
    String description = DeltaToHTML.encodeJson(aboutdeltaJson).toString();
    try {
      final response = await sharedWebService.createOrganization(
        logo: imageLogoPath,
        header_image: imageHeaderPath,
        name: organizationName.text,
        type: selectedTypeId.toString(),
        description: description,
        facebook: facebookController.text,
        instagram: instagramController.text,
        youtube: youtubeController.text,
        twitch_username: twitchController.text,
        discord_invite_link: discordController.text,
        website: websiteController.text,
      );
      print('response in api-------------${response.organization}');
      if (response.status == 200) {
        return response;
      }
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
