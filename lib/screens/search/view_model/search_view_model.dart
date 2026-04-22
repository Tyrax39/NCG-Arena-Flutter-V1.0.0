import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  final SharedWebService sharedWebService = SharedWebService.instance();
  int _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;

  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  String _searchQuery = '';
  bool _hasSearched = false;
  List<OrganizationsModel> _organizations = [];
  List<AllTournaments> _tournaments = [];
  List<UserDataModel> _users = [];

  List<OrganizationsModel> get organizations => _organizations;
  List<AllTournaments> get tournaments => _tournaments;
  List<UserDataModel> get users => _users;
  bool get hasSearched => _hasSearched;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _hasSearched = false;
    notifyListeners();
  }

  String getSourceType() {
    if (_selectedTabIndex == 0) {
      return 'organization';
    } else if (_selectedTabIndex == 1) {
      return 'tournament';
    } else if (_selectedTabIndex == 2) {
      return 'user';
    } else {
      return 'user';
    }
  }

  Future<void> searchAPI(BuildContext context) async {
    // try {
      final sourceType = getSourceType();
      final searchText = _searchQuery.trim();
      if (searchText.isEmpty) return;
      _hasSearched = true;
      notifyListeners();
      final response =
          await sharedWebService.getSearchResults(searchText, sourceType);
      if (response.status == 200) {
        _organizations = response.organizations ?? [];
        _tournaments = response.tournaments ?? [];
        _users = response.users ?? [];
        notifyListeners();
      }
    // } catch (e) {
    //   debugPrint('Search API Error: $e');
    // }
  }
}
