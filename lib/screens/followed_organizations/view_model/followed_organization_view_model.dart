import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class FollowedOrganizationViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();

  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMoreData = true;

  List<OrganizationsModel> organizationData = [];
  List<OrganizationsModel> popularOrganizationData = [];

  Future<void> getFollowedOrganization({bool loadMore = false}) async {
    if (!loadMore) {
      isLoading = true;
      currentPage = 1;
      organizationData.clear();
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final response = await sharedWebService.followedOrganizationApi();
      debugPrint('response in api-------------${response.toString()}');
      if (response.status == 200) {
        if (loadMore) {
          organizationData.addAll(response.organization!);
        } else {
          organizationData = response.organization!;
        }
        hasMoreData =
            response.organization!.length >= 10; // Assuming page size is 10
        if (hasMoreData) currentPage++;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> getPopularOrganization({bool loadMore = false}) async {
    if (!loadMore) {
      isLoading = true;
      currentPage = 1;
      popularOrganizationData.clear();
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final response = await sharedWebService.popularOrganizationApi();
      print('response in api-------------${response.toString()}');
      if (response.status == 200) {
        if (loadMore) {
          popularOrganizationData.addAll(response.organization!);
        } else {
          popularOrganizationData = response.organization!;
        }
        hasMoreData =
            response.organization!.length >= 10; // Assuming page size is 10
        if (hasMoreData) currentPage++;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
