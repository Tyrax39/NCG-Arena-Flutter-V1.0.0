import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/screens/main/nav_items/account_screen.dart';
import 'package:neoncave_arena/screens/main/nav_items/discover_screen.dart';
import 'package:neoncave_arena/screens/main/nav_items/home_screen.dart';
import 'package:neoncave_arena/screens/main/nav_items/leader_board.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  BuildContext? textFieldContext;
  final GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  Key inputKey = GlobalKey();

  static const _accountScreenNavigationKey =
      PageStorageKey(AccountScreen.key_title);
  static const _profileScreenyNavigationKey =
      PageStorageKey<String>(LeaderboardScreen.key_title);
  static const _homeScreenNavigationKey = PageStorageKey(HomeScreen.key_title);
  static const _discoverScreenNavigationKey =
      PageStorageKey(DiscoverScreen.key_title);

  final _bottomMap = <PageStorageKey<String>, Widget>{};

  SharedPreferenceHelper get prefs => SharedPreferenceHelper.instance();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MainScreenProvider() {
    _bottomMap[_accountScreenNavigationKey] =
        const HomeScreen(key: _homeScreenNavigationKey);
    _bottomMap[_profileScreenyNavigationKey] = const SizedBox();
    _bottomMap[_homeScreenNavigationKey] = const SizedBox();
    _bottomMap[_discoverScreenNavigationKey] = const SizedBox();
  }

  int _index = 0;
  int get index => _index;
  get bottomMap => _bottomMap;

  Widget getNavigationWidget(int index) {
    switch (index) {
      case 0:
        return const HomeScreen(key: _homeScreenNavigationKey);
      case 1:
        return const DiscoverScreen(key: _discoverScreenNavigationKey);
      case 2:
        return const LeaderboardScreen(key: _profileScreenyNavigationKey);
      case 3:
        return const AccountScreen(key: _accountScreenNavigationKey);
      default:
        return const SizedBox();
    }
  }

  void updateBottomNavIndex(int index) {
    if (_index == index) return;
    if (index >= _bottomMap.length) return;
    final pageStorageKey = _bottomMap.keys.elementAt(index);
    final bottomItem = _bottomMap[pageStorageKey];
    if (bottomItem == null || bottomItem is SizedBox) {
      final newBottomWidget = getNavigationWidget(index);
      _bottomMap[pageStorageKey] = newBottomWidget;
    }
    _index = index;
    notifyListeners();
  }

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;
  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  // Leaderboard tab state
  int _leaderboardTabIndex = 0; // 0 for Players, 1 for Teams
  int get leaderboardTabIndex => _leaderboardTabIndex;
  void setLeaderboardTabIndex(int index) {
    _leaderboardTabIndex = index;
    notifyListeners();
  }

  UserDataModel? userData;
  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    debugPrint('user❌❌❌❌❌❌${user!.followingCount}');
    userData = user;
    notifyListeners();
  }

  UserDataModel? userDataFromApi;
  Future<void> getUserFromApi() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final userData = await sharedWebService.getUserDataWithId(id: user.id!);
    if (userData.status == 200) {
      userDataFromApi = userData.userdata;
      notifyListeners();
    } else {
      userDataFromApi = null;
      notifyListeners();
    }
  }

  List<PortfolioData> userImagesList = [];
  List<PortfolioData> userVideoList = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> getCurrentUserPosts({
    int offset = 0,
  }) async {
    isLoading = true;

    try {
      final response = await sharedWebService.getMyPortfolio(
        offset: offset,
      );
      debugPrint('response-----------${response.images}');
      if (response.status == 200) {
        // Merge new images without duplicates
        if (response.images != null) {
          userImagesList.addAll(response.images!.where((newItem) =>
              !userImagesList
                  .any((existingItem) => existingItem.id == newItem.id)));
        }

        // Merge new videos without duplicates
        if (response.videos != null) {
          userVideoList.addAll(response.videos!.where((newItem) =>
              !userVideoList
                  .any((existingItem) => existingItem.id == newItem.id)));
        }

        errorMessage = null;
      } else {
        errorMessage = "Failed to fetch user posts.";
      }
    } catch (error) {
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deletePortfolioItem(int portfolioId) async {
    try {
      final response = await sharedWebService.deletePortfolio(id: portfolioId);
      if (response.status == 200) {
        userImagesList.removeWhere((item) => item.id == portfolioId);
        userVideoList.removeWhere((item) => item.id == portfolioId);
        errorMessage = null;
        debugPrint("Portfolio item deleted successfully.");
      } else {
        errorMessage = response.message;
        debugPrint("Error deleting portfolio: $errorMessage");
      }
    } catch (error) {
      errorMessage = error.toString();
      debugPrint("Exception in deletePortfolioItem: $errorMessage");
    }
    notifyListeners();
  }

  List<BannersModel> bannersData = [];
  getBanners() async {
    isLoading = true;
    try {
      final response = await sharedWebService.getBanners();
      debugPrint(
          'response in api of banner data -------------${response.toString()}');
      if (response.status == 200) {
        bannersData = response.bannersData!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<AllTournaments> tournamentHistory = [];

  Future<void> tournamentHistoryApi() async {
    final user = await sharedPreferenceHelper.user;
    if (user != null) {
      try {
        final response = await sharedWebService.tournamentHistory(user.id);
        debugPrint(
            'response tournament history-------------${response.toString()}');
        if (response.status == 200) {
          tournamentHistory = response.tournament!;
          notifyListeners();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  List<ChannelModel> channelData = [];

  getFollowedChannels(BuildContext context) async {
    try {
      final response =
          await sharedWebService.followedChannelsApi(context: context);
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

  getPopularChannels(BuildContext context) async {
    try {
      final response = await sharedWebService.getChannels(context: context);
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        popularChannelData = response.channel!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<OrganizationsModel> popularOrganizationData = [];

  getPopularOrganization(BuildContext context) async {
    try {
      final response =
          await sharedWebService.popularOrganizationApi(context: context);
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        popularOrganizationData = response.organization!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<OrganizationsModel> followedOrganizationData = [];
  getFollowedOrganization(BuildContext context) async {
    try {
      final response =
          await sharedWebService.followedOrganizationApi(context: context);
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        followedOrganizationData = response.organization!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<AllTournaments> allTournamentData = [];
  getTournament(BuildContext context) async {
    isLoading = true;
    try {
      final response =
          await sharedWebService.homeTournamentApi(context: context);
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        allTournamentData = response.tournament!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int _myCurrentIndex = 0;
  int get myCurrentIndex => _myCurrentIndex;

  void changeCurrentIndex(int newIndex) {
    _myCurrentIndex = newIndex;
    notifyListeners();
  }

  List<GameModel> gameData = [];

  getGames(BuildContext context) async {
    isLoading = true;
    try {
      final response = await sharedWebService.getGames(context: context);
      debugPrint('game response in api-------------${response.toString()}');
      if (response.status == 200) {
        gameData = response.games!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Leaderboard data
  List<LeaderboardUser> leaderboardUsers = [];
  List<LeaderboardTeam> leaderboardTeams = [];
  bool isLeaderboardLoading = false;
  String? leaderboardErrorMessage;

  Future<void> getLeaderboardData() async {
    isLeaderboardLoading = true;
    leaderboardErrorMessage = null;
    notifyListeners();

    try {
      final response = await sharedWebService.leaderboardApi();
      debugPrint('Leaderboard API Response: ${response.toString()}');
      
      if (response.status == 200 && response.data != null) {
        leaderboardUsers = response.data!.users ?? [];
        leaderboardTeams = response.data!.teams ?? [];
        leaderboardErrorMessage = null;
        debugPrint('Leaderboard users count: ${leaderboardUsers.length}');
        debugPrint('Leaderboard teams count: ${leaderboardTeams.length}');
      } else {
        leaderboardErrorMessage = response.message;
        debugPrint('Leaderboard API Error: ${response.message}');
      }
    } catch (e) {
      leaderboardErrorMessage = e.toString();
      debugPrint('Leaderboard API Exception: $e');
    } finally {
      isLeaderboardLoading = false;
      notifyListeners();
    }
  }

  bool isLoggingOut = false;
  bool _isAboutExpanded = false;
  bool get isAboutExpanded => _isAboutExpanded;

  void toggleAboutExpansion() {
    _isAboutExpanded = !_isAboutExpanded;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    isLoggingOut = true;
    notifyListeners();
    try {
      StatusMessageResponse response = await sharedWebService.logout();
      print('response in logout ${response.message}');
      _index = 0;
      if (response.status == 200) {
        await sharedPreferenceHelper.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.selectionView, (route) => false);
      } else {
        DialogHelper.instance().showTitleContentDialog(
          MaterialDialogContent(
            title: "Logout Failed",
            content: response.message,
            positiveText: "OK",
          ),
          () => Navigator.pop(context),
        );
      }
    } catch (e) {
      debugPrint('error in logout ${e.toString()}');
    }
    isLoggingOut = false;
    notifyListeners();
  }
}
