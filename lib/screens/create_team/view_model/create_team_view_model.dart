import 'dart:developer';

import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateTeamViewModel extends ChangeNotifier {
  TextEditingController teamName = TextEditingController();
  QuillController controller = QuillController.basic();

  final SharedWebService sharedWebService = SharedWebService.instance();

  String? teamNameError;
  String? gameIdError;

  String? logoError;
  String? descriptionError;

  bool createTeamValidator() {
    bool isValid = true;

    if (_imagePath.isEmpty) {
      logoError = "Header image is required";
      isValid = false;
    } else {
      logoError = null;
    }

    if (teamName.text.isEmpty) {
      teamNameError = "Name is required";
      isValid = false;
    } else {
      teamNameError = null;
    }

    if (selectedGame == null) {
      gameIdError = "Game is required";
      isValid = false;
    } else {
      gameIdError = null;
    }

    if (controller.document.isEmpty()) {
      descriptionError = "About is required";
      isValid = false;
    } else {
      descriptionError = null;
    }

    notifyListeners();
    return isValid;
  }

  void clearTeamNameError() {
    teamNameError = null;
    notifyListeners();
  }

  void clearLogoError() {
    logoError = null;
    notifyListeners();
  }

  void clearGameIdError() {
    gameIdError = null;
    notifyListeners();
  }

  void clearDescriptionError() {
    descriptionError = null;
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

  int selectedGameId = 0;
  GameModel? selectedGame;

  void setSelectedGame(GameModel game, int id) {
    selectedGame = game;
    selectedGameId = id;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  List<GameModel> gameData = [];

  getGames() async {
    try {
      final response = await sharedWebService.getGames();
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        gameData = response.games!;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<IBaseResponse> createTeam() async {
    List aboutdeltaJson = controller.document.toDelta().toJson();
    String about = DeltaToHTML.encodeJson(aboutdeltaJson).toString();
    try {
      final response = await sharedWebService.createTeam(
        logo: _imagePath,
        gameId: selectedGameId.toString(),
        name: teamName.text,
        about: about,
      );
      print('response in api-------------${response.toString()}');
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
