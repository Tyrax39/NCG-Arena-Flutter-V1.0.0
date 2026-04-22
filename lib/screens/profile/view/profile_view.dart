import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/screens/profile/view_model/profile_view_model.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    context.read<ProfileViewModel>().getUserFromSharedPref();
    context.read<ProfileViewModel>().getUserData(widget.userId);
    context.read<ProfileViewModel>().getCurrentUserPosts(userId: widget.userId);
    context.read<ProfileViewModel>().getTournamentHistory(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.screenBG,
        appBar: CommonAppBar(title: LocaleKeys.profile.tr()),
        body: Consumer<ProfileViewModel>(builder: (context, profileVm, child) {
          return profileVm.userData != null &&
                  profileVm.currentUserData!.id != null
              ? RefreshIndicator(
                  onRefresh: () async {
                    await profileVm.refreshPortfolioData(widget.userId);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                    children: [
                      Gap.h(20),
                      // Modern Banner with overlapping profile picture
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Banner
                          Container(
                            height: 150,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: profileVm.userData!.cover != null &&
                                          profileVm.userData!.cover!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              profileVm.userData!.cover!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  gradient: profileVm.userData!.cover == null ||
                                          profileVm.userData!.cover!.isEmpty
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColor.primaryColor
                                                .withOpacity(0.8),
                                            AppColor.primaryColor
                                                .withOpacity(0.6),
                                            AppColor.black.withOpacity(0.8),
                                          ],
                                        )
                                      : null,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        AppColor.black.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Profile Picture positioned to overlap banner and content
                          Positioned(
                            bottom: -50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColor.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.black.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: AppColor.lightgrey,
                                  child: ClipOval(
                                    child: cacheImageView(
                                      image: profileVm.userData!.profileImage ??
                                          '',
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      // Gaming-style User Info Section
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Username with gaming style
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.primaryColor.withOpacity(0.1),
                                    AppColor.primaryColor.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppColor.primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: CustomText(
                                title: "@${profileVm.userData!.username}",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryColor,
                                alignment: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Full name
                            CustomText(
                              title:
                                  "${profileVm.userData!.firstName} ${profileVm.userData!.lastName}",
                              size: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                              alignment: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            // Gaming-style Stats Section
                            Row(
                              children: [
                                Expanded(
                                  child: buildStatCard(
                                    icon: Icons.collections,
                                    value: "${profileVm.userData!.postCount}",
                                    label: LocaleKeys.posts.tr(),
                                    color: AppColor.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: buildStatCard(
                                    icon: Icons.people,
                                    value:
                                        "${profileVm.userData!.followerCount}",
                                    label: LocaleKeys.followers.tr(),
                                    color: AppColor.green,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: buildStatCard(
                                    icon: Icons.person_add,
                                    value:
                                        "${profileVm.userData!.followingCount}",
                                    label: LocaleKeys.following.tr(),
                                    color: AppColor.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Gaming-style Action Buttons
                            profileVm.userData!.id ==
                                    profileVm.currentUserData!.id
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: buildGamingButton(
                                          icon: Icons.add_circle_outline,
                                          label: LocaleKeys.addPortfolio.tr(),
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                MyRoutes.createPortfolio);
                                          },
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColor.primaryColor,
                                              AppColor.primaryColor
                                                  .withOpacity(0.8)
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: buildGamingButton(
                                          icon: Icons.edit_outlined,
                                          label: LocaleKeys.editProfile.tr(),
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                    MyRoutes.editProfileView)
                                                .then((value) {
                                              profileVm.getUserFromSharedPref();
                                            });
                                          },
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColor.primaryColor,
                                              AppColor.primaryColor,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : profileVm.userData!.isFollowing == 0
                                    ? Center(
                                        child: buildGamingButton(
                                          icon: Icons.person_add,
                                          label: LocaleKeys.follow.tr(),
                                          onTap: () {
                                            profileVm.followUser(
                                                profileVm.userData?.id ?? 0,
                                                context);
                                          },
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColor.primaryColor,
                                              AppColor.primaryColor
                                                  .withOpacity(0.8)
                                            ],
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: buildGamingButton(
                                          icon: Icons.person_remove,
                                          label: LocaleKeys.unfollow.tr(),
                                          onTap: () {
                                            profileVm.followUser(
                                                profileVm.userData?.id ?? 0,
                                                context);
                                          },
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColor.lightgrey,
                                              AppColor.lightgrey,
                                            ],
                                          ),
                                        ),
                                      ),
                            // About Section
                            if (profileVm.userData!.about != null &&
                                profileVm.userData!.about!.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColor.offwhite,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColor.border,
                                    width: 1,
                                  ),
                                ),
                                child: CustomText(
                                  title: profileVm.userData!.about ?? "",
                                  size: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.black,
                                  alignment: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Modern Tournament History Section
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColor.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with modern styling
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColor.primaryColor.withOpacity(0.1),
                                    AppColor.primaryColor.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColor.primaryColor.withOpacity(0.3),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.emoji_events,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            title: LocaleKeys.tournamentHistory.tr(),
                                            size: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.black,
                                          ),
                                          const SizedBox(height: 2),
                                          CustomText(
                                            title: "Recent tournaments",
                                            size: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.greyText,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MyRoutes.tournamentHistory);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColor.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColor.primaryColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child:  Icon(
                                        Icons.arrow_forward,
                                        color: AppColor.primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Content Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Consumer<ProfileViewModel>(
                                builder: (context, profileVm, child) {
                                  final tournamentData = profileVm.tournamentData;
                                  if (profileVm.isLoading) {
                                    return Container(
                                      height: 120,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CupertinoActivityIndicator(
                                              color: AppColor.primaryColor,
                                              radius: 15,
                                            ),
                                            const SizedBox(height: 12),
                                            CustomText(
                                              title: LocaleKeys.loading.tr(),
                                              size: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.greyText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  if (tournamentData.isEmpty) {
                                    return Container(
                                      padding: const EdgeInsets.all(30),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColor.offwhite,
                                            AppColor.offwhite.withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: AppColor.border.withOpacity(0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: AppColor.primaryColor.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child:  Icon(
                                              Icons.emoji_events_outlined,
                                              color: AppColor.primaryColor,
                                              size: 40,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          CustomText(
                                            title: LocaleKeys.noTournamentHistory.tr(),
                                            size: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.black,
                                            alignment: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          CustomText(
                                            title: LocaleKeys.thereAreCurrentlyNoTournaments.tr(),
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.greyText,
                                            alignment: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  // Display tournament with modern card design
                                  final tournament = tournamentData[0];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          MyRoutes.tournamentDetailScreen,
                                          arguments: tournament);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColor.primaryColor.withOpacity(0.05),
                                            AppColor.primaryColor.withOpacity(0.02),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: AppColor.primaryColor.withOpacity(0.2),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColor.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          // Tournament Image
                                          Container(
                                            height: 120,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: tournament.banner ?? '',
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) => Container(
                                                  color: AppColor.lightgrey,
                                                  child: const Icon(
                                                    Icons.emoji_events,
                                                    color: AppColor.grey,
                                                    size: 40,
                                                  ),
                                                ),
                                                placeholder: (context, url) => Container(
                                                  color: AppColor.lightgrey,
                                                  child: Center(
                                                    child: CupertinoActivityIndicator(
                                                      color: AppColor.primaryColor,
                                                      radius: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Tournament Info
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  title: tournament.name ?? "",
                                                  size: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.black,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColor.primaryColor.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: CustomText(
                                                        title: tournament.gameName ?? "",
                                                        size: 11,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColor.primaryColor,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      padding: const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        color: AppColor.primaryColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: const Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (tournament.description != null && tournament.description!.isNotEmpty) ...[
                                                  const SizedBox(height: 8),
                                                  CustomText(
                                                    title: tournament.description!,
                                                    size: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.greyText,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Gaming-style Tabs Section
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColor.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Gaming-style Tab Headers
                            Container(
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColor.lightgrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Consumer<ProfileViewModel>(
                                builder: (context, value, child) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              value.setSelectedTabIndex(0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: value.selectedTabIndex == 0
                                                  ? AppColor.primaryColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: value
                                                          .selectedTabIndex ==
                                                      0
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColor
                                                            .primaryColor
                                                            .withOpacity(0.3),
                                                        blurRadius: 8,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.collections,
                                                  size: 18,
                                                  color:
                                                      value.selectedTabIndex ==
                                                              0
                                                          ? Colors.white
                                                          : AppColor.greyText,
                                                ),
                                                const SizedBox(width: 8),
                                                CustomText(
                                                  title: LocaleKeys.posts.tr(),
                                                  size: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      value.selectedTabIndex ==
                                                              0
                                                          ? Colors.white
                                                          : AppColor.greyText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              value.setSelectedTabIndex(1),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: value.selectedTabIndex == 1
                                                  ? AppColor.primaryColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: value
                                                          .selectedTabIndex ==
                                                      1
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColor
                                                            .primaryColor
                                                            .withOpacity(0.3),
                                                        blurRadius: 8,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.video_collection,
                                                  size: 18,
                                                  color:
                                                      value.selectedTabIndex ==
                                                              1
                                                          ? Colors.white
                                                          : AppColor.greyText,
                                                ),
                                                const SizedBox(width: 8),
                                                CustomText(
                                                  title: LocaleKeys.reels.tr(),
                                                  size: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      value.selectedTabIndex ==
                                                              1
                                                          ? Colors.white
                                                          : AppColor.greyText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            // Content Section
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Consumer<ProfileViewModel>(
                                builder: (context, value, child) {
                                  return value.selectedTabIndex == 0
                                      ? Portfolio()
                                      : value.selectedTabIndex == 1
                                          ? VideoList()
                                          : const SizedBox();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              )
              : Center(
                  child: CupertinoActivityIndicator(
                    color: AppColor.primaryColor,
                    radius: 20,
                  ),
                );
        }));
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
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, profileVm, child) {
        // Show loading indicator when data is being fetched
        if (profileVm.isLoading && profileVm.userImagesList.isEmpty) {
          return Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    color: AppColor.primaryColor,
                    radius: 15,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    title: LocaleKeys.loading.tr(),
                    size: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyText,
                  ),
                ],
              ),
            ),
          );
        }

        // Show error message if there's an error
        if (profileVm.errorMessage != null && profileVm.userImagesList.isEmpty) {
          return Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColor.red,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    title: profileVm.errorMessage!,
                    size: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.red,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty state if no images
        if (profileVm.userImagesList.isEmpty) {
          return Container(
            height: 200,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.work_outline,
                      color: AppColor.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    title: LocaleKeys.noPostsFound.tr(),
                    size: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    title: LocaleKeys.thereAreCurrentlyNoPosts.tr(),
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.greyText,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Show portfolio grid
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: profileVm.userImagesList.length,
          itemBuilder: (context, index) {
            final image = profileVm.userImagesList[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.imageScreen,
                    arguments: [
                      image.media,
                      image.title,
                    ]);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.lightgrey,
                          image: image.media != null && image.media.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(image.media),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: image.media == null || image.media.isEmpty
                            ? Icon(
                                Icons.image_not_supported,
                                color: AppColor.greyText,
                                size: 40,
                              )
                            : null,
                      ),
                      // Gaming-style overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColor.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      // Title overlay
                      if (image.title != null && image.title.isNotEmpty)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: CustomText(
                            title: image.title!,
                            size: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                            maxLines: 2,
                            alignment: TextAlign.center,
                          ),
                        ),
                      // Delete button with gaming style
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            profileVm.deletePortfolioItem(image.id);
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColor.red.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.red.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.delete_forever,
                              color: AppColor.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VideoList extends StatefulWidget {
  const VideoList({
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
    return Consumer<ProfileViewModel>(
      builder: (context, profileVm, child) {
        // Show loading indicator when data is being fetched
        if (profileVm.isLoading && profileVm.userVideoList.isEmpty) {
          return Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    color: AppColor.primaryColor,
                    radius: 15,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    title: LocaleKeys.loading.tr(),
                    size: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyText,
                  ),
                ],
              ),
            ),
          );
        }

        // Show error message if there's an error
        if (profileVm.errorMessage != null && profileVm.userVideoList.isEmpty) {
          return Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColor.red,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    title: profileVm.errorMessage!,
                    size: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.red,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty state if no videos
        if (profileVm.userVideoList.isEmpty) {
          return Container(
            height: 200,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.video_collection_outlined,
                      color: AppColor.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    title: LocaleKeys.noReelsFound.tr(),
                    size: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    title: LocaleKeys.thereAreCurrentlyNoReels.tr(),
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.greyText,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: profileVm.userVideoList.length,
          itemBuilder: (context, index) {
            final video = profileVm.userVideoList[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.videoDetail, arguments: [
                  video.media,
                  video.title,
                ]);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.lightgrey,
                          image: video.media != null && video.media.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(video.media),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: video.media == null || video.media.isEmpty
                            ? Icon(
                                Icons.video_library_outlined,
                                color: AppColor.greyText,
                                size: 40,
                              )
                            : null,
                      ),
                      // Gaming-style overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColor.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      // Title overlay
                      if (video.title != null && video.title.isNotEmpty)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: CustomText(
                            title: video.title!,
                            size: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                            maxLines: 2,
                            alignment: TextAlign.center,
                          ),
                        ),
                      // Play button overlay
                      Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: AppColor.white,
                            size: 30,
                          ),
                        ),
                      ),
                      // Delete button with gaming style
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            profileVm.deletePortfolioItem(video.id);
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColor.red.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.red.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.close,
                              color: AppColor.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Helper methods for gaming-style components
Widget buildStatCard({
  required IconData icon,
  required String value,
  required String label,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.1),
          color.withOpacity(0.05),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(height: 8),
        CustomText(
          title: value,
          size: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
        const SizedBox(height: 2),
        CustomText(
          title: label,
          size: 11,
          fontWeight: FontWeight.w500,
          color: AppColor.greyText,
        ),
      ],
    ),
  );
}

Widget buildGamingButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required Gradient gradient,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 45,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          CustomText(
            title: label,
            size: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
