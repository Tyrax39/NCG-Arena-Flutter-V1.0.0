import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/auth/forgot_pasword/view_model/forgot_password_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();
  Future<void> _forgotPassword(ForgotPasswordViewModel forgotVm,
      BuildContext context, DialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await forgotVm.forgotPassword();
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        debugPrint('response--- in view ${response.status}');
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
              content: 'Password reset email sent successfully.',
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      Navigator.pushNamed(
        context,
        MyRoutes.resetPasswordVerification,
        arguments: [forgotVm.emailController.text],
      );
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _forgotPassword(forgotVm, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: LocaleKeys.forgotPassword.tr(),
      ),
      backgroundColor: AppColor.screenBG,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Consumer<ForgotPasswordViewModel>(
              builder: (context, forgotVm, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.h(30),
                        Center(
                          child: Image.asset(
                            'assets/images/forgotImage.png',
                            scale: 2.5,
                          ),
                        ),
                        Gap.h(30),
                        CustomText(
                          softWrap: true,
                          title: LocaleKeys.enterEmailText.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        Gap.h(30),
                        PrimaryTextField(
                          keyBoardType: TextInputType.emailAddress,
                          isPass: false,
                          hintText: LocaleKeys.enterEmail.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.emailIsRequired.tr(),
                          width: 0,
                          controller: forgotVm.emailController,
                          headingText: "headingText",
                          prefixIcon: 'assets/images/email.png',
                          onChange: (onChange) {
                            forgotVm.clearEmailError();
                          },
                        ),
                        forgotVm.emailError != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 6),
                                child: Text(
                                  forgotVm.emailError!,
                                  style: const TextStyle(
                                      color: AppColor.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        Gap.h(20),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: Consumer<ForgotPasswordViewModel>(
          builder: (context, forgotVm, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryBTN(
              callback: () {
                if (forgotVm.emailValidator()) {
                  _forgotPassword(
                    forgotVm,
                    context,
                    _dialogueHelper,
                  );
                }
                print('email------------${forgotVm.emailController.text}');
              },
              color: AppColor.primaryColor,
              title: LocaleKeys.continueText.tr(),
              width: AppConfig(context).width - 0),
        );
      }),
    );
  }
}
