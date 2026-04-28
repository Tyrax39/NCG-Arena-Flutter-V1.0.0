import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/utils/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamDetailViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  final SharedWebService sharedWebService = SharedWebService.instance();

  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  List<MyTeamModel> teamData = [];
  bool isLoading = false;
  String? selectedUserId; // Selected User ID

  /// ✅ Select User & Highlight Tile
  void selectUser(String userId) {
    selectedUserId = userId;
    notifyListeners();
  }

  getTeam() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await sharedWebService.getTeamApi();
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        teamData = response.team!;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Member> teamMembersData = [];

  getTeamMembers(String teamId) async {
    try {
      final response = await sharedWebService.getTeamMembersApi(teamId: teamId);
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        teamMembersData = response.members!;
        print('teamMembersData-------------${teamMembersData.length}');
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  UserDataModel? userData;
  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    userData = user;
    notifyListeners();
  }

  Future<void> addPlayerInTeam(BuildContext context, String teamId) async {
    if (selectedUserId == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await sharedWebService.addPlayer(
        teamId: teamId,
        userId: selectedUserId!,
      );

      if (response.status == 200) {
        // Success
        showSnackBar(context, 'Player added successfully');
        Navigator.pop(context); // Go back to team detail screen
        // Refresh team members list
        getTeamMembers(teamId);
      } else {
        showSnackBar(context, response.message ?? 'Failed to add player');
      }
    } catch (error) {
      debugPrint('Add player error: $error');
      showSnackBar(context, 'Error occurred while adding player');
    }

    isLoading = false;
    notifyListeners();
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool hasSearched = false;

  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    hasSearched = false; // ✅ Reset search state when typing
    notifyListeners();
  }

  List<UserDataModel> users = [];
  Future<void> searchAPI(BuildContext context) async {
    showLoadingIndicator(
      context: context,
      color: AppColor.primaryColor,
    );

    try {
      final searchText = searchQuery.trim(); // Trim spaces from user input

      if (searchText.isEmpty) return; // Prevent empty searches
      hasSearched = true; // ✅ Mark search as performed
      notifyListeners();
      final response =
          await sharedWebService.getSearchResults(searchText, 'user');
      hideOpenDialog(context: context);
      if (response.status == 200) {
        users = response.users ?? [];
        notifyListeners();
      }
    } catch (e) {
      print('Search API Error: $e');
    }
  }
}
