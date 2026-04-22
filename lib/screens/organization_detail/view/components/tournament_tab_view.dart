import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/organization_detail/view_model/organization_detail_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:provider/provider.dart';

class TournamentTabView extends StatefulWidget {
  String id;
  TournamentTabView({super.key, required this.id});

  @override
  State<TournamentTabView> createState() => _TournamentTabViewState();
}

class _TournamentTabViewState extends State<TournamentTabView> {
  @override
  void initState() {
    // No need to call API here anymore, it's handled by the main view
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final organizationVm =
        Provider.of<OrganizationViewModel>(context, listen: true);
    return Column(children: [
      if (organizationVm.isTournamentLoading == true) ...[
        SizedBox(
          height: AppConfig(context).height * .15,
        ),
        Center(
          child: CircularProgressIndicator(
            color: AppColor.primaryColor,
          ),
        ),
      ] else ...[
        organizationVm.tournamentData.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: organizationVm.tournamentData.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var tournamentData = organizationVm.tournamentData[index];
                  return InkWell(
                    onTap: () async {
                      Navigator.pushNamed(
                        context,
                        MyRoutes.tournamentDetailScreen,
                        arguments: tournamentData,
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: AppConfig(context).height * .15,
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
                                imageUrl: tournamentData.banner!,
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
                                  title: tournamentData.gameName ?? '',
                                  color: AppColor.primaryColor,
                                  size: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                                // const SizedBox(height: 5),
                                CustomText(
                                  title: tournamentData.name.toString(),
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
                                  title:
                                      tournamentData.organization!.name ?? '',
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
                                          .format(tournamentData.dateIni!),
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
                                      title: tournamentData.isReward == 0
                                          ? 'No Prize'
                                          : tournamentData.isReward.toString(),
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
              )
            : SizedBox(
                height: AppConfig(context).height * .25,
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
                )),
      ],
    ]);
  }
}
