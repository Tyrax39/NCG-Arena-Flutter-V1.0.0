import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/screens/wallet/view_model/wallet_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class BankWithdraw extends StatefulWidget {
  const BankWithdraw({super.key});

  @override
  State<BankWithdraw> createState() => _BankWithdrawState();
}

class _BankWithdrawState extends State<BankWithdraw> {
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
      final response = await walletVm.withdrawRequest('Bank');
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
      appBar: CommonAppBar(title: 'Bank'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Consumer<WalletViewModel>(builder: (context, walletVm, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.h(20),
                  CustomText(
                    title: LocaleKeys.withdrawFromYourBankAccount.tr(),
                    size: 16,
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(20),
                  CustomText(
                    title: LocaleKeys.enterName.tr(),
                    size: 18,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(10),
                  PrimaryTextField(
                    isPass: false,
                    onChange: (context) {
                      walletVm.emptyNameErrors();
                    },
                    hintText: LocaleKeys.enterFullName.tr(),
                    textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 12,
                    ),
                    errorText: '',
                    width: AppConfig(context).width,
                    controller: walletVm.fullName,
                    headingText: '',
                  ),
                  walletVm.nameError != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            walletVm.nameError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox(),
                  Gap.h(20),
                  CustomText(
                    title: LocaleKeys.address.tr(),
                    size: 18,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(10),
                  PrimaryTextField(
                    isPass: false,
                    onChange: (context) {
                      walletVm.emptyAddressErrors();
                    },
                    hintText: LocaleKeys.enterAddress.tr(),
                    textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 12,
                    ),
                    errorText: '',
                    width: AppConfig(context).width,
                    controller: walletVm.address,
                    headingText: '',
                  ),
                  walletVm.addressError != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            walletVm.addressError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox(),
                  Gap.h(20),
                  CustomText(
                    title: LocaleKeys.bankName.tr(),
                    size: 18,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(10),
                  PrimaryTextField(
                    isPass: false,
                    onChange: (context) {
                      walletVm.emptyBankNameErrors();
                    },
                    hintText: LocaleKeys.enterBankName.tr(),
                    textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 12,
                    ),
                    errorText: '',
                    width: AppConfig(context).width,
                    controller: walletVm.bankName,
                    headingText: '',
                  ),
                  walletVm.bankNameError != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            walletVm.bankNameError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox(),
                  Gap.h(20),
                  CustomText(
                    title: LocaleKeys.bankAccount.tr(),
                    size: 18,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(10),
                  PrimaryTextField(
                    isPass: false,
                    onChange: (context) {
                      walletVm.emptyAccountNumberErrors();
                    },
                    hintText: LocaleKeys.enterBankAccount.tr(),
                    textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 12,
                    ),
                    errorText: '',
                    width: AppConfig(context).width,
                    controller: walletVm.accountNumber,
                    headingText: '',
                  ),
                  walletVm.accountNumberError != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            walletVm.accountNumberError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox(),
                  // Gap.h(20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap.h(20),
                            CustomText(
                              title: LocaleKeys.iban.tr(),
                              size: 18,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            Gap.h(10),
                            PrimaryTextField(
                              isPass: false,
                              onChange: (context) {
                                walletVm.emptyIbanErrors();
                              },
                              hintText: LocaleKeys.enterIban.tr(),
                              textStyle: const TextStyle(
                                color: AppColor.grey,
                                fontSize: 12,
                              ),
                              errorText: '',
                              width: AppConfig(context).width,
                              controller: walletVm.iban,
                              headingText: '',
                            ),
                            walletVm.ibanError != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Text(
                                      walletVm.ibanError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Gap.w(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap.h(20),
                            CustomText(
                              title: LocaleKeys.amount.tr(),
                              size: 18,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            Gap.h(10),
                            PrimaryTextField(
                              isPass: false,
                              onChange: (context) {
                                walletVm.emptyAmountErrors();
                              },
                              hintText: LocaleKeys.enterAmount.tr(),
                              textStyle: const TextStyle(
                                color: AppColor.grey,
                                fontSize: 12,
                              ),
                              errorText: '',
                              width: AppConfig(context).width,
                              controller: walletVm.amount,
                              headingText: '',
                            ),
                            walletVm.amountError != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Text(
                                      walletVm.amountError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap.h(20),
                            CustomText(
                              title: LocaleKeys.country.tr(),
                              size: 18,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            Gap.h(10),
                            PrimaryTextField(
                              isPass: false,
                              onChange: (context) {
                                walletVm.emptyCountryErrors();
                              },
                              hintText: LocaleKeys.enterCountry.tr(),
                              textStyle: const TextStyle(
                                color: AppColor.grey,
                                fontSize: 12,
                              ),
                              errorText: '',
                              width: AppConfig(context).width,
                              controller: walletVm.country,
                              headingText: '',
                            ),
                            walletVm.countryError != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Text(
                                      walletVm.countryError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Gap.w(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap.h(20),
                            CustomText(
                              title: LocaleKeys.swiftCode.tr(),
                              size: 18,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            Gap.h(10),
                            PrimaryTextField(
                              isPass: false,
                              onChange: (context) {
                                walletVm.emptySwiftCodeErrors();
                              },
                              hintText: LocaleKeys.enterSwiftCode.tr(),
                              textStyle: const TextStyle(
                                color: AppColor.grey,
                                fontSize: 12,
                              ),
                              errorText: '',
                              width: AppConfig(context).width,
                              controller: walletVm.swiftCode,
                              headingText: '',
                            ),
                            walletVm.swiftCodeError != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Text(
                                      walletVm.swiftCodeError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )
                    ],
                  ),
                  Gap.h(40),
                  PrimaryBTN(
                    callback: () {
                      if (walletVm.bankValidator()) {
                        _createWithdrawRequest(
                            walletVm, context, _dialogueHelper);
                      }
                      print('111111111111111111111');
                    },
                    color: AppColor.primaryColor,
                    title: LocaleKeys.withdraw.tr(),
                    width: AppConfig(context).width,
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
