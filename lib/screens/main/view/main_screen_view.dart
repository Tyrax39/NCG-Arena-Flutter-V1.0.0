// ignore_for_file: sized_box_for_whitespace, use_full_hex_values_for_flutter_colors, use_super_parameters, library_private_types_in_public_api

import 'package:neoncave_arena/screens/language/view_model/language_view_model.dart';
import 'package:neoncave_arena/utils/notifications_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/main/view_model/main_screen_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    NotificationServices notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenRefresh();
    notificationServices.setupInteractMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<MainScreenProvider, AppColor, LanguageViewModel>(
      builder: (context, screenIndexVm, appColor, languageVm, child) {
        return Scaffold(
          key: screenIndexVm.scaffoldKey,
          backgroundColor: AppColor.screenBG,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          extendBody: true,
          body: IndexedStack(
              index: screenIndexVm.index,
              children: screenIndexVm.bottomMap.values.toList()),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColor.screenBG,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x6E6E6E).withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: BottomAppBar(
              elevation: 0,
              color: Colors.transparent,
              shape: const CircularNotchedRectangle(),
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        screenIndexVm.updateBottomNavIndex(0);
                      },
                      child: Container(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            screenIndexVm.index == 0
                                ? Image.asset('assets/images/home_fill.png',
                                    height: 20,
                                    width: 20,
                                    color: AppColor.primaryColor)
                                : Image.asset(
                                    'assets/images/home_unfill.png',
                                    height: 20,
                                    width: 20,
                                    color: AppColor.grey,
                                  ),
                            Gap.h(5),
                            Text(
                              LocaleKeys.home.tr(),
                              style: TextStyle(
                                color: screenIndexVm.index == 0
                                    ? AppColor.primaryColor
                                    : AppColor.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        screenIndexVm.updateBottomNavIndex(1);
                      },
                      child: Container(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            screenIndexVm.index == 1
                                ? Image.asset('assets/images/explore_fill.png',
                                    height: 20,
                                    width: 20,
                                    color: AppColor.primaryColor)
                                : Image.asset(
                                    'assets/images/explore_unfill.png',
                                    height: 20,
                                    width: 20,
                                    color: AppColor.grey,
                                  ),
                            Gap.h(5),
                            Text(
                              LocaleKeys.discover.tr(),
                              style: TextStyle(
                                color: screenIndexVm.index == 1
                                    ? AppColor.primaryColor
                                    : AppColor.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        screenIndexVm.updateBottomNavIndex(2);
                      },
                      child: Container(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            screenIndexVm.index == 2
                                ? Image.asset('assets/images/leaderboardFill.png',
                                    height: 20,
                                    width: 20,
                                    color: AppColor.primaryColor)
                                : Image.asset(
                                    'assets/images/leaderboardUnfill.png',
                                    height: 20,
                                    width: 20,
                                    color: AppColor.grey,
                                  ),
                            Gap.h(5),
                            Text(
                              "Leaderboard",
                              style: TextStyle(
                                color: screenIndexVm.index == 2
                                    ? AppColor.primaryColor
                                    : AppColor.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        screenIndexVm.updateBottomNavIndex(3);
                      },
                      child: Container(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            screenIndexVm.index == 3
                                ? Image.asset(
                                    'assets/images/menufill.png',
                                    height: 20,
                                    width: 20,
                                    color: screenIndexVm.index == 3
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                  )
                                : Image.asset(
                                    'assets/images/menuUnfill.png',
                                    height: 20,
                                    width: 20,
                                    color: screenIndexVm.index == 3
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                  ),
                            Gap.h(5),
                            Text(
                              LocaleKeys.setting.tr(),
                              style: TextStyle(
                                color: screenIndexVm.index == 3
                                    ? AppColor.primaryColor
                                    : AppColor.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
