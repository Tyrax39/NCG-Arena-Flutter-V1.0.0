import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/basic_detail.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/info_detail.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/prize_select.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/select_game.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/select_organization.dart';
import 'package:neoncave_arena/screens/create_tournament/view/components/settings_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class CreateTournament extends StatefulWidget {
  const CreateTournament({super.key});

  @override
  State<CreateTournament> createState() => _CreateTournamentState();
}

class _CreateTournamentState extends State<CreateTournament> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: AppColor.black,
            height: 0.2,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        backgroundColor: AppColor.screenBG,
        elevation: 0,
        title: CustomText(
          title: LocaleKeys.createTournament.tr(),
          color: AppColor.black,
          size: 14,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        leading: Consumer<TournamentCreateViewmodel>(
          builder: (context, provider, child) {
            return IconButton(
              onPressed: () {
                provider.pagerIndex == 0
                    ? Navigator.pop(context)
                    : provider.updatePagerIndex(provider.pagerIndex - 1);
              },
              icon: Icon(
                Icons.arrow_back, // More modern back icon
                color: AppColor.black,
                size: 22,
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<TournamentCreateViewmodel>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // Progress indicator
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: LinearProgressIndicator(
                    value: (provider.pagerIndex + 1) / 6,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 8,
                  ),
                ),
                // Step indicator
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: CustomText(
                    title:
                        '${LocaleKeys.step.tr()} ${provider.pagerIndex + 1} ${LocaleKeys.of.tr()} 6',
                    size: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black.withOpacity(0.6),
                  ),
                ),
                // Main content
                Expanded(
                  child: PageView.builder(
                    controller: provider.pageSliderController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      provider.updatePagerIndex(index);
                    },
                    itemBuilder: (context, index) {
                      return Consumer<TournamentCreateViewmodel>(
                        builder: (context, value, child) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _buildCurrentPage(value.pagerIndex),
                          );
                        },
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 6, // Updated to match actual number of pages
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentPage(int index) {
    switch (index) {
      case 0:
        return const PrizeSelect();
      case 1:
        return const SelectOrganization();
      case 2:
        return const SelectGame();
      case 3:
        return BasicDetail();
      case 4:
        return const InfoDetail();
      case 5:
        return const SettingsDetail();
      default:
        return const SizedBox();
    }
  }
}
