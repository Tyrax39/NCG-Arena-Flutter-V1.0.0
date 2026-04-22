// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/auth/login/view_model/login_view_model.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/firebase_runtime.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();
  SharedPreferenceHelper get _sharedPreferenceHelper =>
      SharedPreferenceHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  void _showFirebaseUnavailable() {
    _snackbarHelper
      ..injectContext(context)
      ..showSnackbar(
          snackbarMessage: SnackbarMessage.smallMessageError(
              content: FirebaseRuntime.socialAuthUnavailableMessage),
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
  }

  Future<void> performAppleLogin(BuildContext context) async {
    if (!FirebaseRuntime.isInitialized) {
      _showFirebaseUnavailable();
      return;
    }

    final loginVm = context.read<LoginViewModel>();

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
            (idToken?.isNotEmpty ?? false)) {
          await _firebaseLogin(
            loginVm,
            context,
            _dialogueHelper,
            email: email,
            firebaseUid: firebaseUser.uid,
            idToken: idToken!,
            name: givenName ?? "",
          );
        }
      }
    } catch (error) {
      debugPrint('Error during Apple sign-in: $error');
    }
  }

  Future<void> _appleLogin(LoginViewModel loginVm, BuildContext context,
      DialogHelper dialogHelper, email, name) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.logging.tr());
    try {
      final response = await loginVm.appleLogin(email, name);
      dialogHelper.dismissProgress();

      if (response.status != 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessageError(content: response.message),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
        return;
      }
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: SnackbarMessage.smallMessage(
                content: LocaleKeys.successfullyLoggedIn.tr()),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));

      Navigator.pushNamedAndRemoveUntil(
          context, MyRoutes.profileView, (route) => false);
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _appleLogin(loginVm, context, dialogHelper, email, name));
    }
  }

  Future<void> _firebaseLogin(
    LoginViewModel loginVm,
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
      final response = await loginVm.firebaseLogin(
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
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
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
                margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.profileView, (route) => false);
        } else {
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: LocaleKeys.successfullyLoggedIn.tr()),
                margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.mainScreen, arguments: true, (route) => false);
        }
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(
          MaterialDialogContent.networkError(),
          () => _firebaseLogin(loginVm, context, dialogHelper,
              email: email,
              firebaseUid: firebaseUid,
              idToken: idToken,
              name: name));
    }
  }

  Future<void> _socialLogin(LoginViewModel loginVm, BuildContext context,
      DialogHelper dialogHelper, token, provider) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.logging.tr());
    try {
      final response = await loginVm.socialLogin(token, provider);
      dialogHelper.dismissProgress();

      if (response.status != 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessageError(content: response.message),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
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
                margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.profileView, (route) => false);
        } else {
          // Profile is complete, go to main screen
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                    content: LocaleKeys.successfullyLoggedIn.tr()),
                margin: const EdgeInsets.only(left: 25, right: 25, bottom: 90));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.mainScreen, arguments: true, (route) => false);
        }
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _socialLogin(loginVm, context, dialogHelper, token, provider));
    }
  }

  Future<void> _login(LoginViewModel loginVm, BuildContext context,
      DialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.login.tr());
    try {
      final response = await loginVm.login();
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
      if (response.user != null) {
        if (response.user!.is_email_verified == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.otpView, (route) => false,
              arguments: [response.user!.email]);
        } else if (response.user!.is_profile_complete == 0) {
          // User is verified but profile is not complete, navigate to complete profile screen
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.profileView, (route) => false);
        } else {
          // All checks passed, navigate to main screen
          _snackbarHelper
            ..injectContext(context)
            ..showSnackbar(
                snackbarMessage: SnackbarMessage.smallMessage(
                  content: LocaleKeys.loginSuccessfully.tr(),
                ),
                margin:
                    const EdgeInsets.only(left: 25, right: 25, bottom: 100));

          await _sharedPreferenceHelper.insertUser(response.user!);
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.mainScreen, arguments: true, (route) => false);
        }
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _login(loginVm, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginVm = Provider.of<LoginViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.h(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColor.black,
                    ),
                  ),
                  Gap.h(30),
                  Center(
                    child: Consumer<AppColor>(
                      builder: (context, appColor, child) {
                        return AppBranding.authLogo(
                          context,
                          appColor.getTheme,
                        );
                      },
                    ),
                  ),
                  Gap.h(30),
                  Center(
                    child: CustomText(
                      title: LocaleKeys.loginToYourAccount.tr(),
                      color: AppColor.primaryColor,
                      size: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap.h(20),

                  PrimaryTextField(
                    keyBoardType: TextInputType.emailAddress,
                    isPass: false,
                    onChange: (onChange) {
                      loginVm.clearEmailError();
                    },
                    hintText: LocaleKeys.enterEmail.tr(),
                    textStyle: const TextStyle(
                        color: AppColor.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: "inter"),
                    errorText: LocaleKeys.emailIsRequired.tr(),
                    width: 0,
                    controller: loginVm.loginEmail,
                    headingText: "headingText",
                    prefixIcon: 'assets/images/email.png',
                  ),
                  loginVm.emailError != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 15, top: 6),
                          child: Text(
                            loginVm.emailError!,
                            style: const TextStyle(
                                color: AppColor.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox(),
                  Gap.h(20),
                  // Gap.h(10),
                  PrimaryTextField(
                    keyBoardType: TextInputType.visiblePassword,
                    isPass: true,
                    onChange: (onChange) {
                      loginVm.clearPasswordError();
                    },
                    hintText: LocaleKeys.enterPassword.tr(),
                    textStyle: const TextStyle(
                        color: AppColor.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: "inter"),
                    errorText: LocaleKeys.passwordIsRequired.tr(),
                    width: 0,
                    prefixIcon: 'assets/images/padlock.png',
                    controller: loginVm.loginPassword,
                    headingText: "",
                  ),
                  loginVm.passwordError != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 15, top: 6),
                          child: Text(
                            loginVm.passwordError!,
                            style: const TextStyle(
                                color: AppColor.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox(),
                  Gap.h(30),
                  PrimaryBTN(
                      callback: () {
                        if (loginVm.loginValidator()) {
                          _login(
                            loginVm,
                            context,
                            _dialogueHelper,
                          );
                        }
                      },
                      color: AppColor.primaryColor,
                      title: LocaleKeys.signIn.tr(),
                      width: AppConfig(context).width - 0),
                  Gap.h(20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MyRoutes.forgotPassword);
                      },
                      child: CustomText(
                        title: LocaleKeys.forgotPassword.tr(),
                        color: AppColor.primaryColor,
                        size: 13,
                        fontWeight: FontWeight.w600,
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
                            color: AppColor.border,
                            thickness: 1,
                          ),
                        ),
                        Gap.w(10),
                        CustomText(
                          title: LocaleKeys.orContinueWith.tr(),
                          color: AppColor.black,
                          size: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap.w(10),
                        Expanded(
                          child: Divider(
                            color: AppColor.border,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.h(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Theme.of(context).platform ==
                              TargetPlatform.android) {
                            _snackbarHelper
                              ..injectContext(context)
                              ..showSnackbar(
                                snackbarMessage:
                                    const SnackbarMessage.smallMessage(
                                  content:
                                      "Apple login is not available on Android.",
                                ),
                              );
                          } else {
                            performAppleLogin(context);
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColor.border),
                          ),
                          child: Image.asset(
                            'assets/images/apple-logo.png',
                            scale: 20,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                      Gap.w(20),
                      GestureDetector(
                        onTap: () async {
                          if (!FirebaseRuntime.isInitialized) {
                            _showFirebaseUnavailable();
                            return;
                          }

                          GoogleSignIn _googleSignIn = GoogleSignIn();
                          try {
                            var result = await _googleSignIn.signIn();
                            log(result.toString());
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
                                  loginVm,
                                  context,
                                  _dialogueHelper,
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
                            log(error.toString());
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColor.border),
                          ),
                          child: Image.asset(
                            'assets/images/goggle.png',
                            scale: 4,
                          ),
                        ),
                      ),
                      Gap.w(20),
                      GestureDetector(
                        onTap: () async {
                          FacebookAuth authIntance = FacebookAuth.instance;
                          try {
                            final result = await authIntance.login();
                            FacebookAuth.instance
                                .getUserData()
                                .then((value) {});

                            log(result.accessToken!.tokenString);

                            _socialLogin(
                                loginVm,
                                context,
                                _dialogueHelper,
                                result.accessToken!.tokenString.toString(),
                                'facebook');
                          } catch (e) {}
                        },
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColor.border),
                          ),
                          child: Image.asset(
                            'assets/images/facebook.png',
                            scale: 20,
                          ),
                        ),
                      ),
                    ],
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
                                fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
