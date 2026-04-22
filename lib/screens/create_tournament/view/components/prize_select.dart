import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrizeSelect extends StatelessWidget {
  const PrizeSelect({super.key});

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  @override
  Widget build(BuildContext context) {
    List dataPrize = [LocaleKeys.no.tr(), LocaleKeys.yes.tr()];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Trophy Icon and Header
          Gap.h(AppConfig(context).height * .1),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              size: 48,
              color: AppColor.primaryColor,
            ),
          ),
          Gap.h(24),

          // Question Text
          CustomText(
            alignment: TextAlign.center,
            softWrap: true,
            title: LocaleKeys.isARewardBeingOffered.tr(),
            size: 20,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
          Gap.h(8),

          CustomText(
            alignment: TextAlign.center,
            softWrap: true,
            title: LocaleKeys.tournamentPrizeText.tr(),
            size: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.black.withOpacity(0.6),
          ),
          Gap.h(32),
          // Yes/No Selection
          Consumer<TournamentCreateViewmodel>(
            builder: (context, value, child) {
              return value.userBalance == -1
                  ? Center(
                      child: CupertinoActivityIndicator(
                        color: AppColor.primaryColor,
                        radius: 22,
                      ),
                    )
                  : Row(
                      children: List.generate(
                        dataPrize.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: index == 1 ? 8 : 0,
                              right: index == 0 ? 8 : 0,
                            ),
                            child: InkWell(
                              onTap: () {
                                if (index == 1 && value.userBalance == 0) {
                                  _snackbarHelper
                                    ..injectContext(context)
                                    ..showSnackbar(
                                      snackbarMessage:
                                          SnackbarMessage.smallMessageError(
                                        content: LocaleKeys
                                            .yourWalletBalanceIsEmpty
                                            .tr(),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 100,
                                      ),
                                    );
                                  return;
                                }
                                context
                                    .read<TournamentCreateViewmodel>()
                                    .updatePrizeIndex(index);
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: value.selectedprizeindex == index
                                        ? AppColor.primaryColor
                                        : Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: value.selectedprizeindex == index
                                      ? AppColor.primaryColor.withOpacity(0.1)
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: CustomText(
                                    alignment: TextAlign.center,
                                    softWrap: true,
                                    title: dataPrize[index],
                                    size: 16,
                                    fontWeight: FontWeight.w600,
                                    color: value.selectedprizeindex == index
                                        ? AppColor.primaryColor
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            },
          ),

          Gap.h(32),
          // Prize Details Section
          Consumer<TournamentCreateViewmodel>(
            builder: (context, value, child) {
              return value.selectedprizeindex == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          softWrap: true,
                          title: LocaleKeys.rewardDetails.tr(),
                          size: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                        Gap.h(16),
                        // First Prize Input
                        _buildPrizeInput(
                          context: context,
                          label: LocaleKeys.firstPrize.tr(),
                          controller: value.firstPrizeController,
                          hint: LocaleKeys.enterFirstPrizeAmount.tr(),
                          icon: Icons.looks_one_rounded,
                        ),
                        Gap.h(16),
                        // Second Prize Input
                        _buildPrizeInput(
                          context: context,
                          label: LocaleKeys.secondPrize.tr(),
                          controller: value.secondPrizeController,
                          hint: LocaleKeys.enterSecondPrizeAmount.tr(),
                          icon: Icons.looks_two_rounded,
                        ),

                        if (value.userBalance > 0) ...[
                          Gap.h(12),
                          Text(
                            '${LocaleKeys.availableBalance}: ${value.userBalance}',
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    )
                  : const SizedBox();
            },
          ),
          Gap.h(32),
          // Error Message
          Consumer<TournamentCreateViewmodel>(
            builder: (context, value, child) {
              return value.errorText.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColor.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomText(
                              title: value.errorText,
                              size: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
            },
          ),
          Gap.h(24),
          // Next Button
          Consumer<TournamentCreateViewmodel>(
            builder: (context, value, child) {
              return PrimaryBTN(
                  height: 56,
                  callback: () {
                    _handleNext(context, value);
                  },
                  borderRadius: 10,
                  color: AppColor.primaryColor,
                  title: LocaleKeys.next.tr(),
                  width: AppConfig(context).width);
            },
          ),
          Gap.h(24),
        ],
      ),
    );
  }

  Widget _buildPrizeInput({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: label,
          size: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.black.withOpacity(0.8),
        ),
        Gap.h(8),
        Container(
          decoration: BoxDecoration(
            color: AppColor.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            style: TextStyle(fontSize: 12, color: AppColor.black),
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppColor.primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNext(BuildContext context, TournamentCreateViewmodel value) {
    if (value.selectedprizeindex == 1) {
      if (value.firstPrizeController.text.isEmpty) {
        value.updateFirstPrizeValidation(true, LocaleKeys.enterFirstPrize.tr());
        return;
      }
      if (value.secondPrizeController.text.isEmpty) {
        value.updateSecondPrizeValidation(
            true, LocaleKeys.enterSecondPrize.tr());
        return;
      }

      double totalPrize = double.parse(value.firstPrizeController.text) +
          double.parse(value.secondPrizeController.text);

      if (value.userBalance < totalPrize) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: SnackbarMessage.longMessageError(
              content: LocaleKeys.yourBalanceIsInsufficient.tr(),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
          );
        return;
      }
    }

    value.updateFirstPrizeValidation(false, "");
    value.updateSecondPrizeValidation(false, "");
    value.updatePagerIndex(1);
  }
}
