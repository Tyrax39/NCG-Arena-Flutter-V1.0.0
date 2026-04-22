import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class AllGamesViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();

  bool isLoading = false;

  List<GameModel> gameData = [];

  int postsOffset = 0;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int gamePage = 1;
  bool hasMorePopular = true;

  Future<void> getGames(
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
      final response = await sharedWebService.getGames(offset: offset);

      if (response.status == 200) {
        if (isLoadMore) {
          final newGames = response.games?.where((newGames) {
            return !gameData
                .any((existingGames) => existingGames.id == newGames.id);
          }).toList();
          gameData.addAll(newGames ?? []);
        } else {
          gameData = response.games ?? [];
        }

        postsOffset = gameData.length;
        gamePage++;
        if ((response.games?.length ?? 0) < 10) {
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
