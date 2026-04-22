import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChannelDetailViewModel extends ChangeNotifier {
  int _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;

  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  DialogHelper dialogHelper = DialogHelper.instance();
  SharedWebService sharedWebService = SharedWebService.instance();
  SnackbarHelper _snackbarHelper = SnackbarHelper.instance();

  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  UserDataModel? userData;
  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    print('user❌❌❌❌❌❌${user!.username}');
    userData = user;
    notifyListeners();
  }

  ChannelModel? channelData;

  Future<void> getChannelData(id) async {
    try {
      final response = await sharedWebService.getChannelsByChannelId(id);
      print('response-------$response');
      if (response.status == 200 && response.channel != null) {
        channelData = response.channel;
        notifyListeners();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  List<LiveStreamData>? channelStreams;
  Future<void> getLiveStreamsByChannelId(String channelId) async {
    try {
      final response =
          await sharedWebService.getLiveStreamsByChannelId(channelId);
      // print('live streams response-------$response');
      if (response.status == 200 && response.liveStreams != null) {
        channelStreams = response.liveStreams;
        notifyListeners();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> subscribeChannel(int channelId, BuildContext context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Loading....');

    try {
      final response = await sharedWebService.subscribeChannel(id: channelId);
      dialogHelper.dismissProgress();

      if (response.status == 200 && response.message.isNotEmpty) {
        print('status---------${response.status}');

        getChannelData(channelId.toString());

        notifyListeners();

        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: SnackbarMessage(
              content: response.message,
              isLongMessage: false,
              isForError: false,
            ),
          );
      } else {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: SnackbarMessage(
              content: response.message,
              isLongMessage: false,
              isForError: true,
            ),
          );
      }
    } catch (error) {
      dialogHelper.dismissProgress();
      debugPrint(error.toString());
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
          snackbarMessage: SnackbarMessage(
            content: LocaleKeys.somethingWentWrong.tr(),
            isLongMessage: false,
            isForError: true,
          ),
        );
    }
  }
}
