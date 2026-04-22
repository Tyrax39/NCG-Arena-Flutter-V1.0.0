import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/material.dart';

class MatchUpdateScoreViewModel extends ChangeNotifier {
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  DialogHelper get dialogHelper => DialogHelper.instance();
  final SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  final SharedWebService sharedWebService = SharedWebService.instance();
  final TextEditingController usertypeController = TextEditingController();
  final TextEditingController competitor1Controller = TextEditingController();
  final TextEditingController competitor2Controller = TextEditingController();

  String? competitor1Error;
  String? competitor2Error;

  void clearCompetitor1Error() {
    competitor1Error = null;
    notifyListeners();
  }

  void clearCompetitor2Error() {
    competitor2Error = null;
    notifyListeners();
  }

  bool validateScores() {
    bool isValid = true;

    if (competitor1Controller.text.isEmpty) {
      competitor1Error = "Score is required";
      isValid = false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(competitor1Controller.text)) {
      competitor1Error = "Only numbers allowed";
      isValid = false;
    }
    
    if (competitor2Controller.text.isEmpty) {
      competitor2Error = "Score is required";
      isValid = false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(competitor2Controller.text)) {
      competitor2Error = "Only numbers allowed";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> scoreUpdate(id, context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog("Loading...........");
    try {
      final response = await sharedWebService.updateMatchScore(
        id: id,
        compitator1: competitor1Controller.text,
        compitator2: competitor2Controller.text,
      );

      dialogHelper.dismissProgress();
      if (response.status == 200 && response.message != '') {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: false));
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage.longMessageError(
            content: response.message.toString(),
          ));
      }
    } catch (error) {
      dialogHelper.dismissProgress();
    }
  }

  MatchData? machData;

  Future<void> getMatch({id}) async {
    try {
      final response = await sharedWebService.getMatchData(
        id: id,
      );

      if (response.status == 200 && response.matchData != null) {

        machData = response.matchData;
        notifyListeners();

      } else {}
    } catch (error) {}
  }

  // @override
  // Future<void> close() {
  //   usertypeController.dispose();
  //   competitor1Controller.dispose();
  //   competitor2Controller.dispose();
  //   // return super.close();
  // }
}
