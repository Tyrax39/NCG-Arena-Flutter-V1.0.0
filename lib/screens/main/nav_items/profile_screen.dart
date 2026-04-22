import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/main/view_model/main_screen_view_model.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String key_title = "/profile_navigation_screen";
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<MainScreenProvider>().getUserFromSharedPref();
    context.read<MainScreenProvider>().getCurrentUserPosts();
    context.read<MainScreenProvider>().getUserFromApi();
    context.read<MainScreenProvider>().tournamentHistoryApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(builder: (context, mainVm, child) {
      return SafeArea(
          child: Column(
        children: [
          Gap.h(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<MainScreenProvider>().updateBottomNavIndex(0);
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
                      'assets/images/bell.png',
                      color: AppColor.primaryColor,
                      scale: 3.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap.h(20),
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(child: Consumer<MainScreenProvider>(
                  builder: (context, profileVm, child) {
                return profileVm.userDataFromApi != null
                    ? Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 170,
                                width: double.infinity,
                                child: cacheImageView(
                                    image:
                                        profileVm.userDataFromApi!.cover ?? ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 80),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: AppConfig(context).height * .15,
                                      width: AppConfig(context).width * .28,
                                      decoration: BoxDecoration(
                                        color: AppColor.lightgrey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: cacheImageView(
                                              image: profileVm.userDataFromApi!
                                                      .profileImage ??
                                                  '')),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: AppConfig(context).width * .6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Wrap(
                                            spacing: 10.0,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              CustomText(
                                                title:
                                                    "${profileVm.userDataFromApi!.firstName} ${profileVm.userDataFromApi!.lastName}",
                                                size: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.black,
                                                maxLines: 2,
                                                alignment: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          CustomText(
                                            title:
                                                "${profileVm.userDataFromApi!.username}",
                                            size: 15,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.black,
                                            maxLines: 2,
                                            alignment: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            title:
                                                "${profileVm.userDataFromApi!.postCount}",
                                            size: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomText(
                                            title: LocaleKeys.posts.tr(),
                                            size: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: AppColor.black,
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            title:
                                                "${profileVm.userDataFromApi!.followerCount}",
                                            size: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomText(
                                            title: LocaleKeys.followers.tr(),
                                            size: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: AppColor.black,
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            title:
                                                "${profileVm.userDataFromApi!.followingCount}",
                                            size: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomText(
                                            title: LocaleKeys.following.tr(),
                                            size: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                    MyRoutes.createPortfolio)
                                                .then((value) {
                                              profileVm.getCurrentUserPosts();
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: AppColor.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color:
                                                        AppColor.primaryColor,
                                                  )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    Gap.w(10),
                                                    CustomText(
                                                      title: LocaleKeys
                                                          .addPortfolio
                                                          .tr(),
                                                      size: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                      Gap.w(10),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                    MyRoutes.editProfileView)
                                                .then((value) {
                                              profileVm.getUserFromApi();
                                              profileVm.getUserFromSharedPref();
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: AppColor.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color:
                                                        AppColor.primaryColor,
                                                  )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    Gap.w(10),
                                                    CustomText(
                                                      title: LocaleKeys
                                                          .editProfile
                                                          .tr(),
                                                      size: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: AppConfig(context).width,
                                    decoration: const BoxDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (profileVm
                                                  .userDataFromApi!.about !=
                                              null)
                                            if (profileVm.userData!.about !=
                                                null)
                                              Text(
                                                  profileVm.userData!.about ??
                                                      "",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppColor.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(color: AppColor.border),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyRoutes.tournamentHistory);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        title:
                                            LocaleKeys.tournamentHistory.tr(),
                                        size: 15,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.primaryColor,
                                        alignment: TextAlign.center,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: AppColor.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                                Consumer<MainScreenProvider>(
                                  builder: (context, profileVm, child) {
                                    final tournamentData =
                                        profileVm.tournamentHistory;
                                    if (profileVm.isLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (tournamentData.isEmpty) {
                                      return Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 30),
                                            Icon(
                                              Icons.emoji_events_outlined,
                                              color: AppColor.black,
                                              size: 40,
                                            ),
                                            const SizedBox(height: 5),
                                            CustomText(
                                              title: LocaleKeys
                                                  .noTournamentHistory
                                                  .tr(),
                                              size: 15,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              alignment: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            CustomText(
                                              title: LocaleKeys
                                                  .thereAreCurrentlyNoTournaments
                                                  .tr(),
                                              size: 11,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.black,
                                              alignment: TextAlign.center,
                                            ),
                                            const SizedBox(height: 30),
                                          ],
                                        ),
                                      );
                                    }
                                    // Display only the first tournament
                                    final tournament = tournamentData[0];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            MyRoutes.tournamentDetailScreen,
                                            arguments: tournament);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 80,
                                              width: 100,
                                              child: CachedNetworkImage(
                                                imageUrl: tournament.banner!,
                                                fit: BoxFit.contain,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
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
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    tournament.name ?? "",
                                                    style: TextStyle(
                                                      color: AppColor.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "inter",
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    tournament.gameName ?? "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: AppColor.black,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "inter",
                                                    ),
                                                  ),
                                                  Text(
                                                    tournament.description ??
                                                        "",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: AppColor.black,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "inter",
                                                    ),
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
                                Divider(
                                  color: AppColor.border,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Consumer<MainScreenProvider>(
                                    builder: (context, value, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          value.setSelectedTabIndex(0);
                                        },
                                        child: SizedBox(
                                          width: AppConfig(context).width * .4,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.collections,
                                                  size: 15,
                                                  color:
                                                      value.selectedTabIndex == 0
                                                          ? AppColor
                                                              .primaryColor
                                                          : AppColor.black,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  LocaleKeys.posts.tr(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        value.selectedTabIndex ==
                                                                0
                                                            ? AppColor
                                                                .primaryColor
                                                            : AppColor.black,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          value.setSelectedTabIndex(1);
                                        },
                                        child: SizedBox(
                                          width: AppConfig(context).width * .4,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.video_collection,
                                                  size: 15,
                                                  color:
                                                      value.selectedTabIndex == 1
                                                          ? AppColor
                                                              .primaryColor
                                                          : AppColor.black,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  LocaleKeys.reels.tr(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        value.selectedTabIndex ==
                                                                1
                                                            ? AppColor
                                                                .primaryColor
                                                            : AppColor.black,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                const SizedBox(
                                  height: 2,
                                ),
                                Divider(color: AppColor.border),
                                Gap.h(10),
                                Consumer<MainScreenProvider>(
                                  builder: (context, value, child) {
                                    return value.selectedTabIndex == 0
                                        ? Portfolio()
                                        : value.selectedTabIndex == 1
                                            ? VideoList()
                                            : const SizedBox();
                                  },
                                ),
                                const SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox();
              })),
            ),
          ),
        ],
      ));
    });
  }
}

//////////////    Portfolio class   ///////////////

class Portfolio extends StatefulWidget {
  const Portfolio({
    super.key,
  });

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(
      builder: (context, profileVm, child) {
        if (profileVm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileVm.userImagesList.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Icon(Icons.work, color: AppColor.black),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  LocaleKeys.noPostsFound.tr(),
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: "inter",
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  LocaleKeys.thereAreCurrentlyNoPosts.tr(),
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    fontFamily: "inter",
                  ),
                )
              ],
            ),
          );
        }

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: profileVm.userImagesList.map((image) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.imageScreen, arguments: [
                  image.media,
                  image.title,
                ]);
              },
              child: Stack(children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) -
                      20, // 2-column layout
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: Colors.grey[300],
                    image: image.media.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(image.media), // Image from API
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    profileVm.deletePortfolioItem(image.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.greyText.withOpacity(.5),
                      ),
                      child: const Icon(Icons.delete_rounded,
                          color: AppColor.red, size: 20),
                    ),
                  ),
                ),
              ]),
            );
          }).toList(),
        );
      },
    );
  }
}

class VideoList extends StatefulWidget {
  VideoList({
    Key? key,
  });
  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(
      builder: (context, profileVm, child) {
        if (profileVm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileVm.userVideoList.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Icon(Icons.work, color: AppColor.black),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  LocaleKeys.noReelsFound.tr(),
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: "inter",
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  LocaleKeys.thereAreCurrentlyNoReels.tr(),
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    fontFamily: "inter",
                  ),
                )
              ],
            ),
          );
        }

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: profileVm.userVideoList.map((image) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.videoDetail, arguments: [
                  image.media,
                  image.title,
                ]);
              },
              child: Stack(children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) -
                      20, // 2-column layout
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: Colors.grey[300],
                    image: image.media.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(image.media), // Image from API
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    profileVm.deletePortfolioItem(image.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.greyText.withOpacity(.5),
                      ),
                      child: const Icon(Icons.delete_rounded,
                          color: AppColor.red, size: 20),
                    ),
                  ),
                ),
              ]),
            );
          }).toList(),
        );
      },
    );
  }
}
