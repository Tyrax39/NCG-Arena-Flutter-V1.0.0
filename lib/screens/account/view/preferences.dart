import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/account/components/switch_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  bool _enable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: const CommonAppBar(title: LocaleKeys.preferences),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: LocaleKeys.audioBackground.tr(),
                    color: AppColor.black,
                    size: 15,
                    fontWeight: FontWeight.w900,
                  ),
                  Gap.h(10),
                  CustomText(
                    softWrap: true,
                    title: LocaleKeys.allowYourStream.tr(),
                    color: AppColor.black,
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(10),
                  Container(
                    height: 45,
                    width: AppConfig(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.offwhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CustomText(
                            softWrap: true,
                            title: LocaleKeys.always.tr(),
                            color: AppColor.black,
                            size: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_drop_down,
                          )
                        ],
                      ),
                    ),
                  ),
                  Gap.h(20),
                  CustomText(
                    title: LocaleKeys.audioAutoplaying.tr(),
                    color: AppColor.black,
                    size: 15,
                    fontWeight: FontWeight.w900,
                  ),
                  Gap.h(10),
                  CustomText(
                    softWrap: true,
                    title: LocaleKeys.chooseWhenVideos.tr(),
                    color: AppColor.black,
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap.h(10),
                  Container(
                    height: 45,
                    width: AppConfig(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.offwhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CustomText(
                            softWrap: true,
                            title: LocaleKeys.mobileDataAndWifi.tr(),
                            color: AppColor.black,
                            size: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_drop_down,
                          )
                        ],
                      ),
                    ),
                  ),
                  Gap.h(30),
                  Row(
                    children: [
                      CustomText(
                        softWrap: true,
                        title: LocaleKeys.automaticallyPopupPlayer.tr(),
                        color: AppColor.black,
                        size: 15,
                        fontWeight: FontWeight.w900,
                      ),
                      const Spacer(),
                      CustomSwitch(
                        value: _enable,
                        onChanged: (bool val) {
                          setState(() {
                            _enable = val;
                          });
                        },
                      ),
                    ],
                  ),
                  Gap.h(20),
                  Divider(
                    color: AppColor.border,
                  ),
                  Gap.h(20),
                  Row(
                    children: [
                      CustomText(
                        softWrap: true,
                        title: LocaleKeys.clearCache.tr(),
                        color: AppColor.black,
                        size: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                  Gap.h(30),
                  Row(
                    children: [
                      CustomText(
                        softWrap: true,
                        title: LocaleKeys.storage.tr(),
                        color: AppColor.black,
                        size: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
