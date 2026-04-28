import 'package:neoncave_arena/screens/auth/select_organization/view_model/select_organization_view_model.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import '../../components/profile_success_popup.dart';

class SelectOrganization extends StatefulWidget {
  const SelectOrganization({super.key});

  @override
  State<SelectOrganization> createState() => _SelectOrganizationState();
}

class _SelectOrganizationState extends State<SelectOrganization> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final organizationVm =
          Provider.of<SelectOrganizationViewModel>(context, listen: false);
      organizationVm.getOrganization();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Gap.h(30),
              Center(
                child: CustomText(
                  title: LocaleKeys.pickWhatYoudLikeToWatch.tr(),
                  color: AppColor.black,
                  size: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Gap.h(10),
              Center(
                child: CustomText(
                  softWrap: true,
                  alignment: TextAlign.center,
                  title: LocaleKeys.pickSomeGames.tr(),
                  color: AppColor.black,
                  size: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap.h(30),
              Expanded(
                child: Consumer<SelectOrganizationViewModel>(
                    builder: (context, organizationVm, child) {
                  if (organizationVm.organizationData.isEmpty &&
                      !organizationVm.isLoading) {
                    // Show message if the list is empty and not loading
                    return Center(
                      child: Text(
                        LocaleKeys.noOrganizationAvailable.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.black,
                        ),
                      ),
                    );
                  } else if (organizationVm.isLoading) {
                    // Show loader while data is being fetched
                    return Center(
                        child: CupertinoActivityIndicator(
                      color: AppColor.primaryColor,
                      radius: 20,
                    ));
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: organizationVm.organizationData.length,
                      itemBuilder: (context, index) {
                        final data = organizationVm.organizationData[index];
                        return GestureDetector(
                          onTap: () async {},
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.screenBG,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: cacheImageView(
                                              image: data.logo.toString()),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            title: "${data.name}",
                                            color: AppColor.black,
                                            size: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          Gap.h(5),
                                          Row(
                                            children: [
                                              CustomText(
                                                title: data.followersCount ==
                                                            0 ||
                                                        data.followersCount == 1
                                                    ? "${data.followersCount} ${LocaleKeys.follower.tr()}"
                                                    : "${data.followersCount} ${LocaleKeys.followers.tr()}",
                                                color: AppColor.black,
                                                size: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      data.isFollowing == 0
                                          ? GestureDetector(
                                              onTap: () {
                                                organizationVm
                                                    .followOrganization(
                                                        data.id!, context);
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColor.primaryColor,
                                                ),
                                                child: Center(
                                                  child: CustomText(
                                                    title:
                                                        LocaleKeys.follow.tr(),
                                                    color: Colors.white,
                                                    size: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                organizationVm
                                                    .followOrganization(
                                                        data.id!, context);
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColor
                                                          .primaryColor),
                                                  color: AppColor.screenBG,
                                                ),
                                                child: Center(
                                                  child: CustomText(
                                                    title: LocaleKeys.unfollow
                                                        .tr(),
                                                    color: AppColor.black,
                                                    size: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: PrimaryBTN(
                callback: () async {
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      MyRoutes.mainScreen,
                      arguments: true,
                      (route) => false);
                },
                color: const Color(0xff7E0FC6).withOpacity(0.15),
                title: LocaleKeys.skip.tr(),
                textCLR: AppColor.black,
                width: AppConfig(context).width - 0,
              ),
            ),
            Gap.w(10),
            Expanded(
              child: PrimaryBTN(
                callback: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Future.delayed(const Duration(seconds: 4), () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            MyRoutes.mainScreen,
                            arguments: true,
                            (route) => false);
                      });
                      return const ProfileSuccessPopup();
                    },
                  );
                },
                color: AppColor.primaryColor,
                title: LocaleKeys.continueText.tr(),
                width: AppConfig(context).width - 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
