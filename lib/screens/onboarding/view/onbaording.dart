// ignore_for_file: use_key_in_widget_constructors

import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/onboarding/view/onboarding_screens.dart';
import 'package:neoncave_arena/screens/onboarding/view_model/onboarding_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: Stack(
        children: [
          Consumer<OnBoardingViewModel>(
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: PageView(
                  controller: value.controller,
                  onPageChanged: value.setPage,
                  children: const [
                    Screen(index: 0),
                    Screen(index: 1),
                    Screen(index: 2),
                  ],
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: SizedBox(
                  height: 8,
                  width: 72,
                  child: Consumer<OnBoardingViewModel>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              index > 0 ? Gap.w(8) : Gap.w(0),
                              AnimatedContainer(
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 500),
                                width: index == value.currentIndex ? 40 : 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: index == value.currentIndex
                                      ? AppColor.primaryColor
                                      : AppColor.grey,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Gap.h(20),
              Consumer<OnBoardingViewModel>(
                builder: (context, value, child) {
                  return value.isLastPage
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 18),
                          child: PrimaryBTN(
                              callback: () {
                                onNavigateFromOnBoarding(
                                  context,
                                  onBoardingProvider: value,
                                );
                              },
                              color: AppColor.primaryColor,
                              title: LocaleKeys.getStarted.tr(),
                              width: AppConfig(context).width - 0))
                      // next page button
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 18),
                          child: PrimaryBTN(
                            callback: () {
                              value.controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            color: AppColor.primaryColor,
                            title: LocaleKeys.next.tr(),
                            width: AppConfig(context).width - 0,
                          ),
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> onNavigateFromOnBoarding(BuildContext context,
    {required OnBoardingViewModel onBoardingProvider}) async {
  Navigator.pushNamedAndRemoveUntil(
    context,
    MyRoutes.selectionView,
    (route) => false,
  );
}
