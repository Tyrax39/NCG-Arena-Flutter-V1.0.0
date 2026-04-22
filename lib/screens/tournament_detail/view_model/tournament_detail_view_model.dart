import 'dart:developer';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class TournamentDetailViewmodel extends ChangeNotifier {
  void disposeValues() {
    _selectedTabIndex = 0;
    _selectedOverviewTabIndex = 0;
  }

  SharedWebService sharedWebService = SharedWebService.instance();
  SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  DialogHelper get dialogHelper => DialogHelper.instance();

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  int _selectedOverviewTabIndex = 0;
  int get selectedOverviewTabIndex => _selectedOverviewTabIndex;

  void setSelectedOverviewTabIndex(int index) {
    _selectedOverviewTabIndex = index;
    notifyListeners();
  }

  UserDataModel? userData;
  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    userData = user;
    notifyListeners();
  }

//////////  Join Tournament  /////////
  Future<void> joinTournament(tournamentId, context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    debugPrint('tournamentId------------$tournamentId');
    try {
      final response = await sharedWebService.joinTournament(
        id: tournamentId,
      );
      dialogHelper.dismissProgress();
      if (response.status == 200) {
        final updatedDataEvent = tournamentData;
        if (updatedDataEvent != null) {
          final existingData = updatedDataEvent;
          existingData.isJoined = true;
          final updatedData = existingData;
          tournamentData = updatedData;
          notifyListeners();
        }
        // Close any open dialogs after successful join
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: false));
      } else {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: true,
                  isForError: true));
      }
    } catch (error) {
      dialogHelper.dismissProgress();
    }
  }

//////////  Start Tournament /////////
  Future<void> startTournament(tournamentId, context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await sharedWebService.startTournament(
        id: tournamentId,
      );
      dialogHelper.dismissProgress();
      if (response.status == 200 && response.message != '') {
        final updatedDataEvent = tournamentData;
        if (updatedDataEvent != null) {
          final existingData = updatedDataEvent;
          existingData.isStart = 1;
          final updatedData = existingData;
          tournamentData = updatedData;
        }

        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: false));
        notifyListeners();
      }
    } catch (error) {
      debugPrint("ERROR IN START TOURNAMENT $error");
      dialogHelper.dismissProgress();
    }
  }

  AllTournaments? tournamentData;
  DateTime localTime = DateTime.now();
  String remainingTime = '';

  Future<void> getTournamentData(id) async {
    try {
      final response = await sharedWebService.getTournamentById(id: id);
      if (response.status == 200 && response.tournament != null) {
        tournamentData = response.tournament;
        String utcTimeString = response.tournament!.startDatetime!;
        DateTime utcTime = DateTime.parse(utcTimeString);
        DateTime localTime = utcTime.toLocal();
        log("🦖🦖🦖🦖${localTime.toString()}");
        String remainTime = TournamentTimer.getTimeUntil(localTime);
        log("❌❌❌❌❌❌❌❌❌❌❌❌${remainTime.toString()}");
        if (response.tournament!.format.toString() == "1") {
          getParticipentsData(id);
        } else {
          getTeamOfUserByGame(response.tournament!.gameId!);
          getTeamsParticipent(id);
        }
        remainingTime = remainTime;
        localTime = localTime;
        notifyListeners();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  List<SearchUsers> participantsData = [];
  Future<void> getParticipentsData(id) async {
    try {
      final response = await sharedWebService.getparticipants(id: id);
      if (response.status == 200) {
        participantsData = response.searchuserlist!;
        notifyListeners();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  List<MyTeamModel> teamsData = [];

  Future<void> getTeamsParticipent(id) async {
    try {
      final response = await sharedWebService.getTournamnetTeams(id);
      if (response.status == 200) {
        teamsData = response.teams!;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future removeUserParticipent({
    required String userId,
    required int index,
    required String tournamentId,
    required context,
  }) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await sharedWebService.removeParticipentFromTournament(
        tournamentTd: tournamentId,
        userId: userId,
      );

      dialogHelper.dismissProgress();
      if (response.status == 200) {
        final teamDetails = participantsData;
        if (teamDetails.isNotEmpty) {
          List<SearchUsers> team = List<SearchUsers>.from(teamDetails);
          if (index >= 0 && index < team.length) {
            team.removeAt(index);
            participantsData = team;
            notifyListeners();
          }
        }
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: false));
      } else {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: true));
      }
    } catch (e) {
      dialogHelper.dismissProgress();
      log(e.toString());
    }
  }

  Future removeTeamParticipent(
      {required String teamid,
      required int index,
      required String tournamentId,
      required context}) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await sharedWebService.removeParticipentFromTournament(
        tournamentTd: tournamentId,
        teamTd: teamid,
      );
      dialogHelper.dismissProgress();
      if (response.status == 200) {
        final teamDetails = teamsData;
        if (teamDetails.isNotEmpty) {
          List<MyTeamModel> team = List<MyTeamModel>.from(teamDetails);
          if (index >= 0 && index < team.length) {
            team.removeAt(index);
            teamsData = team;
            notifyListeners();
          }
        }

        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: false));
      } else {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: true));
      }
    } catch (e) {
      dialogHelper.dismissProgress();
      debugPrint("Remove Team Participent $e");
    }
  }

  DetailTeam? userTeamData;
  Future<void> getTeamOfUserByGame(id) async {
    try {
      final response = await sharedWebService.getTeamByGame(id);
      if (response.status == 200 && response.team != null) {
        userTeamData = response.team;
      }
    } catch (error) {
      debugPrint("GET TEAM OF USER BY GAME ERROR /////// $error");
    }
  }
}

class TournamentTimer {
  static String getTimeUntil(DateTime utcStartTime) {
    DateTime now = DateTime.now();
    Duration difference = utcStartTime.difference(now);
    if (difference.isNegative) {
      // Tournament has already started
      return "";
    } else if (difference.inDays >= 1) {
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      if (hours > 0) {
        return "$days day${days > 1 ? 's' : ''} $hours hour${hours > 1 ? 's' : ''}";
      } else {
        return "$days day${days > 1 ? 's' : ''}";
      }
    } else if (difference.inHours >= 1) {
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;
      if (minutes > 0) {
        return "$hours hour${hours > 1 ? 's' : ''} $minutes min";
      } else {
        return "$hours hour${hours > 1 ? 's' : ''}";
      }
    } else if (difference.inMinutes >= 1) {
      int minutes = difference.inMinutes;
      int seconds = difference.inSeconds % 60;
      if (seconds > 0) {
        return "$minutes min $seconds sec";
      } else {
        return "$minutes min";
      }
    } else {
      int seconds = difference.inSeconds;
      return "$seconds sec";
    }
  }
}
