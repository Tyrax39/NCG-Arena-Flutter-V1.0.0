import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/auth/signup/view_model/signup_view_model.dart';
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

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  void _showFirebaseUnavailable() {
    _snackbarHelper
      ..injectContext(context)
      ..showSnackbar(
          snackbarMessage: SnackbarMessage.smallMessageError(
              content: FirebaseRuntime.socialAuthUnavailableMessage),
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
  }

  Future<void> _signup(SignupViewModel authVm, BuildContext context,
      DialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Account Creating....');
    try {
      final response = await authVm.signup(context);
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        print('response--- ${response.status}');
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
              content: 'Account Created Successfully',
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));

      Navigator.pushNamed(context, MyRoutes.otpView,
          arguments: [authVm.signupEmail.text]);
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(
        MaterialDialogContent.networkError(),
        () => _signup(
          authVm,
          context,
          dialogHelper,
        ),
      );
    }
  }

  Future<void> _socialLogin(SignupViewModel viewModel, BuildContext context,
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

  Future<void> _appleLogin(SignupViewModel viewModel, BuildContext context,
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
    SignupViewModel viewModel,
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

    final loginVm = context.read<SignupViewModel>();

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
            _dialogueHelper,
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
    final authVM = Provider.of<SignupViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Form(
                  key: _formKey,
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
                        }),
                      ),
                      Gap.h(30),
                      Center(
                        child: CustomText(
                          title: LocaleKeys.createNewAccount.tr(),
                          color: AppColor.primaryColor,
                          size: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Gap.h(5),
                      Center(
                        child: CustomText(
                          alignment: TextAlign.center,
                          title: LocaleKeys.fillYourInformation.tr(),
                          color: AppColor.black,
                          size: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Gap.h(30),
                      PrimaryTextField(
                        keyBoardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.words,
                        isPass: false,
                        onChange: (onChange) {
                          authVM.clearFirstNamerror();
                        },
                        hintText: LocaleKeys.enterFirstName.tr(),
                        textStyle: const TextStyle(
                            color: AppColor.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "inter"),
                        errorText: '',
                        width: 0,
                        controller: authVM.signupFirstName,
                        headingText: "",
                        prefixIcon: 'assets/images/nameIcon.png',
                      ),
                      authVM.firstNameError != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Text(
                                authVM.firstNameError!,
                                style: const TextStyle(
                                    color: AppColor.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(),
                      Gap.h(20),
                      PrimaryTextField(
                        keyBoardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.words,
                        isPass: false,
                        onChange: (onChange) {
                          authVM.clearLastNameError();
                        },
                        hintText: LocaleKeys.enterLastName.tr(),
                        textStyle: const TextStyle(
                            color: AppColor.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "inter"),
                        errorText: '',
                        width: 0,
                        controller: authVM.signupLastName,
                        headingText: "",
                        prefixIcon: 'assets/images/nameIcon.png',
                      ),
                      authVM.lastNameError != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Text(
                                authVM.lastNameError!,
                                style: const TextStyle(
                                    color: AppColor.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(),
                      Gap.h(20),
                      PrimaryTextField(
                        keyBoardType: TextInputType.emailAddress,
                        isPass: false,
                        onChange: (String? value) async {
                          if (value == null) return;

                          if (value.isNotEmpty &&
                              value.contains('@gmail.com')) {
                            bool validEmail = await authVM.checkEmailUsername(
                                email: authVM.signupEmail.text);

                            if (validEmail == true) {
                              authVM.clearEmailError();
                            } else {
                              authVM.emailError =
                                  LocaleKeys.emailAlreadyExist.tr();
                              authVM.notifyListeners();
                            }
                          } else {
                            authVM.clearEmailError();
                          }
                        },
                        hintText: LocaleKeys.enterEmail.tr(),
                        textStyle: const TextStyle(
                          color: AppColor.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        errorText: authVM.emailErrorText,
                        width: 0,
                        controller: authVM.signupEmail,
                        headingText: "",
                        prefixIcon: 'assets/images/email.png',
                      ),
                      authVM.emailError != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 6,
                              ),
                              child: Text(
                                authVM.emailError!,
                                style: const TextStyle(
                                  color: AppColor.red,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Gap.h(20),
                      PrimaryTextField(
                        keyBoardType: TextInputType.visiblePassword,
                        isPass: true,
                        onChange: (onChange) {
                          authVM.clearPasswordError();
                        },
                        hintText: LocaleKeys.enterPassword.tr(),
                        textStyle: const TextStyle(
                            color: AppColor.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "inter"),
                        errorText: '',
                        width: 0,
                        prefixIcon: 'assets/images/padlock.png',
                        controller: authVM.signupPassword,
                        headingText: "",
                      ),
                      authVM.passwordError != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Text(
                                authVM.passwordError!,
                                style: const TextStyle(
                                  color: AppColor.red,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Gap.h(20),
                      PrimaryTextField(
                        keyBoardType: TextInputType.visiblePassword,
                        isPass: true,
                        onChange: (onChange) {
                          authVM.clearConfirmPasswordError();
                        },
                        hintText: LocaleKeys.enterConfirmPassword.tr(),
                        textStyle: const TextStyle(
                            color: AppColor.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "inter"),
                        errorText: '',
                        width: 0,
                        prefixIcon: 'assets/images/padlock.png',
                        controller: authVM.signupCPassword,
                        headingText: "",
                      ),
                      authVM.confirmPasswordError != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Text(
                                authVM.confirmPasswordError!,
                                style: const TextStyle(
                                  color: AppColor.red,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Gap.h(20),
                      PrimaryBTN(
                        callback: () async {
                          if (authVM.signupValidator()) {
                            _signup(
                              authVM,
                              context,
                              _dialogueHelper,
                            );
                          }
                        },
                        color: AppColor.primaryColor,
                        title: LocaleKeys.signUp.tr(),
                        width: AppConfig(context).width - 0,
                      ),
                      Gap.h(20),
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
                      Gap.h(20),
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
                                border: Border.all(
                                  color: AppColor.border,
                                ),
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
                                debugPrint(result.toString());
                                if (result != null) {
                                  final googleAuth =
                                      await result.authentication;
                                  final credential =
                                      GoogleAuthProvider.credential(
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
                                      authVM,
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
                                debugPrint(error.toString());
                              }
                            },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColor.border,
                                ),
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

                                debugPrint(result.accessToken!.tokenString);

                                _socialLogin(
                                    authVM,
                                    context,
                                    _dialogueHelper,
                                    result.accessToken!.tokenString.toString(),
                                    'facebook');
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColor.border,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/facebook.png',
                                scale: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap.h(20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: RichText(
                            textWidthBasis: TextWidthBasis.parent,
                            text: TextSpan(
                              text: LocaleKeys.alreadyHaveAnAccount.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                              children: [
                                const WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: SizedBox(
                                    width: 10,
                                  ),
                                ),
                                TextSpan(
                                  text: LocaleKeys.signIn.tr(),
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
                      Gap.h(30),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
