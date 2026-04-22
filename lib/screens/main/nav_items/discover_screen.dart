import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/main/view_model/main_screen_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  static const String key_title = "/discover_navigation_screen";

  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    final discoverVm = context.read<MainScreenProvider>();
    discoverVm.getGames(context);
    discoverVm.getPopularOrganization(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(builder: (context, mainVm, child) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Gap.h(20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context
                          .read<MainScreenProvider>()
                          .updateBottomNavIndex(0);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          AppBranding.headerLogo,
                          width: AppConfig(context).width * 0.42,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutes.notificationsView);
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColor.border,
                        ),
                      ),
                      child: Image.asset(
                        CustomAssets.notificationIcon,
                        color: AppColor.primaryColor,
                        scale: 3.5,
                      ),
                    ),
                  ),
                ],
              ),
              Gap.h(30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PrimaryTextField(
                        isPass: false,
                        readOnly: true,
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutes.searchScreen);
                        },
                        onChange: (context) {},
                        hintText: LocaleKeys.searchForUserOrganizationText.tr(),
                        textStyle:
                            const TextStyle(fontSize: 12, color: AppColor.grey),
                        errorText: '',
                        prefixIcon: 'assets/images/Search.png',
                        width: AppConfig(context).width,
                        controller: TextEditingController(),
                        headingText: '',
                      ),
                      Gap.h(20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutes.allChannels);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: LocaleKeys.liveChannelsYouMayLike.tr(),
                              color: AppColor.black,
                              size: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColor.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      Gap.h(20),
                      Consumer<MainScreenProvider>(
                          builder: (context, discoverVm, child) {
                        return SizedBox(
                          height: 230,
                          child: ListView.builder(
                              padding: const EdgeInsets.only(left: 0),
                              scrollDirection: Axis.horizontal,
                              itemCount: discoverVm.popularChannelData.length,
                              itemBuilder: (context, index) {
                                var channelData =
                                    discoverVm.popularChannelData[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    color: AppColor.offwhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              MyRoutes.channelDetailScreen,
                                              arguments: channelData);
                                        },
                                        child: SizedBox(
                                          height: 160,
                                          width: AppConfig(context).width * .78,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10)),
                                            child: CachedNetworkImage(
                                              imageUrl: channelData.header!,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      CustomAssets.placeholder),
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color: AppColor.primaryColor,
                                                  radius: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap.h(10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
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
                                                      Image.asset(CustomAssets
                                                          .placeholder),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      color:
                                                          AppColor.primaryColor,
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
                                                  title: channelData.name
                                                      .toString(),
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
                                                      color:
                                                          AppColor.primaryColor,
                                                    ),
                                                    Gap.w(4),
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
                                                      size: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                );
                              }),
                        );
                      }),
                      Gap.h(20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyRoutes.allOrganizations);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: LocaleKeys.organizationsYouMayLike.tr(),
                              color: AppColor.black,
                              size: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColor.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      Gap.h(20),
                      Consumer<MainScreenProvider>(
                          builder: (context, discoverVm, child) {
                        return SizedBox(
                          height: 180,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  discoverVm.popularOrganizationData.length,
                              itemBuilder: (context, index) {
                                var organizationData =
                                    discoverVm.popularOrganizationData[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    color: AppColor.offwhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                MyRoutes.organizationDetail,
                                                arguments: organizationData);
                                          },
                                          child: Container(
                                            height: 120,
                                            width:
                                                AppConfig(context).width * .37,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              color: Colors.black12,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    organizationData.logo!,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(CustomAssets
                                                            .placeholder),
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    color:
                                                        AppColor.primaryColor,
                                                    radius: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap.h(10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                title: organizationData.name
                                                    .toString(),
                                                size: 14,
                                                fontWeight: FontWeight.w500,
                                                maxLines: 2,
                                                color: AppColor.black,
                                              ),
                                              Gap.h(3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.people,
                                                    size: 16,
                                                    color:
                                                        AppColor.primaryColor,
                                                  ),
                                                  Gap.w(4),
                                                  CustomText(
                                                    title:
                                                        "${organizationData.followersCount} ${LocaleKeys.followers.tr()}",
                                                    size: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.black,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      }),
                      Gap.h(10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutes.allGames);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: LocaleKeys.popularGames.tr(),
                              color: AppColor.black,
                              size: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColor.primaryColor,
                            )
                          ],
                        ),
                      ),
                      Gap.h(20),
                      Consumer<MainScreenProvider>(
                          builder: (context, provider, child) {
                        return SizedBox(
                          height: 180,
                          child: ListView.builder(
                              padding: const EdgeInsets.only(left: 0),
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.gameData.length,
                              itemBuilder: (context, index) {
                                var gameData = provider.gameData[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MyRoutes.gameDetailView,
                                          arguments: gameData);
                                    },
                                    child: Container(
                                      width: AppConfig(context).width *
                                          0.37, // Set a fixed width to prevent overflow
                                      decoration: BoxDecoration(
                                        color: AppColor.offwhite,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            // Use Expanded to prevent overflow
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    gameData.gameImage ?? "",
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  CustomAssets.placeholder,
                                                ),
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    color:
                                                        AppColor.primaryColor,
                                                    radius: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Gap.h(10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: CustomText(
                                              title: gameData.gameName ?? '',
                                              maxLines: 2,
                                              color: AppColor.black,
                                              size: 14,
                                              fontWeight: FontWeight.w600,
                                              txtOverFlow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Gap.h(10),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }),
                      Gap.h(20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
