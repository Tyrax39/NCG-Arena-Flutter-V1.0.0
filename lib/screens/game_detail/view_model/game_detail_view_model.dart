import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class GameDetailViewModel extends ChangeNotifier {
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  final SharedWebService sharedWebService = SharedWebService.instance();

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  List<AllTournaments> tournamentData = [];

  getTournament({int? gameId, context}) async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    notifyListeners();
    try {
      final response =
          await sharedWebService.gamesTournamentApi(gameId, context);
      if (response.status == 200) {
        tournamentData = response.tournament!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
      hasError = true;
      errorMessage = 'Failed to load tournaments. Please try again.';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
