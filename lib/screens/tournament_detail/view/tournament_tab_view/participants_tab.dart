import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/screens/tournament_detail/view_model/tournament_detail_view_model.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class ParticipantsTab extends StatefulWidget {
  final AllTournaments tournamentData;
  const ParticipantsTab({super.key, required this.tournamentData});

  @override
  State<ParticipantsTab> createState() => _ParticipantsTabState();
}

class _ParticipantsTabState extends State<ParticipantsTab> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    final viewModel =
        Provider.of<TournamentDetailViewmodel>(context, listen: true);
    bool isIndividualFormat = widget.tournamentData.format.toString() == "1";
    bool hasData = isIndividualFormat
        ? viewModel.participantsData.isNotEmpty
        : viewModel.teamsData.isNotEmpty;
    return hasData
        ? Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isIndividualFormat ? Icons.people : Icons.groups,
                        color: AppColor.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        title: isIndividualFormat
                            ? '${viewModel.participantsData.length} ${LocaleKeys.participants.tr()}'
                            : '${viewModel.teamsData.length} ${LocaleKeys.teams.tr()}',
                        color: AppColor.black,
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  if (viewModel.userData?.id == widget.tournamentData.userId)
                    CustomText(
                      title: LocaleKeys.admin.tr(),
                      color: AppColor.primaryColor,
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                ],
              ),
            ),
            Consumer<TournamentDetailViewmodel>(
                builder: (context, viewModel, child) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: isIndividualFormat
                    ? viewModel.participantsData.length
                    : viewModel.teamsData.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final SearchUsers? participant = isIndividualFormat
                      ? viewModel.participantsData[index]
                      : null;
                  final MyTeamModel? team =
                      !isIndividualFormat ? viewModel.teamsData[index] : null;
                  final String displayImage = isIndividualFormat
                      ? (participant?.profileImage ?? '')
                      : (team?.logo ?? '');
                  final String displayName = isIndividualFormat
                      ? (participant?.username ?? '')
                      : (team?.name ?? '');
                  return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColor.offwhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(children: [
                            Positioned(
                              right: -10,
                              top: -10,
                              child: Container(
                                width: 70,
                                height: 70,
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
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColor.black.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColor.primaryColor
                                            .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: displayImage,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                CustomAssets.placeholder),
                                        placeholder: (context, url) => Center(
                                          child: CupertinoActivityIndicator(
                                            color: AppColor.primaryColor,
                                            radius: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomText(
                                          title: displayName,
                                          color: AppColor.black,
                                          size: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(height: 4),
                                        CustomText(
                                          title: isIndividualFormat
                                              ? '${LocaleKeys.player.tr()} #${index + 1}'
                                              : '${LocaleKeys.team.tr()} #${index + 1}',
                                          color: AppColor.grey,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  viewModel.userData?.id ==
                                          widget.tournamentData.userId
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(LocaleKeys
                                                    .confirmDelete
                                                    .tr()),
                                                content: Text(
                                                  isIndividualFormat
                                                      ? '${LocaleKeys.confirmDeleteParticipant.tr()} $displayName?'
                                                      : '${LocaleKeys.confirmDeleteTeam.tr()} $displayName?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                        LocaleKeys.cancel.tr()),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      if (isIndividualFormat) {
                                                        viewModel
                                                            .removeUserParticipent(
                                                          userId: participant!
                                                              .id
                                                              .toString(),
                                                          index: index,
                                                          tournamentId: widget
                                                              .tournamentData.id
                                                              .toString(),
                                                          context: context,
                                                        );
                                                      } else {
                                                        viewModel
                                                            .removeTeamParticipent(
                                                          teamid: team!.id
                                                              .toString(),
                                                          index: index,
                                                          tournamentId: widget
                                                              .tournamentData.id
                                                              .toString(),
                                                          context: context,
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      LocaleKeys.delete.tr(),
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        )
                                      : Icon(
                                          Icons.arrow_forward_ios,
                                          color: AppColor.black,
                                          size: 16,
                                        ),
                                ],
                              ),
                            ),
                          ])));
                },
              );
            })
          ])
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size * .15),
                Icon(
                  Icons.group_outlined,
                  size: 64,
                  color: AppColor.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                CustomText(
                  title: isIndividualFormat
                      ? LocaleKeys.emptyParticipantsText.tr()
                      : LocaleKeys.emptyTeamsText.tr(),
                  color: AppColor.black,
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                CustomText(
                  title: isIndividualFormat
                      ? LocaleKeys.emptyParticipantsText.tr()
                      : LocaleKeys.emptyTeamsText.tr(),
                  color: AppColor.grey,
                  size: 14,
                ),
              ],
            ),
          );
  }
}
