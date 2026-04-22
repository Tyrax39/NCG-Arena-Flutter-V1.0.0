import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/material.dart';

class TournamentHistoryViewModel extends ChangeNotifier {
  SharedWebService sharedWebService = SharedWebService.instance();
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  bool isLoading = false;

  UserDataModel? userData;

  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    debugPrint('user❌❌❌❌❌❌${user!.username}');
    userData = user;
    getTournamentHistory();
    notifyListeners();
  }

  List<AllTournaments> tournamentData = [];
  Future<void> getTournamentHistory() async {
    isLoading = true;
    try {
      final response = await sharedWebService.tournamentHistory(userData!.id);
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        tournamentData = response.tournament!;
        debugPrint('teamMembersData-------------${tournamentData.length}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
