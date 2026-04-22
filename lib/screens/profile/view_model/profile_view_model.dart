import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  void disposeValues() {
    _selectedTabIndex = 0;
  }

  SharedWebService sharedWebService = SharedWebService.instance();
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  DialogHelper dialogHelper = DialogHelper.instance();
  final SnackbarHelper _snackbarHelper = SnackbarHelper.instance();

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;
  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    // Use a microtask to ensure notifyListeners is called outside the build process
    Future.microtask(() {
      notifyListeners();
    });
  }

  UserDataModel? userData;
  UserDataModel? currentUserData;

  Future<void> getUserFromSharedPref() async {
    final user = await sharedPreferenceHelper.user;
    debugPrint('user data❌❌❌❌❌❌${user}');
    debugPrint('following counts❌❌❌❌❌❌${user!.followingCount}');

    currentUserData = user;
    // Use a microtask to ensure notifyListeners is called outside the build process
    Future.microtask(() {
      notifyListeners();
    });
  }

  Future<void> getUserData(id) async {
    try {
      final response = await sharedWebService.getUserDataWithId(id: id);
      if (response.status == 200) {
        userData = response.userdata;
        debugPrint('userData❌❌❌❌❌❌${userData!.username}');
        // Use a microtask to ensure notifyListeners is called outside the build process
        Future.microtask(() {
          notifyListeners();
        });
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  List<PortfolioData> userImagesList = [];
  List<PortfolioData> userVideoList = [];
  bool isLoading = false;
  String? errorMessage;

  /// Fetch user posts and update Provider state
  Future<void> getCurrentUserPosts({
    int offset = 0,
    int userId = 0,
  }) async {
    // Use a microtask to ensure notifyListeners is called outside the build process
    Future.microtask(() {
      isLoading = true;
      notifyListeners();
    });
    
    try {
      if (offset == 0) {
        userImagesList.clear();
        userVideoList.clear();
      }
      debugPrint('offset user portfolio-----------${offset}');
      final response = await sharedWebService.getUserPortfolio(
        userid: userId,
        offset: offset,
      );
      debugPrint('Portfolio response-----------${response.images?.length} images, ${response.videos?.length} videos');
      
      if (response.status == 200) {
        if (response.images != null) {
          userImagesList.addAll(response.images!.where((newItem) =>
              !userImagesList
                  .any((existingItem) => existingItem.id == newItem.id)));
        }
        if (response.videos != null) {
          userVideoList.addAll(response.videos!.where((newItem) =>
              !userVideoList
                  .any((existingItem) => existingItem.id == newItem.id)));
        }
        errorMessage = null;
        debugPrint('Updated portfolio: ${userImagesList.length} images, ${userVideoList.length} videos');
      } else {
        errorMessage = "Failed to fetch user posts: ${response.message}";
        debugPrint('Error fetching portfolio: ${response.message}');
      }
    } catch (error) {
      errorMessage = error.toString();
      debugPrint('Exception in getCurrentUserPosts: $error');
    }
    
    // Use a microtask to ensure notifyListeners is called outside the build process
    Future.microtask(() {
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> deletePortfolioItem(int portfolioId) async {
    // Use a microtask to ensure notifyListeners is called outside the build process
    Future.microtask(() {
      isLoading = true;
      notifyListeners();
    });
    
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

    // Use a microtask to ensure notifyListeners is called outside the build process
    Future.microtask(() {
      isLoading = false;
      notifyListeners();
    });
  }

  /// Refresh portfolio data for a specific user
  Future<void> refreshPortfolioData(int userId) async {
    await getCurrentUserPosts(userId: userId, offset: 0);
  }

  List<AllTournaments> tournamentData = [];
  getTournamentHistory(userId) async {
    try {
      final response = await sharedWebService.tournamentHistory(userId);
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        tournamentData = response.tournament!;
        debugPrint('teamMembersData-------------${tournamentData.length}');
        // Use a microtask to ensure notifyListeners is called outside the build process
        Future.microtask(() {
          notifyListeners();
        });
      }
    } catch (e) {
      // debugPrint(e);
    }
  }

  Future<void> followUser(int userId, BuildContext context) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Loading....');

    try {
      final response = await sharedWebService.followUser(id: userId);
      dialogHelper.dismissProgress();

      if (response.status == 200 && response.message.isNotEmpty) {
        debugPrint('status---------${response.status}');
        getUserData(userId);
        // Use a microtask to ensure notifyListeners is called outside the build process
        Future.microtask(() {
          notifyListeners();
        });
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
            snackbarMessage: const SnackbarMessage(
              content: 'An error occurred. Please try again.',
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
          snackbarMessage: const SnackbarMessage(
            content: 'Failed to follow/unfollow the user. Please try again.',
            isLongMessage: false,
            isForError: true,
          ),
        );
    }
  }
}
