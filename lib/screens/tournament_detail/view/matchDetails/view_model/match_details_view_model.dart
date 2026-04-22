import 'dart:async';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/cupertino.dart';

class MatchDetailViewModel extends ChangeNotifier {
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  DialogHelper get dialogHelper => DialogHelper.instance();
  final SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  final SharedWebService sharedWebService = SharedWebService.instance();

  Timer? _timer;
  Duration remainingTime = Duration.zero;

  bool isLoading = false;

  // void updateCompitator1Validate(bool value, String errorText) =>
  //     emit(state.copyWith(compitator1Validate: value, errorText: errorText));
  //
  // void updateCompitator2Validate(bool value, String errorText) =>
  //     emit(state.copyWith(compitator1Validate: value, errorText: errorText));

// time  difference for timer
  int getTimeDifferenceInMinutes(DateTime futureDate, DateTime currentDate) {
    Duration difference = futureDate.difference(currentDate);
    return difference.inMinutes;
  }

//  start timer
  void _startTimer(int data) {
    // Cancel existing timer if any
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    
    // Validate data to prevent negative timer
    if (data <= 0) {
      remainingTime = Duration.zero;
      notifyListeners();
      return;
    }
    
    var timerDuration = Duration(minutes: data);
    remainingTime = timerDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingTime.inSeconds > 0) {
        remainingTime -= const Duration(seconds: 1);
        notifyListeners(); // Update the state with the remaining time
      } else {
        _timer?.cancel();
        notifyListeners(); // Notify when timer expires
      }
    });
  }

// mark check in

  Future<void> markCheckIn(id, context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog("Loading......");

    try {
      final response = await sharedWebService.markcheckIn(
        id: id,
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
        getMatch(id: id);
      } else {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage(
                  content: response.message.toString(),
                  isLongMessage: false,
                  isForError: true));
      }
    } catch (error) {
      dialogHelper.dismissProgress();
    }
  }

  MatchData? matchData;

//  get match data
  Future<void> getMatch({required int id}) async {
    isLoading = true;

    try {
      final response = await sharedWebService.getMatchData(
        id: id,
      );
      if (response.status == 200 && response.matchData != null) {
        // emit(state.copyWith(matchData: Data(data: response.matchData)));
        matchData = response.matchData;
        print('response ---------------${response.matchData}');
        notifyListeners();

        String utcTimeString = response.matchData!.endCheckInTime!;

        // Append "Z" to indicate UTC time
        String utcTimeStringWithZ = "$utcTimeString Z";
        // Parse UTC time string to DateTime object
        DateTime utcTime = DateTime.parse(utcTimeStringWithZ);
        // Convert UTC time to user's local time zone
        DateTime localTime = utcTime.toLocal();
        print("Local Time: $localTime");
        DateTime currentDate = DateTime.now();
        int remainMin = getTimeDifferenceInMinutes(localTime, currentDate);
        _startTimer(remainMin);
      } else {}
    } catch (error) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Cancel timer to prevent memory leaks
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    super.dispose();
  }
}