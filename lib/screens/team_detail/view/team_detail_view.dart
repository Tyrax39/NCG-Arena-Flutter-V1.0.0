import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/screens/team_detail/view_model/team_detail_view_model.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

class TeamDetailScreen extends StatefulWidget {
  final MyTeamModel teamData;
  const TeamDetailScreen({super.key, required this.teamData});

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  @override
  void initState() {
    context
        .read<TeamDetailViewModel>()
        .getTeamMembers(widget.teamData.id.toString());
    context.read<TeamDetailViewModel>().getUserFromSharedPref();
    debugPrint(
        'id of team -------------------${widget.teamData.id.toString()}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 180,
                        width: AppConfig(context).width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              widget.teamData.logo ?? '',
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryColor.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColor.primaryColor.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 50,
                        child: InkWell(
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
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.screenBG,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: cacheImageView(
                              image: widget.teamData.game!.gameImage ?? '',
                            ),
                          ),
                        ),
                        Gap.w(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.shield,
                                    size: 16,
                                    color: AppColor.primaryColor,
                                  ),
                                  Gap.w(4),
                                  Flexible(
                                    child: CustomText(
                                      title: widget.teamData.name ?? '',
                                      color: AppColor.black,
                                      size: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Gap.h(8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.sports_esports,
                                    size: 14,
                                    color: AppColor.grey,
                                  ),
                                  Gap.w(4),
                                  Flexible(
                                    child: CustomText(
                                      title:
                                          widget.teamData.game!.gameName ?? '',
                                      color: AppColor.grey,
                                      size: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  _buildSectionWithTitle(
                    title: LocaleKeys.description.tr(),
                    child: widget.teamData.about != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColor.screenBG,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColor.primaryColor.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: HtmlWidget(
                              '<p style="text-align: justify;">${widget.teamData.about}</p>',
                              renderMode: RenderMode.column,
                              textStyle: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                height: 1.5,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.screenBG,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColor.primaryColor.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: CustomText(
                                title: "No team description available",
                                color: AppColor.grey,
                                size: 13,
                              ),
                            ),
                          ),
                  ),

                  // Team Members Section
                  _buildSectionWithTitle(
                    title: LocaleKeys.teamMembers.tr(),
                    child: Column(
                      children: [
                        Consumer<TeamDetailViewModel>(
                          builder: (context, teamVm, child) {
                            // Sort the members list to put captain at the top
                            final sortedMembers =
                                List<Member>.from(teamVm.teamMembersData)
                                  ..sort((a, b) {
                                    // Sort by captain status (1 = captain comes first)
                                    return (b.captain ?? 0)
                                        .compareTo(a.captain ?? 0);
                                  });

                            if (sortedMembers.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColor.screenBG,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        AppColor.primaryColor.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.group_off,
                                        size: 32,
                                        color: AppColor.grey,
                                      ),
                                      Gap.h(8),
                                      const CustomText(
                                        title: "No team members yet",
                                        color: AppColor.grey,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: sortedMembers.length,
                              separatorBuilder: (context, index) => Divider(
                                color: AppColor.primaryColor.withOpacity(0.1),
                                height: 1,
                              ),
                              itemBuilder: (context, index) {
                                final data = sortedMembers[index];
                                final isCaptain = data.captain == 1;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: isCaptain
                                        ? AppColor.primaryColor
                                            .withOpacity(0.05)
                                        : AppColor.screenBG,
                                    borderRadius: index == 0
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          )
                                        : index == sortedMembers.length - 1
                                            ? const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              )
                                            : null,
                                    border: Border.all(
                                      color: AppColor.primaryColor
                                          .withOpacity(0.1),
                                      width: index == 0 ||
                                              index == sortedMembers.length - 1
                                          ? 1
                                          : 0,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    leading: Stack(
                                      children: [
                                        Container(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isCaptain
                                                  ? AppColor.primaryColor
                                                  : Colors.transparent,
                                              width: isCaptain ? 2 : 0,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: cacheImageView(
                                              image: data.profileImage ?? '',
                                            ),
                                          ),
                                        ),
                                        if (isCaptain)
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: AppColor.primaryColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColor.screenBG,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.stars,
                                                size: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    title: CustomText(
                                      title: data.username ?? '',
                                      color: AppColor.black,
                                      size: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    trailing: isCaptain
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.military_tech,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                                Gap.w(4),
                                                const CustomText(
                                                  title: 'Captain',
                                                  color: Colors.white,
                                                  size: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                          )
                                        : null,
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // Add Team Member Button
                        Consumer<TeamDetailViewModel>(
                          builder: (context, teamVm, child) {
                            final isCurrentUserCaptain = teamVm.userData !=
                                    null &&
                                widget.teamData.captain != null &&
                                teamVm.userData!.id == widget.teamData.captain;

                            if (!isCurrentUserCaptain) {
                              return const SizedBox
                                  .shrink(); // Hide the button if not captain
                            }
                            return Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: GestureDetector(
                                onTap: () {
                                  final teamId = widget.teamData.id.toString();
                                  Navigator.pushNamed(
                                      context, MyRoutes.addTeamView,
                                      arguments: [teamId]).then((value) {
                                    context
                                        .read<TeamDetailViewModel>()
                                        .getTeamMembers(teamId);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.primaryColor
                                            .withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Add New Team Member",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Gap.h(
                      24), // Reduced bottom padding since we don't have FAB anymore
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithTitle(
      {required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Gap.w(8),
                CustomText(
                  title: title,
                  color: AppColor.primaryColor,
                  size: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Gap.h(8),
          child,
        ],
      ),
    );
  }
}
