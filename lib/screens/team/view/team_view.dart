import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/screens/team/view_model/team_view_model.dart';
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

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    context.read<TeamViewModel>().getTeam();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.team.tr()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.createTeam).then((value) {
            context.read<TeamViewModel>().getTeam();
          });
        },
        backgroundColor: AppColor.primaryColor,
        label: Row(
          children: [
            const Icon(Icons.add, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.createTeam.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 4,
      ),
      body: SafeArea(
        child: Consumer<TeamViewModel>(
          builder: (context, provider, child) {
            if (provider.teamData.isEmpty && !provider.isLoading) {
              return _buildEmptyState();
            } else if (provider.isLoading) {
              return _buildLoadingState();
            } else {
              return _buildTeamList(provider);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_esports,
            size: 60,
            color: AppColor.black,
          ),
          const SizedBox(height: 5),
          Text(
            LocaleKeys.noTeamsAvailable.tr(),
            style: TextStyle(
              color: AppColor.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: "inter",
            ),
          ),
          const SizedBox(height: 5),
          Text(
            LocaleKeys.createTeamToGetStarted.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              fontFamily: "inter",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            color: AppColor.primaryColor,
            radius: 20,
          ),
          const SizedBox(height: 20),
          Text(
            "${LocaleKeys.team.tr()} ${LocaleKeys.loading?.tr() ?? 'Loading...'}",
            style: TextStyle(
              color: AppColor.darkText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamList(TeamViewModel provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: provider.teamData.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final team = provider.teamData[index];
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final delay = index * 0.2;
              final slideAnimation = Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
                ),
              );

              return FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
                  ),
                ),
                child: SlideTransition(
                  position: slideAnimation,
                  child: _buildTeamCard(team),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTeamCard(MyTeamModel team) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          MyRoutes.teamDetailScreen,
          arguments: team,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.offwhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColor.black.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -10,
                bottom: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColor.black.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Hero(
                      tag: 'team_logo_${team.id}',
                      child: Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor.black.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: team.logo != null
                              ? CachedNetworkImage(
                                  imageUrl: team.logo!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.sports_esports,
                                    color: AppColor.black.withOpacity(0.7),
                                    size: 40,
                                  ),
                                  placeholder: (context, url) => Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColor.black,
                                      radius: 12,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.sports_esports,
                                  color: AppColor.black.withOpacity(0.7),
                                  size: 40,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  team.name.toString(),
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "inter",
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColor.black,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (team.game != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColor.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                team.game!.gameName!,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.people_alt_outlined,
                                color: AppColor.black.withOpacity(0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${team.members} ${LocaleKeys.members.tr()}",
                                style: TextStyle(
                                  color: AppColor.black.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
