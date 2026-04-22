import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/live_stream_view_model.dart';

// Agora AppId
const appId = "03c0e7ea688a4191be2605ea71fa1e7b";

class LiveStreamScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String token;
  final int liveStreamId;
  final String channelName;
  final int creatorId;
  const LiveStreamScreen({
    super.key,
    required this.isBroadcaster,
    required this.token,
    required this.liveStreamId,
    required this.creatorId,
    required this.channelName,
  });

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _hostStatusCheckTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LiveStreamViewModel>();

      // Register the host left callback if we're a viewer
      if (!widget.isBroadcaster) {
        provider.onHostLeft = _handleHostLeft;
      }

      provider.initAgora(widget.isBroadcaster, widget.token, widget.channelName,
          widget.liveStreamId);
      provider.startPolling(widget.liveStreamId.toString());

      // Only set up the host status check for viewers
      if (!widget.isBroadcaster) {
        _setupHostStatusCheck();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.95) {
        final provider = context.read<LiveStreamViewModel>();
        if (!provider.isLoadingMore && provider.hasMoreMessages) {
          provider.getAllMessages(
            widget.liveStreamId,
            provider.postsOffset,
            isLoadMore: true,
          );
        }
      }
    });
  }

  void _setupHostStatusCheck() {
    // Check every 3 seconds if the host is still in the channel
    _hostStatusCheckTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) return;

      final provider = context.read<LiveStreamViewModel>();

      // Check if remote UIDs are empty (no host) or if the stream is not active on the server
      bool isHostGone = provider.remoteUids.isEmpty &&
          !provider.isInitializing &&
          provider.localUserJoined;
      bool isStreamActive =
          await provider.isStreamActive(widget.liveStreamId.toString());

      if (isHostGone || !isStreamActive) {
        // Host has left or stream has been ended on the server
        _hostStatusCheckTimer?.cancel();
        provider.disposeAgoraEngine();
        provider.stopPolling();

        if (mounted) {
          // Show dialog that stream has ended
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: AppColor.screenBG,
              title: CustomText(
                title: 'Stream Ended',
                color: AppColor.black,
                size: 20,
              ),
              content: CustomText(
                softWrap: true,
                title: 'The host has ended the live stream.',
                color: AppColor.black,
                size: 12,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to previous screen
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: AppColor.primaryColor),
                  ),
                ),
              ],
            ),
          );
        }
      }
    });
  }

  // Handle host left event directly from Agora callback
  void _handleHostLeft() {
    if (!mounted) return;

    final provider = context.read<LiveStreamViewModel>();
    _hostStatusCheckTimer?.cancel();
    provider.disposeAgoraEngine();
    provider.stopPolling();

    // Show dialog that stream has ended
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.screenBG,
        title: CustomText(
          title: 'Stream Ended',
          color: AppColor.black,
          size: 20,
        ),
        content: CustomText(
          softWrap: true,
          title: 'The host has ended the live stream.',
          color: AppColor.black,
          size: 12,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            child: Text(
              'OK',
              style: TextStyle(color: AppColor.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!widget.isBroadcaster) {
          final provider = context.read<LiveStreamViewModel>();
          await provider.leaveStream();
          await provider.disposeAgoraEngine();
          provider.stopPolling();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.screenBG,
        body: Stack(
          children: [
            _buildVideoView(context),
            _buildCommentsSection(),
            _buildTopControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoView(BuildContext context) {
    return Consumer<LiveStreamViewModel>(
      builder: (context, viewModel, child) {
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: double.infinity,
            height: AppConfig(context).height,
            child: Center(
              child: viewModel.isInitializing
                  ? CircularProgressIndicator(color: AppColor.primaryColor)
                  : widget.isBroadcaster
                      ? (viewModel.localUserJoined
                          ? AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: viewModel.engine!,
                                canvas: const VideoCanvas(uid: 0),
                              ),
                            )
                          : Center(
                              child: Text(
                                'Initializing broadcast...',
                                style: TextStyle(color: AppColor.primaryColor),
                              ),
                            ))
                      : (viewModel.remoteUids.isNotEmpty
                          ? AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: viewModel.engine!,
                                canvas: VideoCanvas(
                                    uid: viewModel.remoteUids.first),
                              ),
                            )
                          : Center(
                              child: Text(
                                'Waiting for host to join...',
                                style: TextStyle(color: AppColor.primaryColor),
                              ),
                            )),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopControls() {
    return Consumer<LiveStreamViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.red,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: CustomText(
                    title: 'Live',
                    color: Colors.white,
                    size: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Gap.w(20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.grey.withOpacity(.35),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.remove_red_eye,
                        size: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        title: viewModel.viewerCount.toString(),
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (widget.isBroadcaster)
                GestureDetector(
                  onTap: () async {
                    await _showEndStreamDialog(context, viewModel);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: CustomText(
                        title: 'End',
                        color: Colors.black,
                        size: 15,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEndStreamDialog(
      BuildContext context, LiveStreamViewModel viewModel) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.screenBG,
        title: CustomText(
          title: 'End Stream',
          color: AppColor.black,
          size: 20,
        ),
        content: CustomText(
          softWrap: true,
          title: 'Are you sure you want to end this live stream?',
          color: AppColor.black,
          size: 12,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await viewModel.endStream();
              await viewModel.disposeAgoraEngine();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text(
              'End Stream',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Comments list
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Consumer<LiveStreamViewModel>(
              builder: (context, viewModel, child) {
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: viewModel.commentData.length,
                  itemBuilder: (context, index) {
                    final comment = viewModel
                        .commentData[viewModel.commentData.length - 1 - index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: comment.user!.profileImage ?? '',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          'assets/images/profilePlaceholder.jpg'),
                                  placeholder: (context, url) => Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColor.primaryColor,
                                      radius: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Gap.w(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: '${comment.user!.username}',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                  CustomText(
                                    softWrap: true,
                                    title: comment.comment ?? "",
                                    fontWeight: FontWeight.w400,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Comment input field
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryTextField(
                    fillColor: AppColor.screenBG,
                    keyBoardType: TextInputType.emailAddress,
                    isPass: false,
                    borderColor: AppColor.grey,
                    textCapitalization: TextCapitalization.sentences,
                    onChange: (onChange) {},
                    hintText: 'Add a comment...',
                    textStyle: const TextStyle(
                        color: AppColor.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: "inter"),
                    errorText: LocaleKeys.emailIsRequired.tr(),
                    width: 0,
                    controller: _commentController,
                    headingText: "",
                    prefixIcon: '',
                  ),
                ),
                Gap.w(10),
                GestureDetector(
                  onTap: () {
                    final comment = _commentController.text.trim();
                    if (comment.isNotEmpty) {
                      context
                          .read<LiveStreamViewModel>()
                          .sendComment(
                            id: widget.liveStreamId.toString(),
                            context: context,
                            comment: comment,
                          )
                          .then((value) {
                        _commentController.clear();
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor.withOpacity(.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        CustomAssets.sendMessageIcon,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hostStatusCheckTimer?.cancel();
    _scrollController.dispose();
    _commentController.dispose();

    if (!widget.isBroadcaster) {
      final provider = context.read<LiveStreamViewModel>();
      provider.leaveStream();
      provider.disposeAgoraEngine();
      provider.stopPolling();
    }

    super.dispose();
  }
}
