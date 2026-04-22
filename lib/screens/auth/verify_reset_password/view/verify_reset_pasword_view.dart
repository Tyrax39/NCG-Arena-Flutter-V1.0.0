import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/auth/components/otp_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/auth/verify_reset_password/view_model/verify_reset_password_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class ResetPasswordVerification extends StatefulWidget {
  final String email;
  const ResetPasswordVerification({
    required this.email,
    super.key,
  });

  @override
  State<ResetPasswordVerification> createState() =>
      _ResetPasswordVerificationState();
}

class _ResetPasswordVerificationState extends State<ResetPasswordVerification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  @override
  void initState() {
    super.initState();
    // Start timer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VerifyResetPasswordViewModel>().startTimer();
    });
  }

  Future<void> _resetOtpVerify(VerifyResetPasswordViewModel resetVm,
      BuildContext context, DialogHelper dialogHelper, String email) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await resetVm.resetOtpVerifyApi(email);
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
            snackbarMessage: SnackbarMessage.smallMessage(
              content: 'Email verified successfully. You can now proceed.',
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      Navigator.pushNamed(context, MyRoutes.resetPassword,
          arguments: [widget.email]);
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _resetOtpVerify(resetVm, context, dialogHelper, email));
    }
  }

  Future<void> _resendOtp(VerifyResetPasswordViewModel resetVm,
      BuildContext context, DialogHelper dialogHelper, String email) async {
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
    return Scaffold(
      appBar: CommonAppBar(
        title: LocaleKeys.verifyAccount.tr(),
      ),
      backgroundColor: AppColor.screenBG,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.h(10),
                    CustomText(
                      title: LocaleKeys.verifyYourAccount.tr(),
                      color: AppColor.black,
                      size: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    RichText(
                      textWidthBasis: TextWidthBasis.parent,
                      text: TextSpan(
                        text: LocaleKeys.codeWeSentTo.tr(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black,
                        ),
                        children: [
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: SizedBox(width: 2)),
                          TextSpan(
                            text: widget.email,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap.h(50),
                    Consumer<VerifyResetPasswordViewModel>(
                        builder: (context, resetVm, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Center(
                          child: SizedBox(
                              width: AppConfig(context).width / 0,
                              child: OtpFormFields(
                                controller: resetVm.resetOtpController,
                                onComplete: () {},
                              )),
                        ),
                      );
                    }),
                    Gap.h(10),
                    Consumer<VerifyResetPasswordViewModel>(
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
                    Consumer<VerifyResetPasswordViewModel>(
                        builder: (context, resetVm, child) {
                      return PrimaryBTN(
                          callback: () async {
                            if (_formKey.currentState!.validate()) {
                              _resetOtpVerify(
                                resetVm,
                                context,
                                _dialogueHelper,
                                widget.email,
                              );
                            }
                          },
                          color: AppColor.primaryColor,
                          title: LocaleKeys.confirm.tr(),
                          width: AppConfig(context).width);
                    }),
                    Gap.h(20),
                    Consumer<VerifyResetPasswordViewModel>(
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
                                      widget.email,
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
            )
          ],
        ),
      ),
    );
  }
}
