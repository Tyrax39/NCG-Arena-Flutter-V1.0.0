import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neoncave_arena/screens/auth/change_password/change_password_provider.dart';
import 'package:neoncave_arena/utils/app_constants.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();
  DialogHelper get dialogHelper => DialogHelper.instance();

  Future<void> _changePassword(ChangePasswordProvider provider,
      BuildContext context, DialogHelper dialogHelper) async {
    // Validate inputs before API call
    if (!_validateInputs(provider, context)) {
      return;
    }

    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.loading.tr());
    try {
      final response = await provider.changePassword(context);
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage:
                SnackbarMessage.smallMessageError(content: response.message),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
          );
        return;
      } else {
        // All checks passed, show success message
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage: SnackbarMessage.smallMessage(
                content: LocaleKeys.passwordUpdatedSuccessfully.tr(),
              ),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));

        // Clear fields after successful update
        provider.clearFields();
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _changePassword(provider, context, dialogHelper));
    }
  }

  bool _validateInputs(ChangePasswordProvider provider, BuildContext context) {
    final String oldPassword = provider.currentPasswordController.text.trim();
    final String newPassword = provider.newPasswordController.text.trim();
    final String confirmPassword =
        provider.confirmPasswordController.text.trim();

    // Check if old password is empty
    if (oldPassword.isEmpty) {
      provider.updateCurrentPasswordError(
          true, LocaleKeys.oldPasswordEmpty.tr());
      return false;
    }

    // Check if new password is empty
    if (newPassword.isEmpty) {
      provider.updateNewPasswordError(true, LocaleKeys.enterNewPassword.tr());
      return false;
    }

    // Check if new password meets requirements
    bool hasCapitalLetter = newPassword.contains(RegExp(r'[A-Z]'));
    bool hasNumber = newPassword.contains(RegExp(r'\d'));
    bool hasSpecialCharacter =
        newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool isLongEnough = newPassword.length >= 8;

    if (!isLongEnough) {
      provider.updateNewPasswordError(true, LocaleKeys.atLeast8Characters.tr());
      return false;
    }

    if (!hasCapitalLetter) {
      provider.updateNewPasswordError(
          true, LocaleKeys.atLeastOneUppercase.tr());
      return false;
    }

    if (!hasNumber) {
      provider.updateNewPasswordError(true, LocaleKeys.atLeastOneNumber.tr());
      return false;
    }

    if (!hasSpecialCharacter) {
      provider.updateNewPasswordError(
          true, LocaleKeys.atLeastOneSpecialCharacter.tr());
      return false;
    }

    // Check if confirm password is empty
    if (confirmPassword.isEmpty) {
      provider.updateConfirmPasswordError(
          true, LocaleKeys.confirmPasswordEmpty.tr());
      return false;
    }

    // Check if passwords match
    if (newPassword != confirmPassword) {
      provider.updateConfirmPasswordError(
          true, LocaleKeys.passwordNotMatch.tr());
      return false;
    }

    // Check if new password is the same as old password
    if (oldPassword == newPassword) {
      provider.updateNewPasswordError(
          true, LocaleKeys.newPasswordSameAsOld.tr());
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChangePasswordProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.changePassword.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              const SizedBox(height: 30),
              Consumer<ChangePasswordProvider>(
                builder: (context, provider, _) => PrimaryTextField(
                  keyBoardType: TextInputType.visiblePassword,
                  isPass: false,
                  onChange: (value) {
                    if (value.isNotEmpty && provider.passwordError) {
                      provider.updateCurrentPasswordError(false, '');
                    }
                  },
                  hintText: LocaleKeys.enterOldPassword.tr(),
                  textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: "inter"),
                  errorText: provider.passwordError ? provider.errorText : '',
                  width: 0,
                  controller: provider.currentPasswordController,
                  headingText: "headingText",
                  prefixIcon: 'assets/images/padlock.png',
                ),
              ),
              provider.passwordError
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5, top: 6),
                      child: Text(
                        provider.errorText,
                        style:
                            const TextStyle(color: AppColor.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Consumer<ChangePasswordProvider>(
                builder: (context, provider, _) => PrimaryTextField(
                  keyBoardType: TextInputType.visiblePassword,
                  isPass: false,
                  onChange: (value) {
                    if (value.isNotEmpty && provider.newPasswordError) {
                      provider.updateNewPasswordError(false, '');
                    }
                  },
                  hintText: LocaleKeys.enterNewPassword.tr(),
                  textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: "inter"),
                  errorText:
                      provider.newPasswordError ? provider.errorText : '',
                  width: 0,
                  controller: provider.newPasswordController,
                  headingText: "headingText",
                  prefixIcon: 'assets/images/padlock.png',
                ),
              ),
              provider.newPasswordError
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5, top: 6),
                      child: Text(
                        provider.errorText,
                        style:
                            const TextStyle(color: AppColor.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Consumer<ChangePasswordProvider>(
                builder: (context, provider, _) => PrimaryTextField(
                  keyBoardType: TextInputType.visiblePassword,
                  isPass: true,
                  onChange: (value) {
                    if (value.isNotEmpty && provider.confirmPasswordError) {
                      provider.updateConfirmPasswordError(false, '');
                    }
                  },
                  hintText: LocaleKeys.enterConfirmPassword.tr(),
                  textStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: "inter"),
                  errorText:
                      provider.confirmPasswordError ? provider.errorText : '',
                  width: 0,
                  controller: provider.confirmPasswordController,
                  headingText: "headingText",
                  prefixIcon: 'assets/images/padlock.png',
                ),
              ),
              provider.confirmPasswordError
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5, top: 6),
                      child: Text(
                        provider.errorText,
                        style:
                            const TextStyle(color: AppColor.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              _buildPasswordRequirementsCard(),
              const SizedBox(height: 40),
              Consumer<ChangePasswordProvider>(
                builder: (context, provider, _) => PrimaryBTN(
                    callback: () {
                      _changePassword(provider, context, dialogHelper);
                    },
                    color: AppColor.primaryColor,
                    title: LocaleKeys.changePassword.tr(),
                    width: AppConfig(context).width - 0),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColor.offwhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.primaryColor.withOpacity(0.7),
                    AppColor.primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.changePassword.tr(),
              style: TextStyle(
                color: AppColor.black,
                fontFamily: AppConstants.fontBold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.yourPasswordMustContain.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black.withOpacity(0.7),
                fontFamily: AppConstants.fontRegular,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.offwhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.passwordRequirements.tr(),
            style: TextStyle(
              color: AppColor.black,
              fontFamily: AppConstants.fontMedium,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _buildRequirementRow(
              Icons.check_circle_outline, LocaleKeys.atLeast8Characters.tr()),
          _buildRequirementRow(
              Icons.check_circle_outline, LocaleKeys.atLeastOneUppercase.tr()),
          _buildRequirementRow(
              Icons.check_circle_outline, LocaleKeys.atLeastOneNumber.tr()),
          _buildRequirementRow(Icons.check_circle_outline,
              LocaleKeys.atLeastOneSpecialCharacter.tr()),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColor.black,
                fontFamily: AppConstants.fontRegular,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
