import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "03c0e7ea688a4191be2605ea71fa1e7b";

class LiveStreamViewModel extends ChangeNotifier {
  SharedWebService sharedWebService = SharedWebService.instance();
  SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  RtcEngine? engine;
  bool localUserJoined = false;
  List<int> remoteUids = [];
  bool isInitializing = true;

  int viewerCount = 0;

  Timer? _pollingTimer;
  static const Duration pollingInterval = Duration(seconds: 5);

  String? _currentLiveStreamId;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  List<Comments> commentData = [];
  int postsOffset = 0;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMoreMessages = true;
  bool get hasMoreMessages => _hasMoreMessages;

  // Add a callback for host left event
  Function? _onHostLeft;

  // Setter for onHostLeft
  set onHostLeft(Function? callback) {
    _onHostLeft = callback;
  }

  // Getter for onHostLeft
  Function? get onHostLeft => _onHostLeft;

  Future<void> initAgora(bool isBroadcaster, String token, String channelName,
      int liveStreamId) async {
    isInitializing = true;
    notifyListeners();
    try {
      await [Permission.microphone, Permission.camera].request();
      engine = createAgoraRtcEngine();
      await engine!.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            log("local user ${connection.localUid} joined");
            localUserJoined = true;
            notifyListeners();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            log("remote user $remoteUid joined");
            if (!remoteUids.contains(remoteUid)) {
              remoteUids.add(remoteUid);
              joinStream(id: liveStreamId.toString());
            }
            notifyListeners();
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            debugPrint("remote user $remoteUid left channel");
            remoteUids.remove(remoteUid);
            notifyListeners();

            // If we're a viewer and the remoteUids is empty,
            // it means the host has left
            if (remoteUids.isEmpty && localUserJoined && _onHostLeft != null) {
              _onHostLeft!();
            }
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint("Agora Error: $err, $msg");
          },
        ),
      );
      await engine!.enableVideo();
      await engine!.startPreview();
      await engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      if (!isBroadcaster) {
        await engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
      }
      isInitializing = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error initializing Agora: $e");
      isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> disposeAgoraEngine() async {
    try {
      if (engine != null) {
        await engine?.leaveChannel();
        await engine?.release();
        engine = null;
        localUserJoined = false;
        remoteUids.clear();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error disposing Agora engine: $e");
    }
  }

  void startPolling(String liveStreamId) {
    _currentLiveStreamId = liveStreamId;
    getAllMessages(liveStreamId, 0);
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(pollingInterval, (timer) {
      _pollNewMessages();
      fetchViewerCount(id: liveStreamId);
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentLiveStreamId = null;
    commentData.clear();
    postsOffset = 0;
    _hasMoreMessages = true;
    notifyListeners();
  }

  // Poll for new messages
  Future<void> _pollNewMessages() async {
    if (_currentLiveStreamId == null) return;

    final user = await sharedPreferenceHelper.user;
    if (user == null) return;

    try {
      final response = await sharedWebService.getAllCommentsByChannelId(
        liveStreamId: _currentLiveStreamId,
      );

      if (response.status == 200 && response.commentsData != null) {
        final newMessages = response.commentsData!.where((newMsg) {
          return !commentData.any((existingMsg) => existingMsg.id == newMsg.id);
        }).toList();

        if (newMessages.isNotEmpty) {
          commentData.insertAll(0, newMessages);
          // Update last message timestamp
          if (newMessages.isNotEmpty && newMessages[0].createdAt != null) {}

          notifyListeners();
        }
      }
    } catch (error) {
      debugPrint('Error polling messages: $error');
    }
  }

  // Get all messages
  Future<void> getAllMessages(liveStreamId, offset,
      {bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isInitialLoading = true;
      notifyListeners();
    }

    if (isLoadMore) {
      _isLoadingMore = true;
      notifyListeners();
    }

    final user = await sharedPreferenceHelper.user;
    if (user != null) {
      try {
        final response = await sharedWebService.getAllCommentsByChannelId(
          liveStreamId: liveStreamId,
        );

        if (response.status == 200) {
          if (isLoadMore) {
            commentData = [...commentData, ...response.commentsData ?? []];
          } else {
            commentData = response.commentsData ?? [];
          }
          postsOffset = offset + (response.commentsData?.length ?? 0);
        }
      } catch (error) {
        debugPrint('Error fetching messages: $error');
      }
    }

    _isInitialLoading = false;
    if (isLoadMore) {
      _isLoadingMore = false;
    }
    notifyListeners();
  }

  // Send comment
  Future<void> sendComment({id, context, comment}) async {
    try {
      final response = await sharedWebService.sendComment(
        liveStreamId: id,
        comment: comment,
      );
      if (response.status == 200 &&
          response.commentsData != null &&
          response.commentsData!.isNotEmpty) {
        final newMessage = Comments(
          id: response.commentsData![0].id!,
          comment: response.commentsData![0].comment ?? "",
          createdAt: response.commentsData![0].createdAt!,
          updatedAt: response.commentsData![0].updatedAt!,
          user: response.commentsData![0].user!,
        );
        commentData.insert(0, newMessage);
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error sending message: $error');
      if (context != null) {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: const SnackbarMessage(
              content: "Failed to send comment",
              isLongMessage: false,
              isForError: true,
            ),
          );
      }
    }
  }

  //  method for ending the live stream
  Future<void> endStream(
      {String? id, BuildContext? context, String? comment}) async {
    try {
      final response = await sharedWebService.endStream(
        liveStreamId: id ?? _currentLiveStreamId!,
      );

      if (response.status == 200 && response.message.isNotEmpty) {
        viewerCount = 0;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error ending live stream message: $error');
    }
  }

  // Method for viewer to leave the stream
  Future<void> leaveStream({String? id}) async {
    try {
      final response = await sharedWebService.leaveStream(
        liveStreamId: id ?? _currentLiveStreamId!,
      );

      if (response.status == 200 && response.message.isNotEmpty) {
        // Viewer has left the stream
        viewerCount = viewerCount - 1;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error leaving live stream: $error');
    }
  }

  Future<void> joinStream({String? id}) async {
    try {
      final response = await sharedWebService.joinStream(
        liveStreamId: id ?? _currentLiveStreamId!,
      );
      if (response.status == 200 && response.message.isNotEmpty) {
        viewerCount = response.userCounts!;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error join live stream message: $error');
    }
  }

  Future<void> fetchViewerCount({id}) async {
    try {
      final response = await sharedWebService.fetchUserCount(
        liveStreamId: id,
      );
      if (response.status == 200 && response.message.isNotEmpty) {
        viewerCount = response.userCounts!;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error join live stream message: $error');
    }
  }

  // Method to check if stream is active
  Future<bool> isStreamActive(String streamId) async {
    try {
      // Use the existing fetchUserCount endpoint to check if stream is still active
      // If the stream is not active, we would expect an error or a specific response
      final response = await sharedWebService.fetchUserCount(
        liveStreamId: streamId,
      );

      if (response.status == 200) {
        // If we can still fetch viewer count, the stream is likely active
        return true;
      }
      return false;
    } catch (error) {
      debugPrint('Error checking stream status: $error');
      // If there's an error, the stream might be ended
      return false;
    }
  }

  @override
  void dispose() {
    stopPolling();
    disposeAgoraEngine();
    super.dispose();
  }
}
