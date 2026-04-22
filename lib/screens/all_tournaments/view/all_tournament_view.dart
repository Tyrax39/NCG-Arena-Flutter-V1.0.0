import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/all_tournaments/view_model/all_tournament_view_model.dart';
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

class AllTournamentView extends StatefulWidget {
  const AllTournamentView({super.key});

  @override
  State<AllTournamentView> createState() => _AllTournamentViewState();
}

class _AllTournamentViewState extends State<AllTournamentView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeVm =
          Provider.of<AllTournamentViewModel>(context, listen: false);
      homeVm.getTournament();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.upcomingTournaments.tr()),
      body: SafeArea(
        child:
            Consumer<AllTournamentViewModel>(builder: (context, homeVm, child) {
          if (homeVm.tournamentData.isEmpty && !homeVm.isLoading) {
            return Center(
              child: Text(
                LocaleKeys.noTournamentsAvailable.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.black,
                ),
              ),
            );
          } else if (homeVm.isLoading) {
            return Center(
                child: CupertinoActivityIndicator(
              color: AppColor.primaryColor,
              radius: 20,
            ));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: homeVm.tournamentData.length,
                itemBuilder: (context, index) {
                  final tournament = homeVm.tournamentData[index];
                  return InkWell(
                    onTap: () async {
                      Navigator.pushNamed(
                        context,
                        MyRoutes.tournamentDetailScreen,
                        arguments: tournament,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      width: AppConfig(context).width * 0.7,
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
                                          : tournament.isReward.toString(),
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
                },
              ),
            );
          }
        }),
      ),
    );
  }
}
