import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/search/view/search_view.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';

class SearchTournamentTab extends StatelessWidget {
  final List<AllTournaments> data;
  final bool hasSearched;
  const SearchTournamentTab({super.key, required this.data, required this.hasSearched});

  @override
  Widget build(BuildContext context) {

    if (!hasSearched) {
      return buildMessage(
        context,
        "assets/lotties/searching.json",
        LocaleKeys.emptySearchText.tr(),
      );
    } else if (data.isEmpty) {
      return buildMessage(
        context,
        "assets/lotties/empty_search.json",
        LocaleKeys.thereAreNoSearchResults.tr(),
      );
    }
    return  Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: data.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var tournament = data[index];
                return InkWell(
                  onTap: () async {
                    Navigator.pushNamed(
                      context,
                      MyRoutes.tournamentDetailScreen,
                      arguments: data,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.screenBG,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: cacheImageView(image: tournament.banner ?? ''),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  softWrap: true,
                                  title: tournament.name ?? 'Unknown Tournament',
                                  color: AppColor.black,
                                  size: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                Gap.h(5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: AppColor.primaryColor,
                                      size: 12,
                                    ),
                                    Gap.w(5),
                                    CustomText(
                                      title: DateFormat("EEE MMM d, y")
                                          .format(tournament.dateIni!),
                                      color: AppColor.black,
                                      size: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Gap.w(15),
                                    Icon(
                                      Icons.timer,
                                      color: AppColor.primaryColor,
                                      size: 12,
                                    ),
                                    Gap.w(5),
                                    CustomText(
                                      title: tournament.startTime!,
                                      color: AppColor.black,
                                      size: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Gap.h(10),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: cacheImageView(
                                            image:
                                                tournament.organization?.logo ?? ''),
                                      ),
                                    ),
                                    Gap.w(10),
                                    CustomText(
                                      title: tournament.organization?.name ?? 'Unknown Organization',
                                      color: AppColor.black,
                                      size: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
