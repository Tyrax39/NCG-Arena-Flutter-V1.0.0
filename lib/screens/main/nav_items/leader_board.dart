import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/main/view_model/main_screen_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  static const String key_title = "/leaderboard_navigation_screen";
  const LeaderboardScreen({
    super.key,
  });
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load leaderboard data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainScreenProvider>().getLeaderboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(
      builder: (context, mainProvider, child) {
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
          // Header Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColor.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  title:  AppBranding.appDisplayName + " " + LocaleKeys.leaderboard.tr(),
              
                  size: 20,
                  fontWeight: FontWeights.bold,
                  color: AppColor.black,
                ),
                const SizedBox(height: 4),
                CustomText(
                  title: LocaleKeys.topPlayersAndTeamsInCompetitiveGaming.tr(),
                  size: 14,
                  fontWeight: FontWeights.regular,
                  color: AppColor.greyText,
                ),
              ],
            ),
          ),
          Gap.h(20),
          // Tab Selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColor.lightgrey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      mainProvider.setLeaderboardTabIndex(0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: mainProvider.leaderboardTabIndex == 0
                            ? AppColor.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: mainProvider.leaderboardTabIndex == 0
                            ? [
                                BoxShadow(
                                  color: AppColor.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 18,
                            color: mainProvider.leaderboardTabIndex == 0
                                ? Colors.white      
                                : AppColor.greyText,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            title: LocaleKeys.players.tr(),
                            size: 14,
                            fontWeight: FontWeights.semiBold,
                            color: mainProvider.leaderboardTabIndex == 0
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
                    onTap: () {
                      mainProvider.setLeaderboardTabIndex(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: mainProvider.leaderboardTabIndex == 1
                            ? AppColor.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: mainProvider.leaderboardTabIndex == 1
                            ? [
                                BoxShadow(
                                  color: AppColor.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.groups,
                            size: 18,
                            color: mainProvider.leaderboardTabIndex == 1
                                ? Colors.white
                                : AppColor.greyText,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            title: LocaleKeys.teams.tr(),
                            size: 14,
                            fontWeight: FontWeights.semiBold,
                            color: mainProvider.leaderboardTabIndex == 1
                                ? Colors.white
                                : AppColor.greyText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap.h(20),
          // Content Section
          Expanded(
            child: mainProvider.leaderboardTabIndex == 0
                ? PlayersLeaderboard()
                : TeamsLeaderboard(),
          ),
        ],
      ),
    );
      },
    );
  }
}

class PlayersLeaderboard extends StatefulWidget {
  const PlayersLeaderboard({
    super.key,
  });

  @override
  State<PlayersLeaderboard> createState() => _PlayersLeaderboardState();
}

class _PlayersLeaderboardState extends State<PlayersLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(
      builder: (context, mainProvider, child) {
        if (mainProvider.isLeaderboardLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (mainProvider.leaderboardErrorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColor.greyText,
                ),
                const SizedBox(height: 16),
                CustomText(
                  title: "Failed to load leaderboard",
                  size: 16,
                  fontWeight: FontWeights.semiBold,
                  color: AppColor.black,
                ),
                const SizedBox(height: 8),
                CustomText(
                  title: mainProvider.leaderboardErrorMessage!,
                  size: 14,
                  fontWeight: FontWeights.regular,
                  color: AppColor.greyText,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    mainProvider.getLeaderboardData();
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final users = mainProvider.leaderboardUsers;
        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.leaderboard_outlined,
                  size: 64,
                  color: AppColor.greyText,
                ),
                const SizedBox(height: 16),
                CustomText(
                  title: "No players found",
                  size: 16,
                  fontWeight: FontWeights.semiBold,
                  color: AppColor.black,
                ),
                const SizedBox(height: 8),
                CustomText(
                  title: "Check back later for leaderboard updates",
                  size: 14,
                  fontWeight: FontWeights.regular,
                  color: AppColor.greyText,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Top 3 Players Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.primaryColor.withOpacity(0.05),
                      AppColor.primaryColor.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: AppColor.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          title: "Top Players",
                          size: 18,
                          fontWeight: FontWeights.bold,
                          color: AppColor.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Podium for top 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 2nd Place
                        if (users.length >= 2)
                          buildPodiumPlayer(
                            rank: 2,
                            name: users[1].username ?? "Player 2",
                            score: users[1].totalScore?.toStringAsFixed(1) ?? "0",
                            avatar: users[1].image ?? "assets/images/placeholder.png",
                            color: AppColor.grey,
                          )
                        else
                          const SizedBox(width: 60),
                        // 1st Place
                        if (users.isNotEmpty)
                          buildPodiumPlayer(
                            rank: 1,
                            name: users[0].username ?? "Player 1",
                            score: users[0].totalScore?.toStringAsFixed(1) ?? "0",
                            avatar: users[0].image ?? "assets/images/placeholder.png",
                            color: AppColor.primaryColor,
                            isChampion: true,
                          )
                        else
                          const SizedBox(width: 60),
                        // 3rd Place
                        if (users.length >= 3)
                          buildPodiumPlayer(
                            rank: 3,
                            name: users[2].username ?? "Player 3",
                            score: users[2].totalScore?.toStringAsFixed(1) ?? "0",
                            avatar: users[2].image ?? "assets/images/placeholder.png",
                            color: AppColor.orange,
                          )
                        else
                          const SizedBox(width: 60),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Full Leaderboard List
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.leaderboard,
                            color: AppColor.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            title: "Complete Rankings",
                            size: 18,
                            fontWeight: FontWeights.bold,
                            color: AppColor.black,
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length > 3 ? users.length - 3 : 0,
                      itemBuilder: (context, index) {
                        final userIndex = index + 3;
                        if (userIndex >= users.length) return const SizedBox();
                        
                        final user = users[userIndex];
                        return buildLeaderboardItem(
                          rank: userIndex + 1,
                          name: user.username ?? "Player ${userIndex + 1}",
                          score: user.totalScore?.toStringAsFixed(1) ?? "0",
                          avatar: user.image ?? "assets/images/placeholder.png",
                          isCurrentUser: false, // You can implement current user detection
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildPodiumPlayer({
    required int rank,
    required String name,
    required String score,
    required String avatar,
    required Color color,
    bool isChampion = false,
  }) {
    return Column(
      children: [
        Container(
          height: isChampion ? 80 : 60,
          width: isChampion ? 80 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: isChampion ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: AppColor.lightgrey,
            child: avatar.startsWith('http')
                ? Image.network(
                    avatar,
                    height: isChampion ? 50 : 40,
                    width: isChampion ? 50 : 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/placeholder.png",
                        height: isChampion ? 50 : 40,
                        width: isChampion ? 50 : 40,
                      );
                    },
                  )
                : Image.asset(
                    avatar,
                    height: isChampion ? 50 : 40,
                    width: isChampion ? 50 : 40,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomText(
            title: "#$rank",
            size: 12,
            fontWeight: FontWeights.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        CustomText(
          title: name,
          size: 14,
          fontWeight: FontWeights.semiBold,
          color: AppColor.black,
        ),
        const SizedBox(height: 2),
        CustomText(
          title: score,
          size: 12,
          fontWeight: FontWeights.medium,
          color: AppColor.greyText,
        ),
      ],
    );
  }

  Widget buildLeaderboardItem({
    required int rank,
    required String name,
    required String score,
    required String avatar,
    bool isCurrentUser = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColor.primaryColor.withOpacity(0.1)
            : AppColor.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: isCurrentUser
            ? Border.all(color: AppColor.primaryColor.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.lightgrey,
            ),
            child: Center(
              child: CustomText(
                title: "#$rank",
                size: 14,
                fontWeight: FontWeights.bold,
                color: AppColor.black,
              ),
            ),
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColor.lightgrey,
            child: avatar.startsWith('http')
                ? Image.network(
                    avatar,
                    height: 30,
                    width: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/placeholder.png",
                        height: 30,
                        width: 30,
                      );
                    },
                  )
                : Image.asset(
                    avatar,
                    height: 30,
                    width: 30,
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: name,
                  size: 16,
                  fontWeight: FontWeights.semiBold,
                  color: AppColor.black,
                ),
                const SizedBox(height: 2),
                CustomText(
                  title: "Score: $score",
                  size: 12,
                  fontWeight: FontWeights.medium,
                  color: AppColor.greyText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//////////////    Teams Leaderboard   ///////////////

class TeamsLeaderboard extends StatefulWidget {
  const TeamsLeaderboard({
    super.key,
  });

  @override
  State<TeamsLeaderboard> createState() => _TeamsLeaderboardState();
}

class _TeamsLeaderboardState extends State<TeamsLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(
      builder: (context, mainProvider, child) {
        if (mainProvider.isLeaderboardLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (mainProvider.leaderboardErrorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColor.greyText,
                ),
                const SizedBox(height: 16),
                CustomText(
                  title: "Failed to load leaderboard",
                  size: 16,
                  fontWeight: FontWeights.semiBold,
                  color: AppColor.black,
                ),
                const SizedBox(height: 8),
                CustomText(
                  title: mainProvider.leaderboardErrorMessage!,
                  size: 14,
                  fontWeight: FontWeights.regular,
                  color: AppColor.greyText,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    mainProvider.getLeaderboardData();
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final teams = mainProvider.leaderboardTeams;
        if (teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.groups_outlined,
                  size: 64,
                  color: AppColor.greyText,
                ),
                const SizedBox(height: 16),
                CustomText(
                  title: "No teams found",
                  size: 16,
                  fontWeight: FontWeights.semiBold,
                  color: AppColor.black,
                ),
                const SizedBox(height: 8),
                CustomText(
                  title: "Check back later for leaderboard updates",
                  size: 14,
                  fontWeight: FontWeights.regular,
                  color: AppColor.greyText,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Top 3 Teams Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.primaryColor.withOpacity(0.05),
                      AppColor.primaryColor.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.groups,
                          color: AppColor.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          title: "Top Teams",
                          size: 18,
                          fontWeight: FontWeights.bold,
                          color: AppColor.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Podium for top 3 teams
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 2nd Place
                        if (teams.length >= 2)
                          buildPodiumTeam(
                            rank: 2,
                            name: teams[1].name ?? "Team 2",
                            score: teams[1].totalScore?.toStringAsFixed(1) ?? "0",
                            logo: teams[1].logo ?? "assets/images/placeholder.png",
                            color: AppColor.grey,
                          )
                        else
                          const SizedBox(width: 60),
                        // 1st Place
                        if (teams.isNotEmpty)
                          buildPodiumTeam(
                            rank: 1,
                            name: teams[0].name ?? "Team 1",
                            score: teams[0].totalScore?.toStringAsFixed(1) ?? "0",
                            logo: teams[0].logo ?? "assets/images/placeholder.png",
                            color: AppColor.primaryColor,
                            isChampion: true,
                          )
                        else
                          const SizedBox(width: 60),
                        // 3rd Place
                        if (teams.length >= 3)
                          buildPodiumTeam(
                            rank: 3,
                            name: teams[2].name ?? "Team 3",
                            score: teams[2].totalScore?.toStringAsFixed(1) ?? "0",
                            logo: teams[2].logo ?? "assets/images/placeholder.png",
                            color: AppColor.orange,
                          )
                        else
                          const SizedBox(width: 60),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Full Teams Leaderboard List
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.leaderboard,
                            color: AppColor.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            title: "Team Rankings",
                            size: 18,
                            fontWeight: FontWeights.bold,
                            color: AppColor.black,
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: teams.length > 3 ? teams.length - 3 : 0,
                      itemBuilder: (context, index) {
                        final teamIndex = index + 3;
                        if (teamIndex >= teams.length) return const SizedBox();
                        
                        final team = teams[teamIndex];
                        return buildTeamLeaderboardItem(
                          rank: teamIndex + 1,
                          name: team.name ?? "Team ${teamIndex + 1}",
                          score: team.totalScore?.toStringAsFixed(1) ?? "0",
                          logo: team.logo ?? "assets/images/placeholder.png",
                          members: team.membersCount?.toString() ?? "0",
                          isCurrentTeam: false, // You can implement current team detection
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildPodiumTeam({
    required int rank,
    required String name,
    required String score,
    required String logo,
    required Color color,
    bool isChampion = false,
  }) {
    return Column(
      children: [
        Container(
          height: isChampion ? 80 : 60,
          width: isChampion ? 80 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: isChampion ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: AppColor.lightgrey,
            child: logo.startsWith('http')
                ? Image.network(
                    logo,
                    height: isChampion ? 50 : 40,
                    width: isChampion ? 50 : 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/placeholder.png",
                        height: isChampion ? 50 : 40,
                        width: isChampion ? 50 : 40,
                      );
                    },
                  )
                : Image.asset(
                    logo,
                    height: isChampion ? 50 : 40,
                    width: isChampion ? 50 : 40,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomText(
            title: "#$rank",
            size: 12,
            fontWeight: FontWeights.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        CustomText(
          title: name,
          size: 14,
          fontWeight: FontWeights.semiBold,
          color: AppColor.black,
        ),
        const SizedBox(height: 2),
        CustomText(
          title: score,
          size: 12,
          fontWeight: FontWeights.medium,
          color: AppColor.greyText,
        ),
      ],
    );
  }

  Widget buildTeamLeaderboardItem({
    required int rank,
    required String name,
    required String score,
    required String logo,
    required String members,
    bool isCurrentTeam = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isCurrentTeam
            ? AppColor.primaryColor.withOpacity(0.1)
            : AppColor.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: isCurrentTeam
            ? Border.all(color: AppColor.primaryColor.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.lightgrey,
            ),
            child: Center(
              child: CustomText(
                title: "#$rank",
                size: 14,
                fontWeight: FontWeights.bold,
                color: AppColor.black,
              ),
            ),
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColor.lightgrey,
            child: logo.startsWith('http')
                ? Image.network(
                    logo,
                    height: 30,
                    width: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/placeholder.png",
                        height: 30,
                        width: 30,
                      );
                    },
                  )
                : Image.asset(
                    logo,
                    height: 30,
                    width: 30,
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: name,
                  size: 16,
                  fontWeight: FontWeights.semiBold,
                  color: AppColor.black,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    CustomText(
                      title: "Score: $score",
                      size: 12,
                      fontWeight: FontWeights.medium,
                      color: AppColor.greyText,
                    ),
                    const SizedBox(width: 10),
                    CustomText(
                      title: "• $members members",
                      size: 12,
                      fontWeight: FontWeights.medium,
                      color: AppColor.greyText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
