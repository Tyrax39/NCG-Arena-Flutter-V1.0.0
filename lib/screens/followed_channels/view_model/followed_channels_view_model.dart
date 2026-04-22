import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:flutter/cupertino.dart';

class FollowedChannelsViewModel extends ChangeNotifier {
  final SharedWebService sharedWebService = SharedWebService.instance();
  List<ChannelModel> channelData = [];
  int followedChannelsPage = 1;
  bool hasMoreFollowed = true;
  int postsOffset = 0; // The offset for pagination

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  // Get followed channels with pagination
  Future<void> getFollowedChannels(offset, {bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isInitialLoading = true;
      notifyListeners();
    } else {
      _isLoadingMore = true;
      notifyListeners();
    }

    try {
      final response = await sharedWebService.followedChannelsApi(
          offset: offset); // Pass offset to API

      if (response.status == 200) {
        if (isLoadMore) {
          // Only add new channels that aren't already in the list
          final newChannels = response.followedChannels?.where((newChannel) {
            return !channelData
                .any((existingChannel) => existingChannel.id == newChannel.id);
          }).toList();
          channelData.addAll(newChannels ?? []);
        } else {
          channelData = response.followedChannels ?? [];
        }

        // Update the postsOffset and followedChannelsPage
        postsOffset =
            channelData.length; // Update the posts offset for the next load
        followedChannelsPage++; // Increment the page number

        // Check if there are more channels to load
        if ((response.followedChannels?.length ?? 0) < 10) {
          hasMoreFollowed = false;
        }
      } else {
        // Handle no data or error response
        _isInitialLoading = false;
        if (isLoadMore) {
          _isLoadingMore = false;
        }
      }
    } catch (e) {
      print('Error fetching followed channels: $e');
    } finally {
      _isInitialLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  List<ChannelModel> popularChannelData = [];
  int popularChannelsPage = 1;
  bool hasMorePopular = true;

  // Get popular channels with pagination
  Future<void> getPopularChannels(
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
      final response = await sharedWebService.getChannels(
          offset: offset); // Pass offset to API

      if (response.status == 200) {
        if (isLoadMore) {
          // Only add new channels that aren't already in the list
          final newChannels = response.channel?.where((newChannel) {
            return !popularChannelData
                .any((existingChannel) => existingChannel.id == newChannel.id);
          }).toList();
          popularChannelData.addAll(newChannels ?? []);
        } else {
          popularChannelData = response.channel ?? [];
        }

        // Update the postsOffset and popularChannelsPage
        postsOffset = popularChannelData
            .length; // Update the posts offset for the next load
        popularChannelsPage++; // Increment the page number

        // Check if there are more channels to load
        if ((response.channel?.length ?? 0) < 10) {
          hasMorePopular = false;
        }
      } else {
        // Handle no data or error response
        _isInitialLoading = false;
        if (isLoadMore) {
          _isLoadingMore = false;
        }
      }
    } catch (e) {
      print('Error fetching popular channels: $e');
    } finally {
      _isInitialLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
