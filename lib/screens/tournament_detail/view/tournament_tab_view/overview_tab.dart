import 'package:neoncave_arena/screens/tournament_detail/view/tournament_tab_view/detail_tab.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/tournament_tab_view/prize_tab.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/tournament_tab_view/rules_tab.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/tournament_tab_view/schedule_tab.dart';
import 'package:neoncave_arena/screens/tournament_detail/view_model/tournament_detail_view_model.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class OverviewTab extends StatefulWidget {
  final AllTournaments tournamentData;
  const OverviewTab({super.key, required this.tournamentData});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.tournamentData.description != null
            ? HtmlWidget(
                widget.tournamentData.description!,
                renderMode: RenderMode.column,
                textStyle: TextStyle(fontSize: 13, color: AppColor.black),
              )
            : const SizedBox(),
        Gap.h(20),
        Consumer<TournamentDetailViewmodel>(
          builder: (context, value, child) {
            final List<String> tabTitles = [
              LocaleKeys.detail.tr(),
              LocaleKeys.rules.tr(),
              LocaleKeys.prizes.tr(),
              LocaleKeys.schedule.tr()
            ];
            return SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabTitles.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      value.setSelectedOverviewTabIndex(index);
                    },
                    child: SizedBox(
                      width: AppConfig(context).width * .25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            title: tabTitles[index],
                            size: 14,
                            color: value.selectedOverviewTabIndex == index
                                ? AppColor.primaryColor
                                : AppColor.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          Gap.h(3),
                          value.selectedOverviewTabIndex == index
                              ? Container(
                                  height: 2,
                                  width: index == 0
                                      ? 45
                                      : index == 1
                                          ? 45
                                          : index == 2
                                              ? 45
                                              : index == 3
                                                  ? 60
                                                  : 60, // Adjust width for specific tabs if needed
                                  color: AppColor.primaryColor)
                              : const SizedBox(
                                  height: 2,
                                  width: 60,
                                )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        Gap.h(10),
        Consumer<TournamentDetailViewmodel>(
          builder: (context, value, child) {
            return value.selectedOverviewTabIndex == 0
                ? DetailTab(
                    tournamentdata: value.tournamentData!,
                  )
                : value.selectedOverviewTabIndex == 1
                    ? const RulesTab()
                    : value.selectedOverviewTabIndex == 2
                        ? const PrizeTab()
                        : value.selectedOverviewTabIndex == 3
                            ? const ScheduleTab()
                            : SizedBox();
          },
        ),
      ],
    );
  }
}
