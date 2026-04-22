import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/screens/tournament_detail/view/updateScores/view_model/update_score_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UpdateScore extends StatefulWidget {
  final int id;
  const UpdateScore({
    super.key,
    required this.id,
  });
  @override
  State<UpdateScore> createState() => _UpdateScoreState();
}

class _UpdateScoreState extends State<UpdateScore> {
  @override
  void initState() {
    super.initState();
    context.read<MatchUpdateScoreViewModel>().getMatch(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.screenBG,
        appBar: CommonAppBar(title: LocaleKeys.updateScore.tr()),
        body: Consumer<MatchUpdateScoreViewModel>(
            builder: (context, matchDetailVm, child) {
          if (matchDetailVm.machData != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Gaming-style Header
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.primaryColor.withOpacity(0.8),
                          AppColor.primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.8)
                              ],
                            ).createShader(bounds),
                            child: Text(
                              "UPDATE SCORE",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Enter the final scores for both teams",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          // Decorative line
                          Container(
                            height: 3,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Teams Score Input Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.offwhite,
                          AppColor.offwhite.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppColor.border.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.08),
                          blurRadius: 15,
                          spreadRadius: 0,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Teams Row
                        Row(
                          children: [
                            // Team 1 Score Input
                            Expanded(
                              child: _buildEnhancedTeamScoreInput(
                                context: context,
                                teamData:
                                    matchDetailVm.machData!.competitor1Data,
                                controller: matchDetailVm.competitor1Controller,
                                errorText: matchDetailVm.competitor1Error,
                                onChanged: () =>
                                    matchDetailVm.clearCompetitor1Error(),
                                isLeft: true,
                              ),
                            ),

                            const SizedBox(width: 20),

                            // Team 2 Score Input
                            Expanded(
                              child: _buildEnhancedTeamScoreInput(
                                context: context,
                                teamData:
                                    matchDetailVm.machData!.competitor2Data,
                                controller: matchDetailVm.competitor2Controller,
                                errorText: matchDetailVm.competitor2Error,
                                onChanged: () =>
                                    matchDetailVm.clearCompetitor2Error(),
                                isLeft: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // VS Divider Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.primaryColor,
                                    AppColor.primaryColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColor.primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sports_esports,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'VS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Enhanced Update Score Button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildEnhancedUpdateScoreButton(
                      context: context,
                      onTap: () {
                        if (matchDetailVm.validateScores()) {
                          matchDetailVm.scoreUpdate(widget.id, context);
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(
                color: AppColor.primaryColor,
                radius: 22,
              ),
            );
          }
        }),
      ),
    );
  }

  // Enhanced Gaming-style Team Score Input
  Widget _buildEnhancedTeamScoreInput({
    required BuildContext context,
    required TeamData? teamData,
    required TextEditingController controller,
    required String? errorText,
    required VoidCallback onChanged,
    required bool isLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.white,
            AppColor.white.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: errorText != null
              ? AppColor.red.withOpacity(0.5)
              : AppColor.primaryColor.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: errorText != null
                ? AppColor.red.withOpacity(0.1)
                : AppColor.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Team Logo with enhanced styling
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.primaryColor.withOpacity(0.1),
                  AppColor.primaryColor.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: AppColor.primaryColor.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColor.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: teamData?.logo != null
                  ? CachedNetworkImage(
                      imageUrl: teamData!.logo!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.lightgrey,
                              AppColor.lightgrey.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.group,
                          color: AppColor.primaryColor,
                          size: 40,
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.lightgrey,
                              AppColor.lightgrey.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: AppColor.primaryColor,
                            radius: 15,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.lightgrey,
                            AppColor.lightgrey.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.group,
                        color: AppColor.primaryColor,
                        size: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Team Name with enhanced styling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor.withOpacity(0.1),
                  AppColor.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              teamData?.name ?? 'Unknown Team',
              style: TextStyle(
                color: AppColor.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          // Enhanced Score Input
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.white,
                  AppColor.offwhite.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: errorText != null
                    ? AppColor.red.withOpacity(0.5)
                    : AppColor.primaryColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: errorText != null
                      ? AppColor.red.withOpacity(0.1)
                      : AppColor.primaryColor.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged: (value) => onChanged(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  color: AppColor.grey.withOpacity(0.5),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          // Error Text with enhanced styling
          if (errorText != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                errorText,
                style: TextStyle(
                  color: AppColor.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Enhanced Gaming-style Update Score Button
  Widget _buildEnhancedUpdateScoreButton({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.primaryColor,
                  AppColor.primaryColor.withOpacity(0.8),
                  AppColor.primaryColor.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColor.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'UPDATE SCORE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ]))));
  }




}
