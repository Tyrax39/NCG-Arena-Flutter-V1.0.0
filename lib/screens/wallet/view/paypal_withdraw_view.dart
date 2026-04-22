import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/screens/wallet/view_model/wallet_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class PaypalWithdraw extends StatefulWidget {
  const PaypalWithdraw({super.key});

  @override
  State<PaypalWithdraw> createState() => _PaypalWithdrawState();
}

class _PaypalWithdrawState extends State<PaypalWithdraw> {
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createWithdrawRequest(
    WalletViewModel walletVm,
    BuildContext context,
    DialogHelper dialogHelper,
  ) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Request Withdraw...');
    try {
      final response = await walletVm.withdrawRequest('Paypal');
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        debugPrint('response--- ${response.status}');
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage:
                SnackbarMessage.smallMessageError(content: response.message),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
          );
        return;
      }
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: const SnackbarMessage.smallMessage(
              content: 'Withdraw request Created successfully',
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _createWithdrawRequest(walletVm, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: const CommonAppBar(title: 'Paypal'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<WalletViewModel>(builder: (context, walletVm, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.h(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText(
                    title: LocaleKeys.withdrawFromYourPaypal.tr(),
                    size: 16,
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap.h(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText(
                    title: LocaleKeys.email.tr(),
                    size: 16,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap.h(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PrimaryTextField(
                    isPass: false,
                    onChange: (context) {
                      walletVm.emptyPaypalEmailErrors();
                    },
                    hintText: LocaleKeys.paypalEmail.tr(),
                    textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 12,
                    ),
                    errorText: '',
                    width: AppConfig(context).width,
                    controller: walletVm.paypalEmail,
                    headingText: '',
                  ),
                ),
                walletVm.paypalEmailError != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        child: Text(
                          walletVm.paypalEmailError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      )
                    : const SizedBox(),
                Gap.h(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CustomText(
                        title: LocaleKeys.amount.tr(),
                        size: 16,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      Gap.w(8),
                      CustomText(
                        title: '(USD)',
                        size: 18,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Gap.h(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PrimaryTextField(
                    isPass: false,
                    onChange: (context) {
                      walletVm.emptyAmountErrors();
                    },
                    hintText: LocaleKeys.amount.tr(),
                    textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 12,
                    ),
                    errorText: '',
                    width: AppConfig(context).width,
                    controller: walletVm.amount,
                    headingText: '',
                  ),
                ),
                walletVm.amountError != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        child: Text(
                          walletVm.amountError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      )
                    : const SizedBox(),
                Gap.h(40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PrimaryBTN(
                    callback: () {
                      if (walletVm.paypalValidator()) {
                        _createWithdrawRequest(
                            walletVm, context, _dialogueHelper);
                      }
                    },
                    color: AppColor.primaryColor,
                    title: LocaleKeys.withdraw.tr(),
                    width: AppConfig(context).width,
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
