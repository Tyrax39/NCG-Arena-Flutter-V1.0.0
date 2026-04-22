import 'dart:io';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as flutter_widgets;
import 'package:google_sign_in/google_sign_in.dart';

class DialogHelper {
  static DialogHelper? _instance;

  DialogHelper._();

  static DialogHelper instance() {
    _instance ??= DialogHelper._();
    return _instance!;
  }

  flutter_widgets.BuildContext? _context;

  bool get isProgressShowing => _context != null;

  void injectContext(BuildContext context) => _context = context;

  void dismissProgress({BuildContext? context}) {
    final tempContext = context ?? _context;
    if (tempContext == null) return;
    Navigator.pop(tempContext);
    _context = null;
  }

  void showTitleContentDialog(
      MaterialDialogContent dialogContent, VoidCallback positiveClosure,
      {VoidCallback? negativeClosure}) {
    final context = _context;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          contentPadding: const EdgeInsets.only(bottom: 0),
          backgroundColor: AppColor.screenBG,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    dialogContent.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    dialogContent.content,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: PrimaryBTN(
                      fontSize: 16,
                      color: AppColor.primaryColor,
                      callback: () {
                        Navigator.pop(context);
                        positiveClosure.call();
                      },
                      title: dialogContent.positiveText,
                      width: AppConfig(context).width,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    negativeClosure?.call();
                  },
                  child: Text(
                    dialogContent.negativeText,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDeleteAccountDialogue(
    VoidCallback positiveClosure,
  ) {
    final context = _context;
    if (context == null) return;
    final theme = Theme.of(context);

    showDialog(
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          contentPadding: const EdgeInsets.only(bottom: 0),
          backgroundColor: AppColor.screenBG,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.2)),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 40,
                      ),
                    )),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(LocaleKeys.deleteAccount.tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: AppColor.black, fontSize: 24)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: AppColor.black),
                      children: [
                        TextSpan(
                          text: LocaleKeys.areYouSureYouWantToDelete.tr(),
                        ),
                        TextSpan(
                          text: "${LocaleKeys.pleaseNote.tr()} ",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: LocaleKeys.ifYouLoginAgain.tr()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: PrimaryBTN(
                          height: 40,
                          fontSize: 15,
                          color: AppColor.red,
                          callback: () {
                            Navigator.pop(context);
                            positiveClosure.call();
                          },
                          title: LocaleKeys.deleteAccount.tr(),
                          width: AppConfig(context).width,
                        ),
                      ),
                      Gap.w(10),
                      Expanded(
                        child: PrimaryBTN(
                          height: 40,
                          fontSize: 15,
                          color: AppColor.primaryColor,
                          callback: () {
                            Navigator.pop(context);
                          },
                          title: LocaleKeys.cancel.tr(),
                          width: AppConfig(context).width,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  void showLogoutDialouge(
    VoidCallback positiveClosure,
  ) {
    final context = _context;
    if (context == null) return;
    final theme = Theme.of(context);
    showDialog(
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        builder: (_) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            contentPadding: const EdgeInsets.only(bottom: 0),
            backgroundColor: AppColor.screenBG,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber.withOpacity(0.2)),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.warning,
                            color: Colors.amber,
                            size: 40,
                          ),
                        )),
                    const SizedBox(height: 30),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(LocaleKeys.areYouSure.tr(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge!.copyWith(
                                color: AppColor.black, fontSize: 24))),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: AppColor.black, fontSize: 16),
                          children: [
                            TextSpan(
                              text: LocaleKeys.areYouSureText.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryBTN(
                          height: 40,
                          callback: () async {
                            await GoogleSignIn().signOut();
                            await FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                            positiveClosure.call();
                          },
                          title: LocaleKeys.logout.tr(),
                          fontSize: 16,
                          color: AppColor.red,
                          width: 100),
                    ),
                    Gap.w(10),
                    Expanded(
                      child: PrimaryBTN(
                          height: 40,
                          callback: () {
                            Navigator.pop(context);
                          },
                          title: LocaleKeys.cancel.tr(),
                          fontSize: 16,
                          color: AppColor.primaryColor,
                          width: 100),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  void showProgressDialog(String progressContent) {
    final context = _context;
    if (context == null) return;

    Platform.isIOS
        ? showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (dialogContext) {
              return WillPopScope(
                onWillPop: () async => false,
                child: CupertinoAlertDialog(
                  title: Text(
                    progressContent,
                  ),
                  content: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              );
            },
          )
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => WillPopScope(
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(strokeWidth: 2),
                      const SizedBox(width: 15),
                      Text(
                        progressContent,
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false,
            ),
          );
  }

  void showAddAmountDialog(
    Function(double) onAddPressed,
  ) {
    final context = _context;
    if (context == null) return;
    final TextEditingController amountController = TextEditingController();

    showDialog(
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          contentPadding: const EdgeInsets.only(bottom: 0),
          backgroundColor: AppColor.screenBG,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.2),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.addMoneyToWallet.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.enterAmountToWallet.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    style: TextStyle(color: AppColor.black, fontSize: 12),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.attach_money),
                      hintText: LocaleKeys.enterAmount.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: PrimaryBTN(
                        callback: () {
                          Navigator.pop(context);
                        },
                        color: AppColor.grey,
                        title: LocaleKeys.cancel.tr(),
                        width: AppConfig(context).width),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: PrimaryBTN(
                        callback: () {
                          final amount = double.tryParse(amountController.text);
                          if (amount != null && amount > 0) {
                            Navigator.pop(context);
                            onAddPressed(amount);
                          } else {
                            SnackbarHelper.instance()
                              ..injectContext(context)
                              ..showSnackbar(
                                snackbarMessage:
                                    SnackbarMessage.smallMessageError(
                                        content: LocaleKeys.enterAmountToWallet
                                            .tr()),
                                margin: const EdgeInsets.only(
                                    left: 25, right: 25, bottom: 90),
                              );
                          }
                        },
                        color: AppColor.primaryColor,
                        title: LocaleKeys.add.tr(),
                        width: AppConfig(context).width),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }





}
