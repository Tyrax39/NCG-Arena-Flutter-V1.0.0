import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class SelectGame extends StatefulWidget {
  const SelectGame({super.key});

  @override
  State<SelectGame> createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  @override
  void initState() {
    Provider.of<TournamentCreateViewmodel>(context, listen: false).getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentCreateViewmodel>(
      builder: (context, tournamentVm, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // Header Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.sports_esports_rounded,
                      size: 48,
                      color: AppColor.primaryColor,
                    ),
                    Gap.h(16),
                    CustomText(
                      title: LocaleKeys.selectGame.tr(),
                      size: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                    Gap.h(8),
                    CustomText(
                      title: LocaleKeys.chooseGame.tr(),
                      size: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black.withOpacity(0.6),
                      alignment: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: _buildMainContent(tournamentVm),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (tournamentVm.gameData.isNotEmpty) ...[
                      CustomText(
                        title:
                            '${tournamentVm.gameData.length} ${LocaleKeys.availableGame.tr()}',
                        size: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black.withOpacity(0.6),
                      ),
                      Gap.h(16),
                    ],
                    PrimaryBTN(
                        height: 56,
                        callback: () {
                          _handleNext(context, tournamentVm);
                        },
                        borderRadius: 10,
                        color: AppColor.primaryColor,
                        title: LocaleKeys.next.tr(),
                        width: AppConfig(context).width),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(TournamentCreateViewmodel tournamentVm) {
    if (tournamentVm.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              color: AppColor.primaryColor,
              radius: 20,
            ),
            Gap.h(16),
            CustomText(
              title: LocaleKeys.loadingGames.tr(),
              size: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.black.withOpacity(0.6),
            ),
          ],
        ),
      );
    }

    if (tournamentVm.gameData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_esports_rounded,
              size: 64,
              color: AppColor.black.withOpacity(0.3),
            ),
            Gap.h(16),
            CustomText(
              title: LocaleKeys.noGamesAvailable.tr(),
              size: 18,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
              alignment: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: tournamentVm.gameData.length,
      itemBuilder: (context, index) {
        final game = tournamentVm.gameData[index];
        final isSelected = tournamentVm.selectedGameIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColor.offwhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryColor
                  : Colors.grey.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => tournamentVm.selectGameIndex(index, game.id!),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Game Image
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: cacheImageView(image: game.gameImage.toString()),
                      ),
                    ),
                    Gap.w(16),

                    // Game Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: game.gameName.toString(),
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                          if (game.gameType != null) ...[
                            Gap.h(4),
                            CustomText(
                              title: game.gameType.toString(),
                              size: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.black.withOpacity(0.6),
                              txtOverFlow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Selection Indicator
                    Gap.w(12),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColor.primaryColor
                              : Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                        color: isSelected
                            ? AppColor.primaryColor
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleNext(
      BuildContext context, TournamentCreateViewmodel tournamentVm) {
    if (tournamentVm.selectedGameIndex == -1) {
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
          snackbarMessage: SnackbarMessage.smallMessageError(
            content: LocaleKeys.pleaseSelectGame.tr(),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        );
      return;
    }
    tournamentVm.updatePagerIndex(3);
  }
}
