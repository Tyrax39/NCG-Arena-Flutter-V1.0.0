import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/followed_channels/view_model/followed_channels_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class FollowedChannels extends StatefulWidget {
  const FollowedChannels({super.key});

  @override
  State<FollowedChannels> createState() => _FollowedChannelsState();
}

class _FollowedChannelsState extends State<FollowedChannels> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<FollowedChannelsViewModel>(context, listen: false);
      viewModel.getFollowedChannels(isLoadMore: true, viewModel.postsOffset);
      viewModel.getPopularChannels(isLoadMore: true, viewModel.postsOffset);
    });

    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final viewModel =
        Provider.of<FollowedChannelsViewModel>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!viewModel.isLoadingMore) {
        if (viewModel.channelData.isNotEmpty && viewModel.hasMoreFollowed) {
          viewModel.getFollowedChannels(
              isLoadMore: true, viewModel.postsOffset);
        } else if (viewModel.popularChannelData.isNotEmpty &&
            viewModel.hasMorePopular) {
          viewModel.getPopularChannels(isLoadMore: true, viewModel.postsOffset);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowedChannelsViewModel>(
        builder: (context, channelVm, child) {
      if (channelVm.channelData.isEmpty &&
          channelVm.popularChannelData.isEmpty &&
          !channelVm.isInitialLoading) {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(
              title: channelVm.channelData.isNotEmpty
                  ? LocaleKeys.followedChannels.tr()
                  : LocaleKeys.popularChannels.tr()),
          body: Center(
            child: Text(
              LocaleKeys.noChannelsAvailable.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.black,
              ),
            ),
          ),
        );
      } else if (channelVm.isInitialLoading) {
        // Show loader while data is being fetched
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          body: Center(
              child: CupertinoActivityIndicator(
            color: AppColor.primaryColor,
            radius: 20,
          )),
        );
      } else {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(
              title: channelVm.channelData.isNotEmpty
                  ? LocaleKeys.followedChannels.tr()
                  : LocaleKeys.popularChannels.tr()),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: (channelVm.channelData.isNotEmpty
                              ? channelVm.channelData.length
                              : channelVm.popularChannelData.length) +
                          (channelVm.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >=
                            (channelVm.channelData.isNotEmpty
                                ? channelVm.channelData.length
                                : channelVm.popularChannelData.length)) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CupertinoActivityIndicator(
                                color: AppColor.primaryColor,
                                radius: 12,
                              ),
                            ),
                          );
                        }

                        final followedChannel = channelVm.channelData.isNotEmpty
                            ? channelVm.channelData[index]
                            : channelVm.popularChannelData[index];
                        return GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(
                                context, MyRoutes.channelDetailScreen,
                                arguments: followedChannel);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.screenBG,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                followedChannel.logo ?? '',
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    CustomAssets.placeholder),
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CupertinoActivityIndicator(
                                                color: AppColor.primaryColor,
                                                radius: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            title: followedChannel.name ?? 'Unknown Channel',
                                            color: AppColor.black,
                                            size: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          Gap.h(5),
                                          Row(
                                            children: [
                                              CustomText(
                                                title: followedChannel
                                                                .followerCount ==
                                                            0 ||
                                                        followedChannel
                                                                .followerCount ==
                                                            1
                                                    ? "${followedChannel.followerCount.toString()} ${LocaleKeys.subscriber.tr()}"
                                                    : "${followedChannel.followerCount.toString()} ${LocaleKeys.subscribers.tr()}",
                                                color: AppColor.black,
                                                size: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
