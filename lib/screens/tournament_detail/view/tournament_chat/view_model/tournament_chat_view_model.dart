import 'dart:async';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class TournamentChatViewModel extends ChangeNotifier {
  SharedWebService sharedWebService = SharedWebService.instance();
  SnackbarHelper snackbarHelper = SnackbarHelper.instance();
  SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  Timer? _pollingTimer;
  static const Duration pollingInterval = Duration(seconds: 10);

  String? _currentMatchId;
  String? _currentTournamentId;
  DateTime? _lastMessageTimestamp;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  List<ChatMessage> chatData = [];
  int postsOffset = 0;
  XFile? fileDataEvent;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMoreMessages = true;
  bool get hasMoreMessages => _hasMoreMessages;

  void startPolling(String matchId, String tournamentId) {
    _currentMatchId = matchId;
    _currentTournamentId = tournamentId;

    // Get initial messages
    getAllMessages(matchId, tournamentId, 0);

    // Start polling for new messages
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(pollingInterval, (timer) {
      _pollNewMessages();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentMatchId = null;
    _currentTournamentId = null;
    _lastMessageTimestamp = null;
    chatData.clear();
    postsOffset = 0;
    _hasMoreMessages = true;
  }

  Future<void> _pollNewMessages() async {
    if (_currentMatchId == null || _currentTournamentId == null) return;

    final user = await sharedPreferenceHelper.user;
    if (user == null) return;

    try {
      final response = await sharedWebService.getAllMessage(
        tournamentId: _currentTournamentId,
        matchId: _currentMatchId,
        offset: 0,
      );
      print('1111111111111111💢💢💢💢💢💢💢11111111-------------$response');
      if (response.status == 200 && response.chatsData != null) {
        final newMessages = response.chatsData!.where((newMsg) {
          return !chatData.any((existingMsg) => existingMsg.id == newMsg.id);
        }).toList();

        if (newMessages.isNotEmpty) {
          chatData.insertAll(0, newMessages);

          // Update last message timestamp
          if (newMessages.isNotEmpty && newMessages[0].createdAt != null) {
            _lastMessageTimestamp = newMessages[0].createdAt;
          }

          notifyListeners();
        }
      }
    } catch (error) {
      debugPrint('Error polling messages: $error');
    }
  }

  Future<void> getAllMessages(matchId, tournamentId, offset,
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
        final response = await sharedWebService.getAllMessage(
            tournamentId: tournamentId, offset: offset, matchId: matchId);

        if (response.status == 200) {
          if (isLoadMore) {
            chatData = [...chatData, ...response.chatsData ?? []];
          } else {
            chatData = response.chatsData ?? [];
          }
          postsOffset = offset + (response.chatsData?.length ?? 0);
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

  Future<void> sendMessage({id, context, message, matchid}) async {
    try {
      final response = await sharedWebService.sendMessage(
          media: fileDataEvent?.path ??
              '', // Proper null check on fileDataEvent path
          tournamentId: id.toString(),
          message: message,
          matchId: matchid.toString());

      if (response.status == 200 &&
          response.chatsData != null &&
          response.chatsData!.isNotEmpty) {
        final newMessage = ChatMessage(
          id: response.chatsData![0].id!,
          fromId: response.chatsData![0].fromId!,
          toId: response.chatsData![0].toId!,
          message: response.chatsData![0].message ?? "",
          myMessage: response.chatsData![0].myMessage!,
          media: response.chatsData![0].media ?? "",
          time: response.chatsData![0].time!,
          createdAt: response.chatsData![0].createdAt!,
          updatedAt: response.chatsData![0].updatedAt!,
          tournamentId: response.chatsData![0].tournamentId!,
          user: response.chatsData![0].user!,
        );

        // Insert the new message at the beginning of the list
        chatData.insert(0, newMessage);

        // Clear the file data after successful send
        fileDataEvent = null;

        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error sending message: $error');
      // Optionally show an error message to the user
      if (context != null) {
        snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: const SnackbarMessage(
              content: "Failed to send message",
              isLongMessage: false,
              isForError: true,
            ),
          );
      }
    }
  }

  void handleImageSelection(XFile file, context, tId, mId) {
    fileDataEvent = file;
    sendMessage(
      id: tId,
      context: context,
      matchid: mId,
    );
  }
}
