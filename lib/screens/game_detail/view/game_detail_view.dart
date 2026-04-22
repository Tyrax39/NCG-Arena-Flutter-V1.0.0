import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/game_detail/view_model/game_detail_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameDetailView extends StatefulWidget {
  final GameModel game;
  const GameDetailView({super.key, required this.game});

  @override
  State<GameDetailView> createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GameDetailViewModel>()
          .getTournament(gameId: widget.game.id, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: widget.game.gameName ?? 'Game Details'),
      body: Consumer<GameDetailViewModel>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    title: provider.errorMessage,
                    size: 16,
                    color: AppColor.black,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      provider.getTournament(gameId: widget.game.id);
                    },
                    child: const CustomText(
                      title: 'Try Again',
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGameHeader(context, provider),
                  Gap.h(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Tournaments',
                        size: 18,
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomText(
                          title: '${provider.tournamentData.length} Found',
                          size: 14,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Gap.h(16),
                  provider.tournamentData.isEmpty
                      ? _buildEmptyTournamentState()
                      : _buildTournamentList(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameHeader(BuildContext context, GameDetailViewModel provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.offwhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'game-${widget.game.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.game.gameImage ?? '',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child:
                      const Icon(Icons.gamepad, size: 40, color: Colors.grey),
                ),
                placeholder: (context, url) => Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[200],
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: widget.game.gameName ?? 'Unknown Game',
                  size: 18,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                Gap.h(8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    title: '${provider.tournamentData.length} Tournaments',
                    size: 14,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap.h(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.sports_esports,
                      size: 16,
                      color: AppColor.black.withOpacity(0.6),
                    ),
                    Gap.w(4),
                    Expanded(
                      child: CustomText(
                        title: widget.game.gameType ?? 'E-Sports',
                        size: 14,
                        color: AppColor.black.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
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

  Widget _buildEmptyTournamentState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: AppConfig(context).height * .1,
        ),
        Icon(
          Icons.emoji_events_outlined,
          color: AppColor.black,
          size: 60,
        ),
        Gap.h(20),
        Text(
          LocaleKeys.noTournamentsAvailable.tr(),
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: "inter",
          ),
        ),
        Gap.h(10),
        CustomText(
          title: LocaleKeys.thereAreCurrentlyNoTournamentsAvailableFor.tr(
            args: [widget.game.gameName ?? ''],
          ),
          size: 16,
          maxLines: 2,
          color: AppColor.black.withOpacity(0.6),
          fontWeight: FontWeight.w400,
          alignment: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTournamentList(GameDetailViewModel provider) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: provider.tournamentData.length,
      itemBuilder: (context, index) {
        final tournament = provider.tournamentData[index];
        return _buildTournamentCard(tournament);
      },
    );
  }

  Widget _buildTournamentCard(AllTournaments tournament) {
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
        width: AppConfig(context).width * 0.7, // Control width of each item
        decoration: BoxDecoration(
          color: AppColor.offwhite,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppConfig(context).height * .18,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                // color: Colors.black12,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: tournament.banner!,
                  fit: BoxFit.fill,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.h(10),
                  CustomText(
                    title: tournament.gameName ?? '',
                    color: AppColor.primaryColor,
                    size: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  // const SizedBox(height: 5),
                  CustomText(
                    title: tournament.name.toString(),
                    color: AppColor.black,
                    size: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap.h(5),
                  CustomText(
                    title: 'Hosted By:',
                    color: AppColor.black,
                    size: 9,
                    fontWeight: FontWeight.w400,
                  ),

                  CustomText(
                    title: tournament.organization!.name ?? '',
                    color: AppColor.primaryColor,
                    size: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColor.primaryColor,
                        size: 9,
                      ),
                      Gap.w(5),
                      CustomText(
                        title: DateFormat('yyyy-MM-dd')
                            .format(tournament.dateIni!),
                        color: AppColor.black,
                        size: 9,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      Image.asset(
                        CustomAssets.prizeIcon,
                        height: 10,
                        color: AppColor.primaryColor,
                      ),
                      Gap.w(5),
                      CustomText(
                        title: tournament.isReward == 0
                            ? 'No Prize'
                            : tournament.totalReward.toString(),
                        color: AppColor.black,
                        size: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap.h(10),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AllTournaments tournament) {
    // Assuming tournament has a status field or we can derive status from dates
    String status = 'Open';
    Color statusColor = Colors.green;

    // This is an example logic - adjust based on your actual data model
    if (tournament.dateIni != null) {
      if (tournament.dateIni!.isBefore(DateTime.now())) {
        if (tournament.dateFin != null &&
            tournament.dateFin!.isAfter(DateTime.now())) {
          status = 'Ongoing';
          statusColor = Colors.orange;
        } else {
          status = 'Completed';
          statusColor = Colors.red;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: CustomText(
        title: status,
        color: statusColor,
        size: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColor.primaryColor,
        ),
        Gap.w(6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: label,
              color: AppColor.black.withOpacity(0.6),
              size: 12,
              fontWeight: FontWeight.w400,
            ),
            CustomText(
              title: value,
              color: AppColor.black,
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrizeInfo(AllTournaments tournament) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tournament.isReward == 0
            ? Colors.grey.withOpacity(0.1)
            : AppColor.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            CustomAssets.prizeIcon,
            height: 16,
            color:
                tournament.isReward == 0 ? Colors.grey : AppColor.primaryColor,
          ),
          Gap.w(6),
          CustomText(
            title: tournament.isReward == 0
                ? 'No Prize'
                : tournament.isReward.toString(),
            color:
                tournament.isReward == 0 ? Colors.grey : AppColor.primaryColor,
            size: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
