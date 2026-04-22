import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/screens/tournament_history/view_model/tournament_history_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TournamentHistoryScreen extends StatefulWidget {
  const TournamentHistoryScreen({super.key});

  @override
  State<TournamentHistoryScreen> createState() =>
      _TournamentHistoryScreenState();
}

class _TournamentHistoryScreenState extends State<TournamentHistoryScreen> {
  @override
  void initState() {
    context.read<TournamentHistoryViewModel>().getUserFromSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar:  CommonAppBar(title: LocaleKeys.tournamentHistory.tr(),),
      body: Consumer<TournamentHistoryViewModel>(
          builder: (context, tournamentVm, child) {
        if (tournamentVm.isLoading) {
          return Center(
              child: CupertinoActivityIndicator(
            color: AppColor.primaryColor,
            radius: 20,
          ));
        }

        final tournamentData = tournamentVm.tournamentData;
        if (tournamentData.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gaming-themed empty state
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.emoji_events_outlined,
                        color: AppColor.primaryColor,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomText(
                    title: LocaleKeys.noTournamentHistory.tr(),
                    color: AppColor.black,
                    size: 18,
                    fontWeight: FontWeight.w600,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    title: LocaleKeys.thereAreCurrentlyNoTournaments.tr(),
                    color: AppColor.black.withOpacity(0.7),
                    size: 14,
                    fontWeight: FontWeight.w400,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Call to action button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.primaryColor,
                          AppColor.primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomText(
                      title: "Join Your First Tournament",
                      color: Colors.white,
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: tournamentData.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final tournament = tournamentData[index];
            return _buildTournamentCard(context, tournament, index);
          },
        );
      }),
    );
  }

  // Modern Gaming Tournament Card Builder
  Widget _buildTournamentCard(BuildContext context, dynamic tournament, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.offwhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.border,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tournament Banner Section
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.black12,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: tournament.banner != null && tournament.banner!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: tournament.banner!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => _buildPlaceholderBanner(),
                      placeholder: (context, url) => _buildLoadingBanner(),
                    )
                  : _buildPlaceholderBanner(),
            ),
          ),
          
          // Tournament Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tournament Title and Status
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        title: tournament.name ?? "Unknown Tournament",
                        color: AppColor.black,
                        size: 16,
                        fontWeight: FontWeight.w600,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: CustomText(
                        title: "Completed",
                        color: AppColor.primaryColor,
                        size: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Game Name
                if (tournament.gameName != null && tournament.gameName!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      title: tournament.gameName!,
                      color: AppColor.blue,
                      size: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                
                const SizedBox(height: 12),
                
                // Tournament Description
                if (tournament.description != null && tournament.description!.isNotEmpty)
                  CustomText(
                    title: tournament.description!,
                    color: AppColor.black.withOpacity(0.7),
                    size: 13,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                  ),
                
                const SizedBox(height: 12),
                
                // Tournament Stats Row
                Row(
                  children: [
                    // Date
                    if (tournament.dateIni != null)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColor.primaryColor,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: CustomText(
                                title: DateFormat('MMM dd, yyyy').format(tournament.dateIni!),
                                color: AppColor.black.withOpacity(0.7),
                                size: 12,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Prize
                    if (tournament.totalReward != null && tournament.isReward == 1)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: AppColor.yellow,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: CustomText(
                                title: '\$${tournament.totalReward}',
                                color: AppColor.black.withOpacity(0.7),
                                size: 12,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Organization Info
                if (tournament.organization != null)
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: AppColor.primaryColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: CustomText(
                          title: "Hosted by ${tournament.organization!.name ?? 'Unknown'}",
                          color: AppColor.black.withOpacity(0.7),
                          size: 12,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                        ),
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

  // Placeholder banner for tournaments without images
  Widget _buildPlaceholderBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primaryColor.withOpacity(0.1),
            AppColor.primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: AppColor.primaryColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            CustomText(
              title: "Tournament",
              color: AppColor.primaryColor,
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  // Loading banner
  Widget _buildLoadingBanner() {
    return Container(
      color: AppColor.offwhite,
      child: Center(
        child: CupertinoActivityIndicator(
          color: AppColor.primaryColor,
          radius: 12,
        ),
      ),
    );
  }
}
