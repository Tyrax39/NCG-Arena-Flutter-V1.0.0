import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class AllTournamentViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();

  List<ChannelModel> channelData = [];

  getFollowedChannels() async {
    try {
      final response = await sharedWebService.followedChannelsApi();
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        channelData = response.followedChannels!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<ChannelModel> popularChannelData = [];

  getPopularChannels() async {
    try {
      final response = await sharedWebService.getChannels();
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        popularChannelData = response.channel!;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  List<OrganizationsModel> popularOrganizationData = [];

  getPopularOrganization() async {
    try {
      final response = await sharedWebService.popularOrganizationApi();
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        popularOrganizationData = response.organization!;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  List<OrganizationsModel> followedOrganizationData = [];
  getFollowedOrganization() async {
    try {
      final response = await sharedWebService.followedOrganizationApi();
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        followedOrganizationData = response.organization!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool isLoading = true;

  List<AllTournaments> tournamentData = [];
  getTournament() async {
    isLoading = true;
    try {
      final response = await sharedWebService.homeTournamentApi();
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        tournamentData = response.tournament!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
