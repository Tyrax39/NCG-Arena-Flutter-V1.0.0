import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/main/components/slider.dart';
import 'package:neoncave_arena/screens/main/view_model/main_screen_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String key_title = "/home_navigation_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final homeProvider = context.read<MainScreenProvider>();
    homeProvider.getFollowedChannels(context);
    homeProvider.getTournament(context);
    homeProvider.getFollowedOrganization(context);
    homeProvider.getPopularOrganization(context);
    homeProvider.getPopularChannels(context);
    homeProvider.getBanners();
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
                  Image.asset(
                    AppBranding.headerLogo,
                    width: AppConfig(context).width * 0.42,
                    fit: BoxFit.contain,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap.h(20),
                      Consumer<MainScreenProvider>(
                          builder: (context, mainVm, child) {
                        return CarosalSlider(bannerData: mainVm.bannersData);
                      }),
                      // Modern Floating Action Cards Layout
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildFloatingActionCard(
                                  context: context,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyRoutes.createTournament);
                                  },
                                  icon: CustomAssets.createTournamentIcon,
                                  title: LocaleKeys.create.tr(),
                                  subtitle: LocaleKeys.tournament.tr(),
                                  primaryColor: AppColor.primaryColor,
                                  isPrimary: false,
                                ),
                              ),
                              Gap.w(12),
                              Expanded(
                                child: _buildFloatingActionCard(
                                  context: context,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyRoutes.myTournaments);
                                  },
                                  icon: CustomAssets.myTournamentIcon,
                                  title: LocaleKeys.my.tr(),
                                  subtitle: LocaleKeys.tournaments.tr(),
                                  primaryColor: AppColor.blue,
                                  isPrimary: false,
                                ),
                              ),
                              Gap.w(12),
                              Expanded(
                                child: _buildFloatingActionCard(
                                  context: context,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyRoutes.createOrganization);
                                  },
                                  icon: CustomAssets.createOrganizationIcon,
                                  title: LocaleKeys.create.tr(),
                                  subtitle: LocaleKeys.organizations.tr(),
                                  primaryColor: AppColor.green,
                                  isPrimary: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Gap.h(20),
                      Consumer<MainScreenProvider>(
                          builder: (context, homeVm, child) {
                        return homeVm.channelData.isNotEmpty ||
                                homeVm.popularChannelData.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MyRoutes.followedChannels);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      title: homeVm.channelData.isNotEmpty
                                          ? LocaleKeys.followedChannels.tr()
                                          : LocaleKeys.popularChannels.tr(),
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
                              )
                            : const SizedBox();
                      }),
                      Consumer<MainScreenProvider>(
                          builder: (context, homeVm, child) {
                        return SizedBox(
                          height: 140,
                          child: ListView.builder(
                              padding: const EdgeInsets.only(left: 0),
                              scrollDirection: Axis.horizontal,
                              itemCount: homeVm.channelData.isNotEmpty
                                  ? homeVm.channelData.length
                                  : homeVm.popularChannelData.length,
                              itemBuilder: (context, index) {
                                var channelData = homeVm.channelData.isNotEmpty
                                    ? homeVm.channelData[index]
                                    : homeVm.popularChannelData[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              MyRoutes.channelDetailScreen,
                                              arguments: channelData);
                                        },
                                        child: channelData.logo != null
                                            ? Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.black12,
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
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CupertinoActivityIndicator(
                                                        color: AppColor
                                                            .primaryColor,
                                                        radius: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.black12,
                                                )),
                                      ),
                                      Gap.h(10),
                                      SizedBox(
                                        width: 80,
                                        child: CustomText(
                                          alignment: TextAlign.center,
                                          title: channelData.name.toString(),
                                          color: AppColor.black,
                                          size: 13,
                                          maxLines: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      }),
                      Gap.h(5),
                      Consumer<MainScreenProvider>(
                          builder: (context, homeVm, child) {
                        return homeVm.followedOrganizationData.isNotEmpty ||
                                homeVm.popularOrganizationData.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MyRoutes.followedOrganization);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      title: homeVm.followedOrganizationData
                                              .isNotEmpty
                                          ? LocaleKeys.followedOrganizations
                                              .tr()
                                          : LocaleKeys.popularOrganizations
                                              .tr(),
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
                              )
                            : const SizedBox();
                      }),
                      Gap.h(15),
                      Consumer<MainScreenProvider>(
                          builder: (context, homeVm, child) {
                        return SizedBox(
                          height: 175,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  homeVm.followedOrganizationData.isNotEmpty
                                      ? homeVm.followedOrganizationData.length
                                      : homeVm.popularOrganizationData.length,
                              itemBuilder: (context, index) {
                                var organizationData =
                                    homeVm.followedOrganizationData.isNotEmpty
                                        ? homeVm.followedOrganizationData[index]
                                        : homeVm.popularOrganizationData[index];
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
                      Gap.h(12),
                      Consumer<MainScreenProvider>(
                          builder: (context, homeVm, child) {
                        return homeVm.allTournamentData.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MyRoutes.allTournamentView);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      title:
                                          LocaleKeys.upcomingTournaments.tr(),
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
                              )
                            : const SizedBox();
                      }),
                      Gap.h(10),
                      Consumer<MainScreenProvider>(
                          builder: (context, homeVm, child) {
                        return homeVm.allTournamentData.isNotEmpty
                            ? Container(
                                color: AppColor.screenBG,
                                height: 320,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homeVm.allTournamentData.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final tournament =
                                        homeVm.allTournamentData[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.pushNamed(
                                          context,
                                          MyRoutes.tournamentDetailScreen,
                                          arguments: tournament,
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        width: AppConfig(context).width * 0.75,
                                        decoration: BoxDecoration(
                                          color: AppColor.offwhite,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.black12,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        tournament.banner!,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      CustomAssets.placeholder,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CupertinoActivityIndicator(
                                                        color: AppColor
                                                            .primaryColor,
                                                        radius: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                      title:
                                                          tournament.gameName ??
                                                              '',
                                                      color:
                                                          AppColor.primaryColor,
                                                      size: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      maxLines: 1,
                                                    ),
                                                    Gap.h(3),
                                                    CustomText(
                                                      title: tournament.name
                                                          .toString(),
                                                      color: AppColor.black,
                                                      size: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      maxLines: 2,
                                                    ),
                                                    Gap.h(3),
                                                    CustomText(
                                                      title: 'Hosted By:',
                                                      color: AppColor.black,
                                                      size: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      maxLines: 1,
                                                    ),
                                                    CustomText(
                                                      title: tournament
                                                              .organization!
                                                              .name ??
                                                          '',
                                                      color:
                                                          AppColor.primaryColor,
                                                      size: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      maxLines: 1,
                                                    ),
                                                    Gap.h(5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .calendar_today,
                                                                color: AppColor
                                                                    .primaryColor,
                                                                size: 10,
                                                              ),
                                                              Gap.w(3),
                                                              Flexible(
                                                                child:
                                                                    CustomText(
                                                                  title: DateFormat(
                                                                          'MMM dd')
                                                                      .format(tournament
                                                                          .dateIni!),
                                                                  color: AppColor
                                                                      .black,
                                                                  size: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Image.asset(
                                                                CustomAssets
                                                                    .prizeIcon,
                                                                height: 10,
                                                                color: AppColor
                                                                    .primaryColor,
                                                              ),
                                                              Gap.w(3),
                                                              Flexible(
                                                                child:
                                                                    CustomText(
                                                                  title: tournament
                                                                              .isReward ==
                                                                          0
                                                                      ? 'No Prize'
                                                                      : '\$${tournament.totalReward}',
                                                                  color: AppColor
                                                                      .black,
                                                                  size: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox();
                      }),
                      Gap.h(10),
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

  // Gaming-style Action Card Builder - Similar to Profile Stats
  Widget _buildFloatingActionCard({
    required BuildContext context,
    required VoidCallback onTap,
    required String icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: isPrimary ? 16 : 12, horizontal: isPrimary ? 16 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: isPrimary
            ? Row(
                children: [
                  // Large icon container for primary card
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        icon,
                        height: 24,
                        width: 24,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Gap.w(12),
                  // Text content for primary card
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          title: title,
                          color: AppColor.black,
                          size: 16,
                          fontWeight: FontWeight.bold,
                          maxLines: 1,
                        ),
                        Gap.h(2),
                        CustomText(
                          title: subtitle,
                          color: AppColor.greyText,
                          size: 11,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  // Icon container for secondary cards
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      icon,
                      height: 20,
                      width: 20,
                      color: primaryColor,
                    ),
                  ),
                  Gap.h(8),
                  // Text content for secondary cards
                  CustomText(
                    title: title,
                    color: AppColor.black,
                    size: 16,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    alignment: TextAlign.center,
                  ),
                  Gap.h(2),
                  CustomText(
                    title: subtitle,
                    color: AppColor.greyText,
                    size: 11,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
