import 'dart:developer';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';

class UpdateChannelViewModel extends ChangeNotifier {
  void disposeFunction() {
    quillController.clear();
    socialMedaLinkController.clear();
    channelName.clear();
    // Remove old _logoImagePath/_headerImagePath logic
    networkLogoUrl = "";
    fileLogoPath = "";
    networkHeaderUrl = "";
    fileHeaderPath = "";
    notifyListeners();
  }

  ChannelModel? channelData;

  Future<void> getChannelData(id) async {
    try {
      final response = await sharedWebService.getChannelsByChannelId(id);
      if (response.status == 200 && response.channel != null) {
        channelData = response.channel;
        // Set form fields with fetched data
        channelName.text = channelData?.name ?? '';
        networkLogoUrl = channelData?.logo ?? '';
        networkHeaderUrl = channelData?.header ?? '';
        fileLogoPath = '';
        fileHeaderPath = '';
        // Convert HTML to Quill Delta (if needed)
        if (channelData?.description != null && channelData!.description!.isNotEmpty) {
          try {
            // If your backend stores Quill Delta as JSON string, use this:
            // var doc = Document.fromJson(jsonDecode(channelData!.description!));
            // If your backend stores HTML, use a package to convert HTML to Delta, or fallback to plain text:
            quillController = QuillController(
              document: Document()..insert(0, channelData!.description!),
              selection: const TextSelection.collapsed(offset: 0),
            );
          } catch (e) {
            quillController = QuillController.basic();
          }
        }
        notifyListeners();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
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

  // New variables for network and file paths
  String networkLogoUrl = "";
  String fileLogoPath = "";
  String networkHeaderUrl = "";
  String fileHeaderPath = "";

  // Add new getters for UI
  String get imageLogoPath => fileLogoPath.isNotEmpty ? fileLogoPath : networkLogoUrl;
  String get imageHeaderPath => fileHeaderPath.isNotEmpty ? fileHeaderPath : networkHeaderUrl;

  // Setters for file pickers
  void newImageLogoPath(String pickedImagePath) {
    fileLogoPath = pickedImagePath;
    notifyListeners();
    clearLogoError();
  }

  void newImageHeaderPath(String pickedImagePath) {
    fileHeaderPath = pickedImagePath;
    notifyListeners();
    clearHeaderError();
  }

  Future<IBaseResponse> createChannel(String orgId) async {
    List aboutdeltaJson = quillController.document.toDelta().toJson();
    String description = DeltaToHTML.encodeJson(aboutdeltaJson).toString();
    try {
      final response = await sharedWebService.createChannel(
        logo: fileLogoPath.isNotEmpty ? fileLogoPath : '',
        header_image: fileHeaderPath.isNotEmpty ? fileHeaderPath : '',
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

  Future<IBaseResponse> updateChannel(String channelId, String orgId) async {
    List aboutdeltaJson = quillController.document.toDelta().toJson();
    String description = DeltaToHTML.encodeJson(aboutdeltaJson).toString();
    try {
      final response = await sharedWebService.updateChannel(
        channel_id: channelId,
        logo: fileLogoPath.isNotEmpty ? fileLogoPath : '',
        header_image: fileHeaderPath.isNotEmpty ? fileHeaderPath : '',
        name: channelName.text,
        description: description,
        org_id: orgId,
      );
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
