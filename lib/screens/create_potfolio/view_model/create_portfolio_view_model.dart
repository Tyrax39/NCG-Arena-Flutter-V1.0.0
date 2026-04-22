// import 'dart:developer';
// import 'dart:io';
// import 'package:neoncave_arena/backend/server_response.dart';
// import 'package:neoncave_arena/backend/shared_web_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:video_player/video_player.dart';

// class CreatePortfolioViewModel extends ChangeNotifier {
//   SharedWebService sharedWebService = SharedWebService.instance();
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   String? titleError;
//   String? descriptionError;
//   String? mediaError;

//   bool portfolioValidator() {
//     bool isValid = true;

//     // Validate title
//     if (titleController.text.isEmpty) {
//       titleError = "Title is required";
//       isValid = false;
//     } else {
//       titleError = null;
//     }

//     // Validate description
//     if (descriptionController.text.isEmpty) {
//       descriptionError = "Description is required";
//       isValid = false;
//     } else {
//       descriptionError = null;
//     }

//     // Validate image or video
//     if (selectedImage == null && _videoPlayerController == null) {
//       mediaError = "Image or video is required";
//       isValid = false;
//     } else {
//       mediaError = null; // Clear error if media is valid
//     }
//     notifyListeners();
//     return isValid;
//   }

//   void emptyTitleErrors() {
//     titleError = null;
//     notifyListeners();
//   }

//   void emptyDescriptionErrors() {
//     descriptionError = null;
//     notifyListeners();
//   }

//   void emptyMediaErrors() {
//     mediaError = null;
//     notifyListeners();
//   }

//   File? selectedImage;
//   VideoPlayerController? _videoPlayerController;
//   File? selectedVideoPath;

//   VideoPlayerController? get videoPlayerController => _videoPlayerController;

//   void handleImageSelection(File file) {
//    log("ON HANDLEEEE");
//      selectedImage = file;
//     selectedVideoPath = null;
//     mediaError = null;
//     log("Selected image path: ${selectedImage?.path}");
//     notifyListeners();
//   }

//   Future<void> handleVideoSelection(File file) async {
//     _videoPlayerController?.dispose();
//     _videoPlayerController = VideoPlayerController.file(file);
//     selectedVideoPath = file;
//     selectedImage = null; // Reset image if video is selected
//     await _videoPlayerController?.initialize();
//     mediaError = null;
//     notifyListeners();
//   }

//   void resetMedia() {
//     selectedImage = null;
//     selectedVideoPath = null;
//     _videoPlayerController?.dispose();
//     _videoPlayerController = null;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     super.dispose();
//   }

//   Future<IBaseResponse> createPortfolio() async {
//     try {
//       if (selectedImage == null && selectedVideoPath == null) {
//         return StatusMessageResponse(
//           status: 400,
//           message: "Please select an image or a video.",
//         );
//       }

//       final response = await sharedWebService.createPortfolio(
//         title: titleController.text,
//         description: descriptionController.text,
//         image: selectedImage != null ? selectedImage!.path : '',
//         postVideo: selectedVideoPath != null ? selectedVideoPath!.path : '',
//       );

//       log('Response in API: ${response.toString()}');
//       return response;
//     } catch (error) {
//       log("API Error: ${error.toString()}");
//       return StatusMessageResponse(
//         status: 400,
//         message: "Something went wrong. Please try again.",
//       );
//     }
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CreatePortfolioViewModel extends ChangeNotifier {
  SharedWebService sharedWebService = SharedWebService.instance();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? titleError;
  String? descriptionError;
  String? mediaError;

  File? selectedImage;
  VideoPlayerController? _videoPlayerController;
  File? selectedVideoPath;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  bool portfolioValidator() {
    bool isValid = true;

    // Validate title
    if (titleController.text.isEmpty) {
      titleError = "Title is required";
      isValid = false;
    } else {
      titleError = null;
    }

    // Validate description
    if (descriptionController.text.isEmpty) {
      descriptionError = "Description is required";
      isValid = false;
    } else {
      descriptionError = null;
    }

    // Validate image or video
    if (selectedImage == null && _videoPlayerController == null) {
      mediaError = "Image or video is required";
      isValid = false;
    } else {
      mediaError = null; // Clear error if media is valid
    }
    notifyListeners();
    return isValid;
  }

  void emptyTitleErrors() {
    titleError = null;
    notifyListeners();
  }

  void emptyDescriptionErrors() {
    descriptionError = null;
    notifyListeners();
  }

  void emptyMediaErrors() {
    mediaError = null;
    notifyListeners();
  }

  void handleImageSelection(File file) {
    log("Image selection started");

    // Dispose of any existing video controller
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }

    selectedImage = file;
    selectedVideoPath = null;
    mediaError = null;
    log("Selected image path: ${selectedImage?.path}");
    notifyListeners();
    log("Image selection complete, notified listeners");
  }

  Future<void> handleVideoSelection(File file) async {
    log("Video selection started");

    // Clear previous state
    selectedImage = null;

    // Dispose previous controller if exists
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
    }

    try {
      _videoPlayerController = VideoPlayerController.file(file);
      selectedVideoPath = file;

      // Initialize the controller
      await _videoPlayerController!.initialize();
      mediaError = null;

      log("Video initialized successfully: ${file.path}");
      notifyListeners();
      log("Video selection complete, notified listeners");
    } catch (e) {
      log("Error initializing video: $e");
      _videoPlayerController = null;
      selectedVideoPath = null;
      mediaError = "Failed to load video. Please try another.";
      notifyListeners();
    }
  }

  void resetMedia() {
    log("Resetting media");
    selectedImage = null;
    selectedVideoPath = null;

    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }

    notifyListeners();
    log("Media reset complete");
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<IBaseResponse> createPortfolio() async {
    try {
      if (selectedImage == null && selectedVideoPath == null) {
        return StatusMessageResponse(
          status: 400,
          message: "Please select an image or a video.",
        );
      }
      final response = await sharedWebService.createPortfolio(
        title: titleController.text,
        description: descriptionController.text,
        image: selectedImage != null ? selectedImage!.path : '',
        postVideo: selectedVideoPath != null ? selectedVideoPath!.path : '',
      );
      log('Response in API: ${response.toString()}');
      return response;
    } catch (error) {
      log("API Error: ${error.toString()}");
      return StatusMessageResponse(
        status: 400,
        message: "Something went wrong. Please try again.",
      );
    }
  }
}
