// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:io';
import 'package:neoncave_arena/screens/auth/signup_verify/view_model/signup_verify_view_model.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_appbar.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/auth/components/otp_field.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupVerify extends StatefulWidget {
  final String userEmail;
  const SignupVerify({
    super.key,
    required this.userEmail,
  });

  @override
  State<SignupVerify> createState() => _SignupVerifyState();
}

class _SignupVerifyState extends State<SignupVerify> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  @override
  void initState() {
    super.initState();
    // Start timer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupVerifyViewModel>().startTimer();
    });
  }

  Future<void> _otpVerify(SignupVerifyViewModel authVm, BuildContext context,
      DialogHelper dialogHelper, String email) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.accountVerify.tr());
    try {
      final response = await authVm.otpVerifyApi(email);
      dialogHelper.dismissProgress();
      if (response.status == 200) {
        debugPrint('response freferf--- ${response.status}');
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage.smallMessage(
                content: LocaleKeys.accountVerifySuccessfully.tr(),
              ),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.profileView, arguments: true, (route) => false);
        return;
      }
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
          snackbarMessage:
              SnackbarMessage.smallMessageError(content: response.message),
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
        );
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _otpVerify(authVm, context, dialogHelper, email));
    }
  }

  Future<void> _resendOtp(SignupVerifyViewModel resetVm, BuildContext context,
      DialogHelper dialogHelper, String email) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await resetVm.resendOtp(email);
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

      // Start timer again after successful resend
      resetVm.startTimer();

      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: const SnackbarMessage.smallMessage(
              content:
                  'An otp code has been sent to your email. Please check and confirm.',
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _resendOtp(resetVm, context, dialogHelper, email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (Platform.isIOS && details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.screenBG,
        body: Consumer<SignupVerifyViewModel>(
          builder: (context, authVm, child) {
            return SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.h(10),
                    PrimaryAppBar(
                      title: LocaleKeys.verifyAccount.tr(),
                      isBackIcon: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap.h(20),
                          RichText(
                            text: TextSpan(
                              text: LocaleKeys.verifyYourAccountBy.tr(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.userEmail,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap.h(20),
                          Center(
                            child: SizedBox(
                                width: AppConfig(context).width / 0,
                                child: OtpFormFields(
                                  controller: authVm.registerOtp,
                                  onComplete: () {},
                                )),
                          ),
                          Gap.h(10),
                          Consumer<SignupVerifyViewModel>(
                              builder: (context, resetVm, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  title: LocaleKeys.resendCodeIn.tr(),
                                  color: AppColor.black,
                                  size: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                Gap.w(5),
                                Center(
                                  child: Text(
                                    resetVm.seconds > 9
                                        ? '00:${resetVm.seconds}'
                                        : '00:0${resetVm.seconds}',
                                    style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          Gap.h(30),
                          //confirm button
                          PrimaryBTN(
                              callback: () async {
                                if (_formKey.currentState!.validate()) {
                                  _otpVerify(authVm, context, _dialogueHelper,
                                      widget.userEmail);
                                }
                              },
                              color: AppColor.primaryColor,
                              title: LocaleKeys.confirm.tr(),
                              width: AppConfig(context).width - 0),
                          Gap.h(20),

                          //resend

                          Consumer<SignupVerifyViewModel>(
                            builder: (context, resetVm, child) {
                              // if (resetVm.seconds > 0) {
                              //   return const SizedBox
                              //       .shrink(); // Hide resend button while timer is active
                              // }
                              return Center(
                                child: GestureDetector(
                                  onTap: resetVm.seconds > 0
                                      ? null
                                      : () async {
                                          _resendOtp(
                                            resetVm,
                                            context,
                                            _dialogueHelper,
                                            widget.userEmail,
                                          );
                                        },
                                  child: Column(
                                    children: [
                                      CustomText(
                                        title: LocaleKeys.resend.tr(),
                                        color: resetVm.seconds > 0
                                            ? AppColor.grey
                                            : AppColor.black,
                                        size: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      Container(
                                        height: 1,
                                        width: 47,
                                        color: resetVm.seconds > 0
                                            ? AppColor.grey
                                            : AppColor.black,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
