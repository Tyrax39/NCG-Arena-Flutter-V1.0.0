import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class AllChannelsViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();

  int postsOffset = 0;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  List<ChannelModel> channelData = [];

  int channelsPage = 1;
  bool hasMorePopular = true;

  Future<void> getChannels(
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
      final response = await sharedWebService.getChannels(offset: offset);

      if (response.status == 200) {
        if (isLoadMore) {
          final newChannels = response.channel?.where((newChannel) {
            return !channelData
                .any((existingChannel) => existingChannel.id == newChannel.id);
          }).toList();
          channelData.addAll(newChannels ?? []);
        } else {
          channelData = response.channel ?? [];
        }

        postsOffset = channelData.length;
        channelsPage++;
        if ((response.channel?.length ?? 0) < 10) {
          hasMorePopular = false;
        }
      } else {
        _isInitialLoading = false;
        if (isLoadMore) {
          _isLoadingMore = false;
        }
      }
    } catch (e) {
      debugPrint('Error fetching channels: $e');
    } finally {
      _isInitialLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
