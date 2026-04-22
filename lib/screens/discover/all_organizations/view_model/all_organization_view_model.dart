import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class AllOrganizationViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();

  bool isLoading = false;
  List<OrganizationsModel> organizationData = [];

  int postsOffset = 0;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int organizationPage = 1;
  bool hasMorePopular = true;

  Future<void> getPopularOrganization(
    offset, {
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      _isInitialLoading = true;
      notifyListeners();
    } else {
      _isLoadingMore = true;
      notifyListeners();
    }

    try {
      final response =
          await sharedWebService.popularOrganizationApi(offset: offset);

      if (response.status == 200) {
        if (isLoadMore) {
          final newOrganization =
              response.organization?.where((newOrganization) {
            return !organizationData.any((existingOrganization) =>
                existingOrganization.id == newOrganization.id);
          }).toList();
          organizationData.addAll(newOrganization ?? []);
        } else {
          organizationData = response.organization ?? [];
        }

        postsOffset = organizationData.length;
        organizationPage++;
        if ((response.organization?.length ?? 0) < 10) {
          hasMorePopular = false;
        }
      } else {
        _isInitialLoading = false;
        if (isLoadMore) {
          _isLoadingMore = false;
        }
      }
    } catch (e) {
      debugPrint('Error fetching games: $e');
    } finally {
      _isInitialLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
