import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TeamCreateViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  final SharedWebService sharedWebService = SharedWebService.instance();

  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  // List<MyTeamModel> teamData = [];
  bool isLoading = false;
  String selectedUserId = '';

  /// ✅ Select User & Highlight Tile
  void selectUser(String userId) {
    selectedUserId = userId;
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
      } else {
        showSnackBar(context, response.message);
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
    notifyListeners();
  }

  List<UserDataModel> users = [];
  Timer? _debounce;

  void searchWithDebounce(BuildContext context, String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.length > 3) {
        setSearchQuery(text);
        searchAPI(context);
      }
    });
  }

  Future<void> searchAPI(BuildContext context) async {
    if (searchQuery.length <= 3) return;
    
    isLoading = true;
    notifyListeners();

    try {
      final searchText = searchQuery.trim(); // Trim spaces from user input

      if (searchText.isEmpty) return; // Prevent empty searches
      hasSearched = true; // ✅ Mark search as performed
      notifyListeners();
      
      final response =
          await sharedWebService.getSearchResults(searchText, 'user');
      
      if (response.status == 200) {
        users = response.users ?? [];
        notifyListeners();
      }
    } catch (e) {
      print('Search API Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
