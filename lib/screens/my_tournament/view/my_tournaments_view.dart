import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/my_tournament/view_model/my_tournament_view_model.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class MyTournaments extends StatefulWidget {
  const MyTournaments({super.key});

  @override
  State<MyTournaments> createState() => _MyTournamentsState();
}

class _MyTournamentsState extends State<MyTournaments> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MyTournamentViewModel>().getMyTournament(0, false, context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<MyTournamentViewModel>().getMyTournament(
            context.read<MyTournamentViewModel>().offset, true, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(
        title: LocaleKeys.myTournaments.tr(),
      ),
      body: Consumer<MyTournamentViewModel>(
          builder: (context, tournamentVm, child) {
        if (tournamentVm.tournamentData.isEmpty && !tournamentVm.isLoading) {
          // Show message if the list is empty and not loading
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Icon(
                      Icons.emoji_events_outlined,
                      color: AppColor.black,
                      size: 60,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      LocaleKeys.noTournamentsAvailable.tr(),
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "inter",
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      textAlign: TextAlign.center,
                      LocaleKeys.youHaveNotCreatedAnyTournamentYet.tr(),
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: "inter",
                      ),
                    ),
                  ],
                ),
              ));
        } else if (tournamentVm.isLoading) {
          return Center(
              child: CupertinoActivityIndicator(
            color: AppColor.primaryColor,
            radius: 20,
          ));
        } else {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: tournamentVm.tournamentData.length,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final tournament = tournamentVm.tournamentData[index];
                  return InkWell(
                    onTap: () async {
                      Navigator.pushNamed(
                        context,
                        MyRoutes.tournamentDetailScreen,
                        arguments: tournament,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
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
                                imageUrl: tournament.banner ?? '',
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
                                  size: 12,
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
                                  size: 12,
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
                                      size: 10,
                                    ),
                                    Gap.w(5),
                                    CustomText(
                                      title: DateFormat('yyyy-MM-dd')
                                          .format(tournament.dateIni!),
                                      color: AppColor.black,
                                      size: 12,
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
                                      size: 12,
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
            ),
          );
        }
      }),
    );
  }
}
