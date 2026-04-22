// ignore_for_file: use_build_context_synchronously, unused_local_variable, sort_child_properties_last
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/matchDetails/view_model/match_details_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchDetailScreen extends StatefulWidget {
  final int matchid;
  final String currentUserId;
  const MatchDetailScreen({
    super.key,
    required this.matchid,
    required this.currentUserId,
  });

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  @override
  void initState() {
    super.initState();
    context.read<MatchDetailViewModel>().getMatch(id: widget.matchid);
  }

  Future<void> refreshPosts() async {
    context.read<MatchDetailViewModel>().getMatch(id: widget.matchid);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didpop) {
        if (didpop) {
          return;
        }
      },
      child: RefreshIndicator(
        onRefresh: refreshPosts,
        child: Scaffold(
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(title: LocaleKeys.matchDetail.tr()),
          floatingActionButton: Consumer<MatchDetailViewModel>(
              builder: (context, matchDetailVM, child) {
            if (matchDetailVM.isLoading) {
              return const SizedBox();
            }
            if (matchDetailVM.matchData == null) {
              return const SizedBox();
            }
            final matchData = matchDetailVM.matchData;
            if (matchData!.competitor1Data == null &&
                matchData.competitor2Data == null) {
              return const SizedBox();
            } else {
              return matchData.tournamentOwnerId != null &&
                      matchData.tournamentOwnerId.toString() ==
                          widget.currentUserId.toString()
                  ? FloatingActionButton.extended(
                      backgroundColor: AppColor.screenBG,
                      onPressed: () async {
                        final user = await sharedPreferenceHelper.user;
                        Navigator.pushNamed(context, MyRoutes.tournamentChat,
                            arguments: [
                              user!.id.toString(),
                              matchData.tournamentId.toString(),
                              matchData.id.toString(),
                              "${matchData.tournamentName}",
                              matchData.tournamentOwnerId.toString()
                            ]);
                      },
                      label: CustomText(
                        title: 'Chat',
                        color: AppColor.black,
                      ),
                      icon: Icon(
                        Icons.chat,
                        color: AppColor.primaryColor,
                        size: 25,
                      ),
                    )
                  : matchData.c1CheckIn == 1 &&
                          matchData.c2CheckIn == 1 &&
                          (widget.currentUserId.toString() ==
                                  matchData.competitor1.toString() ||
                              widget.currentUserId.toString() ==
                                  matchData.competitor2.toString())
                      ? FloatingActionButton.extended(
                          backgroundColor: AppColor.screenBG,
                          onPressed: () async {
                            final user = await sharedPreferenceHelper.user;
                            Navigator.pushNamed(
                              context,
                              MyRoutes.tournamentChat,
                              arguments: [
                                user!.id.toString(), // userId
                                matchData.tournamentId
                                    .toString(), // tournamentId
                                matchData.id.toString(), // matchId
                                matchData.tournamentName
                                    .toString(), // tournamentName
                                matchData.tournamentOwnerId
                                    .toString(), // tournamentAdmin
                              ],
                            );
                          },
                          label: CustomText(
                            title: 'Chat',
                            color: AppColor.black,
                          ),
                          icon: Icon(
                            Icons.chat,
                            color: AppColor.primaryColor,
                            size: 25,
                          ),
                        )
                      : const SizedBox();
            }
          }),
          body: Consumer<MatchDetailViewModel>(
            builder: (context, matchDetailVm, child) {
              if (matchDetailVm.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (matchDetailVm.matchData == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColor.primaryColor,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        alignment: TextAlign.center,
                        title: 'No match data available',
                        color: AppColor.black,
                      ),
                    ],
                  ),
                );
              }

              if (matchDetailVm.matchData!.competitor1Data == null &&
                  matchDetailVm.matchData!.competitor2Data == null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.block,
                          color: AppColor.primaryColor,
                          size: 60,
                        ),
                        const SizedBox(height: 20),
                        CustomText(
                          alignment: TextAlign.center,
                          title: 'Match Already Completed',
                          color: AppColor.black,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                    // Gaming-style Header Section
                    Container(
                      margin: const EdgeInsets.all(20),
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
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                        child: Column(
                          children: [
                          // Tournament Name
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomText(
                              title: matchDetailVm.matchData!.tournamentName?.toString() ?? 'Tournament',
                              color: AppColor.primaryColor,
                              size: 18,
                              fontWeight: FontWeight.bold,
                              alignment: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Round Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: AppColor.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                title: "Round ${matchDetailVm.matchData!.round}",
                                                      color: AppColor.black,
                                size: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                                            ),
                                    ],
                                  ),
                    ),
                    
                    // Gaming-style VS Section
                                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColor.offwhite,
                            AppColor.offwhite.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColor.border.withOpacity(0.5),
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
                          // Teams VS Section
                          Row(
                            children: [
                              // Team 1
                              Expanded(
                                child: _buildTeamCard(
                                  context: context,
                                  teamData: matchDetailVm.matchData!.competitor1Data,
                                  score: matchDetailVm.matchData!.c1Score,
                                  isLeft: true,
                                ),
                              ),
                              
                              // VS Section
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                                        AppColor.primaryColor,
                                            AppColor.primaryColor.withOpacity(0.8),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColor.primaryColor.withOpacity(0.3),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        'VS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                    const SizedBox(height: 8),
                                    CustomText(
                                      title: '${matchDetailVm.matchData!.c1Score} - ${matchDetailVm.matchData!.c2Score}',
                                      color: AppColor.primaryColor,
                                      size: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Team 2
                              Expanded(
                                child: _buildTeamCard(
                                  context: context,
                                  teamData: matchDetailVm.matchData!.competitor2Data,
                                  score: matchDetailVm.matchData!.c2Score,
                                  isLeft: false,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    const SizedBox(height: 20),
                    
                    // Action Buttons Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Check-in Section for Competitor 1
                            if (widget.currentUserId.toString() ==
                                    matchDetailVm.matchData!.competitor1
                                        .toString() &&
                                matchDetailVm.matchData!.c1CheckIn == 0) ...[
                            _buildCheckInSection(
                              context: context,
                              matchDetailVm: matchDetailVm,
                              matchId: widget.matchid,
                            ),
                          ],
                          
                          // Check-in Section for Competitor 2
                            if (widget.currentUserId.toString() ==
                                    matchDetailVm.matchData!.competitor2
                                        .toString() &&
                                matchDetailVm.matchData!.c2CheckIn == 0) ...[
                            _buildCheckInSection(
                              context: context,
                              matchDetailVm: matchDetailVm,
                              matchId: widget.matchid,
                            ),
                          ],
                          
                          const SizedBox(height: 20),
                          
                          // Update Score Button for Tournament Owner
                            if (matchDetailVm.matchData!.competitor1 != null &&
                              matchDetailVm.matchData!.competitor2 != null &&
                              matchDetailVm.matchData!.tournamentOwnerId
                                      .toString() ==
                                  widget.currentUserId.toString()) ...[
                            _buildActionButton(
                              context: context,
                              title: LocaleKeys.updateScore.tr(),
                              icon: Icons.edit,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      MyRoutes.updateScore,
                                      arguments: [widget.matchid],
                                    );
                                  },
                            ),
                          ],
                          
                          // Update Score Button for Competitors
                            if (matchDetailVm.matchData!.c1CheckIn == 1 &&
                                matchDetailVm.matchData!.c2CheckIn == 1 &&
                                (widget.currentUserId.toString() ==
                                    matchDetailVm.matchData!.competitor2
                                        .toString())) ...[
                            _buildActionButton(
                              context: context,
                              title: LocaleKeys.updateScore.tr(),
                              icon: Icons.edit,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutes.updateScore,
                                    arguments: widget.matchid,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
            );
            },
          ),
        ),
      ),
    );
  }

  // Gaming-style Team Card Builder
  Widget _buildTeamCard({
    required BuildContext context,
    required TeamData? teamData,
    required int? score,
    required bool isLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.white.withOpacity(0.8),
            AppColor.white.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Team Logo
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.primaryColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: teamData?.logo != null
                  ? CachedNetworkImage(
                      imageUrl: teamData!.logo!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: AppColor.lightgrey,
                        child: Icon(
                          Icons.group,
                          color: AppColor.primaryColor,
                          size: 30,
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
                    )
                  : Container(
                      color: AppColor.lightgrey,
                      child: Icon(
                        Icons.group,
                        color: AppColor.primaryColor,
                        size: 30,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          // Team Name
          CustomText(
            title: teamData?.name ?? 'Unknown Team',
            color: AppColor.black,
            size: 14,
            fontWeight: FontWeight.bold,
            alignment: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          // Score Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor,
                  AppColor.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: CustomText(
              title: '${score ?? 0}',
              color: Colors.white,
              size: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Gaming-style Check-in Section
  Widget _buildCheckInSection({
    required BuildContext context,
    required MatchDetailViewModel matchDetailVm,
    required int matchId,
  }) {
    return Container(
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Consumer<MatchDetailViewModel>(
        builder: (context, matchDetailVm, child) {
          final remainingTime = matchDetailVm.remainingTime;

          if (remainingTime.inSeconds <= 0) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: AppColor.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        title: LocaleKeys.sorryCheckInTimePassed.tr(),
                        color: AppColor.red,
                        size: 16,
                        fontWeight: FontWeight.w600,
                        alignment: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        color: AppColor.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        title: LocaleKeys.checkInRemainingTime.tr(),
                        color: AppColor.primaryColor,
                        size: 16,
                        fontWeight: FontWeight.w600,
                        alignment: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Enhanced Timer Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.primaryColor,
                        AppColor.primaryColor.withOpacity(0.8),
                        AppColor.primaryColor.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: AppColor.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Timer Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.timer,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Timer Text
                      AnimatedBuilder(
                        animation: const AlwaysStoppedAnimation(1.0),
                        builder: (context, child) {
                          return CustomText(
                            title: _formatDuration(remainingTime),
                            color: Colors.white,
                            size: 28,
                            fontWeight: FontWeight.bold,
                            alignment: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      // Status Text
                      CustomText(
                        title: remainingTime.inSeconds > 0 
                            ? LocaleKeys.checkInRemainingTime.tr()
                            : "Check-in time expired",
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                        fontWeight: FontWeight.w500,
                        alignment: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Enhanced Check-in Button
                GestureDetector(
                  onTap: remainingTime.inSeconds > 0 
                      ? () {
                          context.read<MatchDetailViewModel>().markCheckIn(matchId, context);
                        }
                      : null,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: remainingTime.inSeconds > 0
                          ? LinearGradient(
                              colors: [
                                AppColor.primaryColor,
                                AppColor.primaryColor.withOpacity(0.8),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                AppColor.grey,
                                AppColor.grey.withOpacity(0.8),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: remainingTime.inSeconds > 0
                          ? [
                              BoxShadow(
                                color: AppColor.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: AppColor.grey.withOpacity(0.2),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          remainingTime.inSeconds > 0 
                              ? Icons.check_circle
                              : Icons.timer_off,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          title: remainingTime.inSeconds > 0 
                              ? LocaleKeys.markCheckIn.tr()
                              : "Check-in Expired",
                          color: Colors.white,
                          size: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Gaming-style Action Button
  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.primaryColor,
              AppColor.primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColor.primaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.3),
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
              title: title,
              color: Colors.white,
              size: 16,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
