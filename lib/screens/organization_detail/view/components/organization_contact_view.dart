import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';

class OrganizationContact extends StatelessWidget {
  final OrganizationsModel organization;
  const OrganizationContact({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap.h(organization.twitchUsername != null &&
                organization.twitchUsername != ''
            ? 10
            : 0),
        organization.twitchUsername != null && organization.twitchUsername != ''
            ? Container(
                decoration: BoxDecoration(
                    color: AppColor.offwhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            CustomAssets.twitch,
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
                              title: LocaleKeys.twitch,
                              color: AppColor.black,
                              size: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              txtOverFlow: TextOverflow.visible,
                              softWrap: true,
                              title: organization.twitchUsername.toString(),
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
            : const SizedBox(),
        Gap.h(organization.discordInviteLink != null &&
                organization.discordInviteLink != ''
            ? 10
            : 0),
        organization.discordInviteLink != null &&
                organization.discordInviteLink != ''
            ? Container(
                decoration: BoxDecoration(
                    color: AppColor.offwhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              title: organization.discordInviteLink.toString(),
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
            : const SizedBox(),
        Gap.h(organization.website != null && organization.website != ''
            ? 10
            : 0),
        organization.website != null && organization.website != ''
            ? Container(
                decoration: BoxDecoration(
                    color: AppColor.offwhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            CustomAssets.web,
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
                              title: LocaleKeys.website,
                              color: AppColor.black,
                              size: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              txtOverFlow: TextOverflow.visible,
                              softWrap: true,
                              title: organization.website.toString(),
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
            : const SizedBox(),
        Gap.h(organization.facebook != null && organization.facebook != ''
            ? 10
            : 0),
        organization.facebook != null && organization.facebook != ''
            ? Container(
                decoration: BoxDecoration(
                    color: AppColor.offwhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              title: organization.facebook.toString(),
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
            : const SizedBox(),
        Gap.h(organization.instagram != null && organization.instagram != ''
            ? 10
            : 0),
        organization.instagram != null && organization.instagram != ''
            ? Container(
                decoration: BoxDecoration(
                    color: AppColor.offwhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              title: organization.instagram.toString(),
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
            : const SizedBox(),
        Gap.h(organization.youtube != null && organization.youtube != ''
            ? 10
            : 0),
        organization.youtube != null && organization.youtube != ''
            ? Container(
                decoration: BoxDecoration(
                    color: AppColor.offwhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              title: organization.youtube.toString(),
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
            : const SizedBox()
      ],
    );
  }
}
