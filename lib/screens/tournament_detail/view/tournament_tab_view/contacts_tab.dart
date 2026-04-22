import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TournamentsContact extends StatelessWidget {
  final AllTournaments tournamentData;
  const TournamentsContact({super.key, required this.tournamentData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (tournamentData.contactOption == "1") ...[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.offwhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  CustomAssets.discord,
                                  color: AppColor.primaryColor,
                                  height: 25,
                                ),
                              ),
                            ),
                            Gap.w(20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: LocaleKeys.discord,
                                    color: AppColor.black,
                                    size: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    txtOverFlow: TextOverflow.visible,
                                    softWrap: true,
                                    title: tournamentData.contactValue!,
                                    color: AppColor.blue,
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  if (tournamentData.contactOption == "2") ...[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.offwhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  CustomAssets.youtube,
                                  color: AppColor.primaryColor,
                                  height: 25,
                                ),
                              ),
                            ),
                            Gap.w(20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: LocaleKeys.youtube,
                                    color: AppColor.black,
                                    size: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    txtOverFlow: TextOverflow.visible,
                                    softWrap: true,
                                    title: tournamentData.contactValue!,
                                    color: AppColor.blue,
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  if (tournamentData.contactOption.toString() == "3") ...[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.offwhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  CustomAssets.facebook,
                                  color: AppColor.primaryColor,
                                  height: 25,
                                ),
                              ),
                            ),
                            Gap.w(20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: LocaleKeys.facebook,
                                    color: AppColor.black,
                                    size: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    txtOverFlow: TextOverflow.visible,
                                    softWrap: true,
                                    title: tournamentData.contactValue!,
                                    color: AppColor.blue,
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  if (tournamentData.contactOption.toString() == "4") ...[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.offwhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  CustomAssets.youtube,
                                  color: AppColor.primaryColor,
                                  height: 25,
                                ),
                              ),
                            ),
                            Gap.w(20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: LocaleKeys.youtube,
                                    color: AppColor.black,
                                    size: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    txtOverFlow: TextOverflow.visible,
                                    softWrap: true,
                                    title: tournamentData.contactValue!,
                                    color: AppColor.blue,
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  if (tournamentData.contactOption.toString() == "5") ...[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.offwhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  CustomAssets.instagram,
                                  color: AppColor.primaryColor,
                                  height: 25,
                                ),
                              ),
                            ),
                            Gap.w(20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: LocaleKeys.instagram,
                                    color: AppColor.black,
                                    size: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    txtOverFlow: TextOverflow.visible,
                                    softWrap: true,
                                    title: tournamentData.contactValue!,
                                    color: AppColor.blue,
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  if (tournamentData.contactOption.toString() == "6") ...[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.offwhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  CustomAssets.linkedin,
                                  color: AppColor.primaryColor,
                                  height: 25,
                                ),
                              ),
                            ),
                            Gap.w(20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: LocaleKeys.linkedIn,
                                    color: AppColor.black,
                                    size: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    txtOverFlow: TextOverflow.visible,
                                    softWrap: true,
                                    title: tournamentData.contactValue!,
                                    color: AppColor.blue,
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
