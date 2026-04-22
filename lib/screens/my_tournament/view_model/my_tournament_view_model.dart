import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class MyTournamentViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();

  int offset = 10;
  List<AllTournaments> tournamentData = [];
  bool isLoading = false;

  Future<void> getMyTournament(
      int offset, bool isLoadMore, BuildContext context) async {
    try {
      if (!isLoadMore) {
        isLoading = true;
      }
      final response = await sharedWebService.myTournamentApi(
          offset: offset, context: context);
      debugPrint('Response in API: ${response.toString()}');
      if (response.status == 200) {
        if (isLoadMore) {
          tournamentData.addAll(response.tournament!);
          offset = offset + response.tournament!.length;
        } else {
          tournamentData = response.tournament!;
          offset = offset + response.tournament!.length;
        }
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
