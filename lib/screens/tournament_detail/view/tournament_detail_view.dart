import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/tournament_detail/view_model/tournament_detail_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'tournament_tab_view/brackets_tab.dart';
import 'tournament_tab_view/contacts_tab.dart';
import 'tournament_tab_view/overview_tab.dart';
import 'tournament_tab_view/participants_tab.dart';

class TournamentDetailScreen extends StatefulWidget {
  final AllTournaments tournamentData;
  const TournamentDetailScreen({super.key, required this.tournamentData});

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  @override
  void initState() {
    context
        .read<TournamentDetailViewmodel>()
        .getTournamentData(widget.tournamentData.id);
    context.read<TournamentDetailViewmodel>().getUserFromSharedPref();
    context.read<TournamentDetailViewmodel>().disposeValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: Consumer<TournamentDetailViewmodel>(
          builder: (context, detailVM, child) {
        if (detailVM.tournamentData != null) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: widget.tournamentData.banner!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    CustomAssets.placeholder,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                              placeholder: (context, url) => Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColor.primaryColor,
                                  radius: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          top: 50,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.grey.withOpacity(0.7),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Gap.h(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: widget.tournamentData.name.toString(),
                              color: AppColor.black,
                              size: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            Gap.h(10),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Consumer<TournamentDetailViewmodel>(
                                        builder: (context, value, child) {
                                      final data = value.userData;
                                      debugPrint(
                                          'user data ----------${data!.id}');
                                           debugPrint(
                                          'user data ----------${value.tournamentData!.id}');
                                      final time = value.remainingTime;
                                      debugPrint('time ---------${time}');
                                      return SizedBox(
                                        width: AppConfig(context).width * .8,
                                        child: Row(
                                          children: [
                                            if (value.userData != null) ...[
                                              if (value.tournamentData!
                                                      .tournamentStatus ==
                                                  "complete") ...[
                                                SizedBox(
                                                  width: 175,
                                                  height: 30,
                                                  child: PrimaryBTN(
                                                      width: 165,
                                                      borderRadius: 8,
                                                      color:
                                                          AppColor.primaryColor,
                                                      title:
                                                          'Tournament Complete',
                                                      callback: () {}),
                                                )
                                              ] else ...[
                                                if (value.tournamentData!
                                                        .userId !=
                                                    value.userData!.id) ...[
                                                  if (time.isEmpty) ...[
                                                    SizedBox(
                                                      // width: 150,
                                                      height: 30,
                                                      child: PrimaryBTN(
                                                          width: 155,
                                                          borderRadius: 8,
                                                          color: AppColor
                                                              .primaryColor,
                                                          fontSize: 13,
                                                          title:
                                                              'Registration Closed',
                                                          callback: () {}),
                                                    )
                                                  ] else ...[
                                                    value.tournamentData!
                                                                .isJoined ==
                                                            true
                                                        ? SizedBox(
                                                            width: 120,
                                                            height: 30,
                                                            child: PrimaryBTN(
                                                                width: 120,
                                                                borderRadius: 8,
                                                                color: AppColor
                                                                    .primaryColor,
                                                                title: 'Joined',
                                                                callback:
                                                                    () {}),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              if (value
                                                                      .tournamentData!
                                                                      .format
                                                                      .toString() ==
                                                                  "2") {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Consumer<
                                                                        TournamentDetailViewmodel>(
                                                                      builder: (context,
                                                                          valueModel,
                                                                          child) {
                                                                        final teamData =
                                                                            valueModel.userTeamData;
                                                                        if (teamData !=
                                                                            null) {
                                                                          return AlertDialog(
                                                                            backgroundColor:
                                                                                AppColor.screenBG,
                                                                            title:
                                                                                Center(
                                                                              child: Text(
                                                                                'Confirm Join Tournament',
                                                                                style: TextStyle(
                                                                                  color: AppColor.primaryColor,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            content:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                  child: CachedNetworkImage(
                                                                                    height: 80,
                                                                                    width: 100,
                                                                                    imageUrl: teamData.logo ?? '',
                                                                                    fit: BoxFit.cover,
                                                                                    errorWidget: (context, url, error) => Image.asset(CustomAssets.placeholder),
                                                                                    placeholder: (context, url) => Center(
                                                                                      child: CupertinoActivityIndicator(
                                                                                        color: AppColor.primaryColor,
                                                                                        radius: 12,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 10),
                                                                                RichText(
                                                                                  textAlign: TextAlign.center,
                                                                                  text: TextSpan(
                                                                                    text: "Do you want to proceed with joining this tournament with ",
                                                                                    style: const TextStyle(
                                                                                      color: AppColor.secondaryColor,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: teamData.name,
                                                                                        style: const TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                      const TextSpan(
                                                                                        text: "?",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: const Text('Cancel'),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop(false);
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                child: const Text('Join'),
                                                                                onPressed: () {
                                                                                  value.joinTournament(value.tournamentData!.id, context);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        } else {
                                                                          return AlertDialog(
                                                                            backgroundColor:
                                                                                AppColor.screenBG,
                                                                            title:
                                                                                Center(
                                                                              child: Text(
                                                                                'Confirm Join Tournament',
                                                                                style: TextStyle(
                                                                                  color: AppColor.primaryColor,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            content:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.error,
                                                                                  color: AppColor.primaryColor,
                                                                                ),
                                                                                const SizedBox(height: 10),
                                                                                Text(
                                                                                  "It looks like you don't have a team for this game to join the tournament.",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    color: AppColor.black,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: const Text('Go Back'),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop(false);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                value.joinTournament(
                                                                    value
                                                                        .tournamentData!
                                                                        .id!,
                                                                    context);
                                                              }
                                                            },
                                                            child: SizedBox(
                                                              width: 120,
                                                              height: 30,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Join Tournament',
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColor
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                  ],
                                                ] else ...[
                                                  value.tournamentData!.isStart
                                                              .toString() ==
                                                          "0"
                                                      ? SizedBox(
                                                          width: 120,
                                                          height: 30,
                                                          child: PrimaryBTN(
                                                            width: 120,
                                                            borderRadius: 0,
                                                            color: AppColor
                                                                .primaryColor,
                                                            title:
                                                                'Start Tournament',
                                                            fontSize: 12,
                                                            callback: () async {
                                                              bool? confirm =
                                                                  await showDialog<
                                                                      bool>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        AppColor
                                                                            .white,
                                                                    title:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Ready to Begin?',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              AppColor.primaryColor,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    content:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .warning_amber_rounded,
                                                                          size:
                                                                              48,
                                                                          color:
                                                                              Colors.amber,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                10),
                                                                        Text(
                                                                          'You are about to start the tournament',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColor.black,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Cancel'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(false);
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Proceed'),
                                                                        onPressed:
                                                                            () {
                                                                              
                                                                          Navigator.of(context)
                                                                              .pop(true);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );

                                                              if (confirm ==
                                                                  true) {
                                                                // Start the tournament
                                                                value.startTournament(
                                                                    value
                                                                        .tournamentData!
                                                                        .id!,
                                                                    context);
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          width: 200,
                                                          height: 30,
                                                          child: PrimaryBTN(
                                                              width: 30,
                                                              borderRadius: 8,
                                                              color: AppColor
                                                                  .primaryColor,
                                                              title:
                                                                  'Tournament Started',
                                                              callback:
                                                                  () async {}),
                                                        )
                                                ]
                                              ]
                                            ]
                                          ],
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ],
                            ),
                            Consumer<TournamentDetailViewmodel>(
                                builder: (context, value, child) {
                              final data = value.remainingTime;
                              if (data.isEmpty) {
                                return const SizedBox();
                              } else if (value.tournamentData!.isStart
                                      .toString() ==
                                  "0") {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColor.primaryColor.withOpacity(0.1),
                                        AppColor.primaryColor.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColor.primaryColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.schedule_rounded,
                                          color: AppColor.primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Tournament Starting",
                                              style: TextStyle(
                                                color: AppColor.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              data,
                                              style: TextStyle(
                                                color: AppColor.primaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "LIVE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Consumer<TournamentDetailViewmodel>(
                              builder: (context, value, child) {
                                final List<String> tabTitles = [
                                  LocaleKeys.overview.tr(),
                                  LocaleKeys.brackets.tr(),
                                  LocaleKeys.participants.tr(),
                                  LocaleKeys.contact.tr()
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
                                          value.setSelectedTabIndex(index);
                                        },
                                        child: SizedBox(
                                          width: AppConfig(context).width * .3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                title: tabTitles[index],
                                                size: 14,
                                                color: value.selectedTabIndex ==
                                                        index
                                                    ? AppColor.primaryColor
                                                    : AppColor.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Gap.h(3),
                                              value.selectedTabIndex == index
                                                  ? Container(
                                                      height: 2,
                                                      width: index == 0
                                                          ? 60
                                                          : index == 1
                                                              ? 60
                                                              : index == 2
                                                                  ? 80
                                                                  : 50,
                                                      color:
                                                          AppColor.primaryColor)
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
                                return value.selectedTabIndex == 0
                                    ? OverviewTab(
                                        tournamentData: value.tournamentData!,
                                      )
                                    : value.selectedTabIndex == 1
                                        ? BracketsTab(
                                            tournamentData:
                                                value.tournamentData!,
                                            currentUserId:
                                                value.userData!.id.toString(),
                                          )
                                        : value.selectedTabIndex == 2
                                            ? ParticipantsTab(
                                                tournamentData:
                                                    value.tournamentData!,
                                              )
                                            : value.selectedTabIndex == 3
                                                ? TournamentsContact(
                                                    tournamentData:
                                                        value.tournamentData!,
                                                  )
                                                : const SizedBox();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(
              color: AppColor.primaryColor,
              radius: 20,
            ),
          );
        }
      }),
    );
  }
}
