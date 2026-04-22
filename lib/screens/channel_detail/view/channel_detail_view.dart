import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/screens/channel_detail/view_model/channel_detail_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

class ChannelDetailScreen extends StatefulWidget {
  final ChannelModel channelData;
  const ChannelDetailScreen({super.key, required this.channelData});

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  @override
  void initState() {
    final channelVm =
        Provider.of<ChannelDetailViewModel>(context, listen: false);
    channelVm.getChannelData(widget.channelData.id.toString());
    channelVm.getUserFromSharedPref();
    channelVm.getLiveStreamsByChannelId(widget.channelData.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(
        title: LocaleKeys.channelDetail.tr(),
      ),
      body: Consumer<ChannelDetailViewModel>(
        builder: (context, channelVm, child) {
          if (channelVm.channelData != null) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Channel Header Image
                      if (channelVm.channelData!.header != null)
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: channelVm.channelData!.header ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Image.asset(CustomAssets.placeholder),
                              placeholder: (context, url) => Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColor.primaryColor,
                                  radius: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (channelVm.channelData!.logo != null)
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: channelVm.channelData!.logo ?? '',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(CustomAssets.placeholder),
                                  placeholder: (context, url) => Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColor.primaryColor,
                                      radius: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  txtOverFlow: TextOverflow.fade,
                                  title: channelVm.channelData!.name.toString(),
                                  size: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black,
                                ),
                                const SizedBox(height: 2),
                                CustomText(
                                  title:
                                      "${channelVm.channelData!.followerCount} ${LocaleKeys.subscribed.tr()}",
                                  size: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.grey,
                                ),
                              ],
                            ),
                          ),
                          if (channelVm.userData!.id !=
                              channelVm.channelData!.userId) ...[
                            channelVm.channelData!.subscribed == 0
                                ? Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        channelVm.subscribeChannel(
                                            channelVm.channelData!.id!,
                                            context);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColor.primaryColor,
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            title: LocaleKeys.subscribe.tr(),
                                            color: Colors.white,
                                            size: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        channelVm.subscribeChannel(
                                            channelVm.channelData!.id!,
                                            context);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor.primaryColor),
                                          color: AppColor.screenBG,
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            title: LocaleKeys.unSubscribe.tr(),
                                            color: AppColor.black,
                                            size: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ] else ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyRoutes.createLiveStreamForm,
                                        arguments: [
                                          channelVm.channelData!.id.toString(),
                                          channelVm.channelData!.name.toString()
                                        ]);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        title: LocaleKeys.goLive.tr(),
                                        color: Colors.white,
                                        size: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (channelVm.channelData!.description != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HtmlWidget(
                            '<p style="text-align: justify;">${channelVm.channelData!.description!}</p>',
                            renderMode: RenderMode.column,
                            textStyle:
                                TextStyle(fontSize: 14, color: AppColor.black),
                          ),
                        ),
                      Gap.h(10),
                      channelVm.channelStreams != null &&
                              channelVm.channelStreams!.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: CustomText(
                                title: LocaleKeys.liveStream.tr(),
                                size: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            )
                          : const SizedBox(),
                      Gap.h(10),
                      channelVm.channelStreams != null &&
                              channelVm.channelStreams!.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: channelVm.channelStreams!.length,
                                itemBuilder: (context, index) {
                                  final stream =
                                      channelVm.channelStreams![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        MyRoutes.liveStreamScreen,
                                        arguments: [
                                          stream.id,
                                          stream.userId,
                                          false,
                                          stream.agoraToken,
                                          stream.agoraChannelName,
                                        ],
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColor.screenBG,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Thumbnail
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: stream.thumbnail ?? '',
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color: AppColor.primaryColor,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Stream Title
                                                CustomText(
                                                  title: stream.title ?? '',
                                                  size: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.black,
                                                ),

                                                const SizedBox(height: 8),
                                                // Stream Status
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                      title: stream.status![0]
                                                              .toUpperCase() +
                                                          stream.status!
                                                              .substring(1),
                                                      size: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColor.red,
                                                    ),
                                                    Gap.w(4),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 3),
                                                      child: Container(
                                                        height: 6,
                                                        width: 6,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: AppColor
                                                                    .red,
                                                                shape: BoxShape
                                                                    .circle),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(
                color: AppColor.primaryColor,
                radius: 20,
              ),
            );
          }
        },
      ),
    );
  }
}
