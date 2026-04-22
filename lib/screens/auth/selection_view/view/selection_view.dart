// ignore_for_file: use_build_context_synchronously

import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/auth/selection_view/view_model/selection_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/firebase_runtime.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SelectionView extends StatefulWidget {
  const SelectionView({super.key});

  @override
  State<SelectionView> createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView> {
  DialogHelper get _dialogHelper => DialogHelper.instance();
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  void _showFirebaseUnavailable() {
    _snackbarHelper
      ..injectContext(context)
      ..showSnackbar(
          snackbarMessage: SnackbarMessage.smallMessageError(
              content: FirebaseRuntime.socialAuthUnavailableMessage),
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
  }

  Future<void> _socialLogin(SelectionViewModel viewModel, BuildContext context,
      DialogHelper dialogHelper, token, provider) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.logging.tr());
    try {
      final response = await viewModel.socialLogin(token, provider);
      dialogHelper.dismissProgress();

      if (response.status != 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessageError(content: response.message),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
        return;
      }

      if (response.user != null) {
        // Check if user needs profile completion
        if (response.user!.is_email_verified == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.otpView, (route) => false,
              arguments: [response.user!.email]);
        } else if (response.user!.is_profile_complete == 0 ||
            response.user!.username == null ||
            response.user!.username!.isEmpty) {
          // User needs profile completion - missing username or profile incomplete
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: "Please complete your profile"),
                margin:
                    const EdgeInsets.only(left: 25, right: 25, bottom: 100));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.profileView, (route) => false);
        } else {
          // Profile is complete, go to main screen
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: LocaleKeys.successfullyLoggedIn.tr()),
                margin:
                    const EdgeInsets.only(left: 25, right: 25, bottom: 100));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.mainScreen, arguments: true, (route) => false);
        }
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(
          MaterialDialogContent.networkError(),
          () =>
              _socialLogin(viewModel, context, dialogHelper, token, provider));
    }
  }

  Future<void> _appleLogin(SelectionViewModel viewModel, BuildContext context,
      DialogHelper dialogHelper, email, name) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.logging.tr());
    try {
      final response = await viewModel.appleLogin(email, name);
      dialogHelper.dismissProgress();

      if (response.status != 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessageError(content: response.message),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
        return;
      }

      if (response.user != null) {
        // Check if user needs profile completion
        if (response.user!.is_email_verified == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.otpView, (route) => false,
              arguments: [response.user!.email]);
        } else if (response.user!.is_profile_complete == 0 ||
            response.user!.username == null ||
            response.user!.username!.isEmpty) {
          // User needs profile completion - missing username or profile incomplete
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: "Please complete your profile"),
                margin:
                    const EdgeInsets.only(left: 25, right: 25, bottom: 100));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.profileView, (route) => false);
        } else {
          // Profile is complete, go to main screen
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: LocaleKeys.successfullyLoggedIn.tr()),
                margin:
                    const EdgeInsets.only(left: 25, right: 25, bottom: 100));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.mainScreen, arguments: true, (route) => false);
        }
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _appleLogin(viewModel, context, dialogHelper, email, name));
    }
  }

  Future<void> _firebaseLogin(
    SelectionViewModel viewModel,
    BuildContext context,
    DialogHelper dialogHelper, {
    required String email,
    required String firebaseUid,
    required String idToken,
    String name = '',
  }) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.logging.tr());
    try {
      final response = await viewModel.firebaseLogin(
        email: email,
        firebaseUid: firebaseUid,
        idToken: idToken,
        name: name,
      );
      dialogHelper.dismissProgress();

      if (response.status != 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessageError(content: response.message),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
        return;
      }

      if (response.user != null) {
        if (response.user!.is_email_verified == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.otpView, (route) => false,
              arguments: [response.user!.email]);
        } else if (response.user!.is_profile_complete == 0 ||
            response.user!.username == null ||
            response.user!.username!.isEmpty) {
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: "Please complete your profile"),
                margin:
                    const EdgeInsets.only(left: 25, right: 25, bottom: 100));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.profileView, (route) => false);
        } else {
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: LocaleKeys.successfullyLoggedIn.tr()),
                margin:
                    const EdgeInsets.only(left: 25, right: 25, bottom: 100));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.mainScreen, arguments: true, (route) => false);
        }
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(
          MaterialDialogContent.networkError(),
          () => _firebaseLogin(viewModel, context, dialogHelper,
              email: email,
              firebaseUid: firebaseUid,
              idToken: idToken,
              name: name));
    }
  }

  Future<void> performAppleLogin(BuildContext context) async {
    if (!FirebaseRuntime.isInitialized) {
      _showFirebaseUnavailable();
      return;
    }

    final loginVm = context.read<SelectionViewModel>();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider("apple.com");
      final authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      final firebaseUser = authResult.user;

      if (firebaseUser != null) {
        final givenName = firebaseUser.displayName;
        final email = firebaseUser.email;
        final idToken = await firebaseUser.getIdToken();
        if (email != null &&
            email.isNotEmpty &&
            idToken != null &&
            idToken.isNotEmpty) {
          await _firebaseLogin(
            loginVm,
            context,
            _dialogHelper,
            email: email,
            firebaseUid: firebaseUser.uid,
            idToken: idToken,
            name: givenName ?? "",
          );
        }
      }
    } catch (error) {
      debugPrint('Error during Apple sign-in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SelectionViewModel>();
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gap.h(50),
                Consumer<AppColor>(builder: (context, appColor, child) {
                  return AppBranding.authLogo(
                    context,
                    appColor.getTheme,
                  );
                }),
                Gap.h(30),
                Center(
                  child: CustomText(
                    title: LocaleKeys.letsYouIn.tr(),
                    color: AppColor.primaryColor,
                    size: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap.h(20),
                GestureDetector(
                  onTap: () async {
                    if (!FirebaseRuntime.isInitialized) {
                      _showFirebaseUnavailable();
                      return;
                    }

                    GoogleSignIn _googleSignIn = GoogleSignIn();
                    try {
                      var result = await _googleSignIn.signIn();
                      debugPrint(result.toString());
                      if (result != null) {
                        final googleAuth = await result.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        final authResult = await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        final firebaseUser = authResult.user;
                        final firebaseIdToken =
                            await firebaseUser?.getIdToken();
                        if (firebaseUser != null &&
                            firebaseUser.email != null &&
                            firebaseIdToken != null &&
                            firebaseIdToken.isNotEmpty) {
                          await _firebaseLogin(
                            viewModel,
                            context,
                            _dialogHelper,
                            email: firebaseUser.email!,
                            firebaseUid: firebaseUser.uid,
                            idToken: firebaseIdToken,
                            name: firebaseUser.displayName ??
                                result.displayName ??
                                '',
                          );
                        }
                      }
                    } catch (error) {
                      debugPrint(error.toString());
                    }
                  },
                  child: Container(
                    height: 55,
                    width: AppConfig(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/goggle.png',
                          scale: 4,
                        ),
                        Gap.w(20),
                        CustomText(
                          title: LocaleKeys.continueWithGoogle.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap.h(10),
                GestureDetector(
                  onTap: () async {
                    FacebookAuth authIntance = FacebookAuth.instance;
                    try {
                      final result = await authIntance.login();
                      FacebookAuth.instance.getUserData().then((value) {});
                      debugPrint(result.accessToken!.tokenString);
                      _socialLogin(
                          viewModel,
                          context,
                          _dialogHelper,
                          result.accessToken!.tokenString.toString(),
                          'facebook');
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: Container(
                    height: 55,
                    width: AppConfig(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/facebook.png',
                          scale: 20,
                        ),
                        Gap.w(10),
                        CustomText(
                          title: LocaleKeys.continueWithFacebook.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap.h(10),
                GestureDetector(
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      _snackbarHelper
                        ..injectContext(context)
                        ..showSnackbar(
                          snackbarMessage: const SnackbarMessage.smallMessage(
                            content: "Apple login is not available on Android.",
                          ),
                        );
                    } else {
                      performAppleLogin(context);
                    }
                  },
                  child: Container(
                    height: 55,
                    width: AppConfig(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/apple-logo.png',
                          scale: 20,
                          color: AppColor.black,
                        ),
                        Gap.w(20),
                        CustomText(
                          title: LocaleKeys.continueWithApple.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap.h(40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColor.lightgrey,
                          thickness: 1,
                        ),
                      ),
                      Gap.w(10),
                      CustomText(
                        title: LocaleKeys.or.tr(),
                        color: AppColor.black,
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap.w(10),
                      Expanded(
                        child: Divider(
                          color: AppColor.lightgrey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap.h(30),
                PrimaryBTN(
                  callback: () async {
                    Navigator.pushNamed(
                      context,
                      MyRoutes.loginView,
                    );
                  },
                  color: AppColor.primaryColor,
                  title: LocaleKeys.signInWithEmail.tr(),
                  width: AppConfig(context).width - 0,
                ),
                Gap.h(30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MyRoutes.signUpView,
                    );
                  },
                  child: Center(
                    child: RichText(
                      textWidthBasis: TextWidthBasis.parent,
                      text: TextSpan(
                        text: LocaleKeys.dontHaveAnAccount.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                        children: [
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: SizedBox(width: 10)),
                          TextSpan(
                            text: LocaleKeys.signUp.tr(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
