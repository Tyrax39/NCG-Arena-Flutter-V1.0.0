import 'package:neoncave_arena/screens/language/view_model/language_view_model.dart';
import 'package:neoncave_arena/screens/main/view_model/main_screen_view_model.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/account/components/account_tile.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:neoncave_arena/screens/account/view/privacy_policy_screen.dart';
import 'package:neoncave_arena/screens/account/view/terms_of_service_screen.dart';
import 'package:neoncave_arena/screens/account/view/aboutUs.dart';

class AccountScreen extends StatefulWidget {
  static const String key_title = "/account_navigation_screen";

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  DialogHelper get _dialogHelper => DialogHelper.instance();

  @override
  void initState() {
    context.read<MainScreenProvider>().getUserFromSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppColor, LanguageViewModel, MainScreenProvider>(
      builder: (context, appColor, value, accountVm, child) {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Gap.h(20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context
                              .read<MainScreenProvider>()
                              .updateBottomNavIndex(0);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              AppBranding.headerLogo,
                              width: AppConfig(context).width * 0.42,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyRoutes.notificationsView);
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: AppColor.border,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/bell.png',
                            color: AppColor.primaryColor,
                            scale: 3.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap.h(20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Consumer<MainScreenProvider>(
                              builder: (context, profileVm, child) {
                            return profileVm.userData != null
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MyRoutes.userProfileScreen,
                                          arguments: [profileVm.userData!.id]);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: cacheImageView(
                                                image: profileVm.userData!
                                                        .profileImage ??
                                                    ''),
                                          ),
                                        ),
                                        Gap.w(10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              title:
                                                  "${profileVm.userData!.firstName} ${profileVm.userData!.lastName}",
                                              color: AppColor.black,
                                              size: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            CustomText(
                                              title: profileVm
                                                      .userData!.username ??
                                                  '',
                                              color: AppColor.grey,
                                              size: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                : const SizedBox();
                          }),
                          Gap.h(20),
                          Divider(
                            color: AppColor.border,
                          ),
                          Gap.h(20),
                          AccountTile(
                            image: 'assets/images/profile_fill.png',
                            iconColor: AppColor.teal,
                            iconBgColor:
                                const Color(0xff008080).withOpacity(0.13),
                            text: LocaleKeys.myOrganizations.tr(),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MyRoutes.myOrganizationView,
                              );
                            },
                          ),
                          Gap.h(20),
                          AccountTile(
                            image: 'assets/images/group.png',
                            iconColor: AppColor.pink,
                            iconBgColor:
                                const Color(0xffFFC0CB).withOpacity(0.13),
                            text: LocaleKeys.team.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, MyRoutes.teamView);
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/checked.png',
                            iconColor: AppColor.primaryColor,
                            iconBgColor:
                                const Color(0xff0056a9).withOpacity(0.13),
                            text: LocaleKeys.subscriptions.tr(),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyRoutes.subscription);
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/wallet.png',
                            iconColor: AppColor.maroon,
                            iconBgColor:
                                const Color(0xff800000).withOpacity(0.13),
                            text: LocaleKeys.wallet.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, MyRoutes.wallet);
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/bell-ring.png',
                            iconColor: AppColor.secondaryColor,
                            iconBgColor:
                                const Color(0xff01b0ef).withOpacity(0.13),
                            text: LocaleKeys.notification.tr(),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyRoutes.notificationsPreferences);
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/language.png',
                            iconColor: AppColor.primaryColor,
                            iconBgColor:
                                const Color(0xff0056a9).withOpacity(0.13),
                            text: LocaleKeys.language.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, MyRoutes.language);
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/padlock.png',
                            iconColor: AppColor.red,
                            iconBgColor: const Color.fromARGB(255, 241, 85, 50)
                                .withOpacity(0.13),
                            text: LocaleKeys.changePassword.tr(),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyRoutes.changePassword);
                            },
                          ),
                          Gap.h(25),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                      const Color(0xFF000000).withOpacity(0.13),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Image.asset(
                                    'assets/images/eye.png',
                                    scale: 5,
                                    color: AppColor.black,
                                  ),
                                ),
                              ),
                              Gap.w(20),
                              CustomText(
                                title: LocaleKeys.darkMode.tr(),
                                size: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.black,
                              ),
                              const Spacer(),
                              Transform.scale(
                                scale: .7,
                                child: CupertinoSwitch(
                                  activeColor: AppColor.themeSwitch,
                                  trackColor: AppColor.darkText,
                                  value: appColor.getTheme == ThemeMode.dark,
                                  onChanged: (value) {
                                    if (appColor.getTheme == ThemeMode.dark) {
                                      appColor.setTheme(ThemeMode.light);
                                    } else {
                                      appColor.setTheme(ThemeMode.dark);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/support.png',
                            iconColor: AppColor.pink,
                            iconBgColor:
                                const Color(0xffFFC0CB).withOpacity(0.13),
                            text: LocaleKeys.contact.tr(),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyRoutes.contactUsScreen);
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/terms-and-conditions.png',
                            iconColor: AppColor.yellow,
                            iconBgColor:
                                const Color(0xffEF9B0F).withOpacity(0.13),
                            text: LocaleKeys.termsOfServices.tr(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsOfServiceScreen(),
                                ),
                              );
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/information-button.png',
                            iconColor: AppColor.maroon,
                            iconBgColor:
                                const Color(0xff800000).withOpacity(0.13),
                            text: LocaleKeys.aboutUs.tr(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutUsScreen(),
                                ),
                              );
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/privacy.png',
                            iconColor: AppColor.teal,
                            iconBgColor:
                                const Color(0xff008080).withOpacity(0.13),
                            text: LocaleKeys.privacyPolicy.tr(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/logout.png',
                            iconColor: AppColor.red,
                            iconBgColor:
                                const Color(0xFFFF3131).withOpacity(0.13),
                            text: LocaleKeys.logout.tr(),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _dialogHelper
                                ..injectContext(context)
                                ..showLogoutDialouge(
                                  () {
                                    context
                                        .read<MainScreenProvider>()
                                        .logout(context);
                                  },
                                );
                            },
                          ),
                          Gap.h(25),
                          AccountTile(
                            image: 'assets/images/delete.png',
                            iconColor: AppColor.red,
                            iconBgColor:
                                const Color(0xFFFF3131).withOpacity(0.13),
                            text: LocaleKeys.deleteAccount.tr(),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _dialogHelper
                                ..injectContext(context)
                                ..showDeleteAccountDialogue(
                                  () {
                                    context
                                        .read<MainScreenProvider>()
                                        .logout(context);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        MyRoutes.selectionView,
                                        (route) => false);
                                  },
                                );
                            },
                          ),
                          Gap.h(20)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
