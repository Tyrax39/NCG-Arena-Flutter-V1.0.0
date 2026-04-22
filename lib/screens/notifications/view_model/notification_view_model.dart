import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/cupertino.dart';

class NotificationViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  DialogHelper dialogHelper = DialogHelper.instance();
  SnackbarHelper snackbarHelper = SnackbarHelper.instance();

  UserDataModel? userData;
  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    userData = user;
    notifyListeners();
  }

  bool isLoading = false;
  List<NotificationModel> notificationsData = [];

  Future<void> getNotifications(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    debugPrint('1------------------00');
    try {
      final response =
          await sharedWebService.getnotifications(context: context);
      if (response.status == 200 && response.notificationresponse != null) {
        notificationsData = response.notificationresponse!;

        debugPrint('notification----${notificationsData}');
        notifyListeners();
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //////////  Join Tournament  /////////
  Future<void> acceptReject(tournamentId, status, context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Loading');
    try {
      final response =
          await sharedWebService.acceptRejectTeam(tournamentId, status);
      dialogHelper.dismissProgress();
      if (response.status == 200) {
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

  Future<void> markAllRead(context) async {
    try {
      final response = await sharedWebService.markAllAsRead();
      dialogHelper.dismissProgress();
      if (response.status == 200) {
      } else {}
    } catch (error) {
      print("----------------$error");
      dialogHelper.dismissProgress();
    }
  }
}
