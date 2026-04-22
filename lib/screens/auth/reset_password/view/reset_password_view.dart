import 'package:neoncave_arena/Routes/app_routes.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/auth/components/password_success_popup.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/auth/reset_password/view_model/reset_password_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createNewPassword(ResetPasswordViewModel resetVm,
      BuildContext context, DialogHelper dialogHelper, String email) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await resetVm.createNewPasswordApi(email);
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
      showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing by tapping outside
          builder: (BuildContext context) {
            return const SuccessPopup();
          });

      // Navigate to login screen after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.loginView, (route) => false);
      });
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _createNewPassword(resetVm, context, dialogHelper, email));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('email in reset password ${widget.email}');
    return Scaffold(
      appBar: CommonAppBar(
        title: LocaleKeys.createNewPassword.tr(),
      ),
      backgroundColor: AppColor.screenBG,
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Consumer<ResetPasswordViewModel>(
              builder: (context, resetVm, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/newPassword.png',
                            scale: 2.5,
                          ),
                        ),
                        Gap.h(40),
                        CustomText(
                          softWrap: true,
                          title: LocaleKeys.pleaseEnterNewPassword.tr(),
                          color: AppColor.black,
                          size: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        Gap.h(40),
                        PrimaryTextField(
                          keyBoardType: TextInputType.visiblePassword,
                          isPass: true,
                          hintText: LocaleKeys.enterNewPassword.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.passwordIsRequired.tr(),
                          width: 0,
                          prefixIcon: 'assets/images/padlock.png',
                          controller: resetVm.newPasswordController,
                          headingText: "headingText",
                          onChange: (onChange) {
                            resetVm.clearNewPasswordError();
                          },
                        ),
                        resetVm.newPasswordError != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 6),
                                child: Text(
                                  resetVm.newPasswordError!,
                                  style: const TextStyle(
                                      color: AppColor.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        Gap.h(20),
                        PrimaryTextField(
                          keyBoardType: TextInputType.visiblePassword,
                          isPass: true,
                          hintText: LocaleKeys.enterConfirmPassword.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.passwordIsRequired.tr(),
                          width: 0,
                          prefixIcon: 'assets/images/padlock.png',
                          controller: resetVm.confirmPasswordController,
                          headingText: "",
                          onChange: (onChange) {
                            resetVm.clearConfirmPasswordError();
                          },
                        ),
                        resetVm.confirmPasswordError != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 6),
                                child: Text(
                                  resetVm.confirmPasswordError!,
                                  style: const TextStyle(
                                      color: AppColor.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        Gap.h(30),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar:
          Consumer<ResetPasswordViewModel>(builder: (context, resetVm, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryBTN(
            callback: () async {
              if (resetVm.newPasswordValidator()) {
                _createNewPassword(
                  resetVm,
                  context,
                  _dialogueHelper,
                  widget.email,
                );
              }
            },
            color: AppColor.primaryColor,
            title: LocaleKeys.continueText.tr(),
            width: AppConfig(context).width - 0,
          ),
        );
      }),
    );
  }
}
