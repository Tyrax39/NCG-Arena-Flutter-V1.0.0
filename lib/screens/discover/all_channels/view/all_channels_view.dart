import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/discover/all_channels/view_model/all_channels_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class AllChannels extends StatefulWidget {
  const AllChannels({super.key});

  @override
  State<AllChannels> createState() => _AllChannelsState();
}

class _AllChannelsState extends State<AllChannels> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<AllChannelsViewModel>(context, listen: false);
      viewModel.getChannels(isLoadMore: true, viewModel.postsOffset);
    });

    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final viewModel = Provider.of<AllChannelsViewModel>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!viewModel.isLoadingMore) {
        viewModel.getChannels(isLoadMore: true, viewModel.postsOffset);
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
    return Consumer<AllChannelsViewModel>(builder: (context, channelVm, child) {
      if (channelVm.channelData.isEmpty && !channelVm.isInitialLoading) {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(title: LocaleKeys.liveChannelsYouMayLike.tr()),
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
          appBar: CommonAppBar(title: LocaleKeys.liveChannelsYouMayLike.tr()),
          body: SafeArea(
            child: Consumer<AllChannelsViewModel>(
                builder: (context, discoverVm, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Consumer<AllChannelsViewModel>(
                    builder: (context, discoverVm, child) {
                  return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: (channelVm.channelData.length) +
                          (channelVm.isLoadingMore ? 1 : 0),
                      // itemCount: discoverVm.channelData.length,
                      itemBuilder: (context, index) {
                        if (index >= (channelVm.channelData.length)) {
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
                        var channelData = discoverVm.channelData[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: AppColor.offwhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyRoutes.channelDetailScreen,
                                        arguments: channelData);
                                  },
                                  child: Container(
                                    height: 160,
                                    width: AppConfig(context).width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: channelData.header!,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                CustomAssets.placeholder),
                                        placeholder: (context, url) => Center(
                                          child: CupertinoActivityIndicator(
                                            color: AppColor.primaryColor,
                                            radius: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: channelData.logo!,
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
                                      Gap.w(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            title: channelData.name.toString(),
                                            color: AppColor.black,
                                            size: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          Gap.h(3),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.people,
                                                size: 16,
                                                color: AppColor.primaryColor,
                                              ),
                                              Gap.w(8),
                                              CustomText(
                                                title: channelData
                                                                .followerCount ==
                                                            1 ||
                                                        channelData
                                                                .followerCount ==
                                                            0
                                                    ? "${channelData.followerCount.toString()} ${LocaleKeys.subscriber.tr()}"
                                                    : "${channelData.followerCount.toString()} ${LocaleKeys.subscribers.tr()}",
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
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
              );
            }),
          ),
        );
      }
    });
  }
}
