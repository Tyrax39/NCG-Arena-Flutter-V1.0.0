import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/material.dart';
import '../../../DB/shared_preference_helper.dart';

class NotificationsPreferencesViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();

  bool joinTournament = false;
  bool followChannel = false;
  bool followUsers = false;
  bool followOrganizations = false;
  UserDataModel? userData;
  Future<IBaseResponse> updatePreference(String key, bool value) async {
    switch (key) {
      case 'joinTournament':
        joinTournament = value;
        break;
      case 'followChannel':
        followChannel = value;
        break;
      case 'followUsers':
        followUsers = value;
        break;
      case 'followOrganizations':
        followOrganizations = value;
        break;
    }
    notifyListeners();

    try {
      final response = await sharedWebService.updateProfile(
        notify_join_tournament: joinTournament ? '1' : '0',
        notify_follow_channel: followChannel ? '1' : '0',
        notify_follow_user: followUsers ? '1' : '0',
        notify_follow_organization: followOrganizations ? '1' : '0',
      );

      if (response.status == 200 && response.user != null) {
        await SharedPreferenceHelper.instance().insertUser(response.user!);
        userData = response.user;
      }
      return response;
    } catch (e) {
      print('Profile update error: $e');
      return StatusMessageResponse(
        status: '400',
        message: "Failed to update profile. Please try again.",
      );
    }
  }
}
