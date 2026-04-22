import 'package:neoncave_arena/screens/tournament_detail/view_model/tournament_detail_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class PrizeTab extends StatelessWidget {
  const PrizeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentDetailViewmodel>(
        builder: (context, value, child) {
      return value.tournamentData!.isReward != 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.h(20),
                value.tournamentData!.first != null
                    ? Row(
                        children: [
                          CustomText(
                            title: LocaleKeys.firstPrizeIs.tr(),
                            color: AppColor.black,
                            size: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          Gap.w(20),
                          CustomText(
                            title: "\$${value.tournamentData!.first} ",
                            color: AppColor.black,
                            size: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Gap.h(10),
                value.tournamentData!.second != null
                    ? Row(
                        children: [
                          CustomText(
                            title: LocaleKeys.secondPrizeIs.tr(),
                            color: AppColor.black,
                            size: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          Gap.w(20),
                          CustomText(
                            title: "\$${value.tournamentData!.second} ",
                            color: AppColor.black,
                            size: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Gap.h(20),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 50,
                      color: AppColor.black,
                    ),
                    Gap.h(16),
                    CustomText(
                      title: LocaleKeys.noPrizePool.tr(),
                      color: AppColor.black,
                      size: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    Gap.h(8),
                    CustomText(
                      alignment: TextAlign.center,
                      softWrap: true,
                      title: LocaleKeys.noPrizePoolDescription.tr(),
                      color: AppColor.black,
                      size: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    Gap.h(30),
                  ],
                ),
              ),
            );
    });
  }
}
