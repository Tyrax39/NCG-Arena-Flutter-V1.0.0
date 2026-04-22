import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/my_organizations/view_model/my_organization_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

import '../../discover/all_organizations/view/all_organizations_view.dart';

class MyOrganizationView extends StatefulWidget {
  const MyOrganizationView({super.key});

  @override
  State<MyOrganizationView> createState() => _MyOrganizationViewState();
}

class _MyOrganizationViewState extends State<MyOrganizationView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final organizationVm =
          Provider.of<MyOrganizationViewModel>(context, listen: false);
      organizationVm.getMyOrganization(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.myOrganizations.tr()),
      body: SafeArea(
        child: Consumer<MyOrganizationViewModel>(
            builder: (context, organizationVm, child) {
          if (organizationVm.organizationData.isEmpty &&
              !organizationVm.isLoading) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_off_outlined,
                    size: 60,
                    color: AppColor.black,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    LocaleKeys.noOrganizationAvailable.tr(),
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "inter",
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    textAlign: TextAlign.center,
                    LocaleKeys.youHaveNotCreateAnyOrganizationTxt.tr(),
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: "inter",
                    ),
                  ),
                ],
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
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Gap.h(10),
                          Consumer<MyOrganizationViewModel>(
                              builder: (context, viewModel, child) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: viewModel.organizationData.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final organization =
                                    viewModel.organizationData[index];
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: InkWell(
                                        onTap: () async {
                                          Navigator.pushNamed(context,
                                              MyRoutes.organizationDetail,
                                              arguments: organization);
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          decoration: BoxDecoration(
                                            color: AppColor.offwhite,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Stack(children: [
                                              Positioned(
                                                right: -20,
                                                top: -20,
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.black
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: -10,
                                                bottom: -30,
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.black
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  organization
                                                                      .logo!,
                                                              fit: BoxFit.cover,
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                      CustomAssets
                                                                          .placeholder),
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Center(
                                                                child:
                                                                    CupertinoActivityIndicator(
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                  radius: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CustomText(
                                                                title:
                                                                    organization
                                                                        .name ?? 'Unknown Organization',
                                                                color: AppColor
                                                                    .black,
                                                                size: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              Gap.h(5),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .people,
                                                                    size: 16,
                                                                    color: AppColor
                                                                        .primaryColor,
                                                                  ),
                                                                  Gap.w(4),
                                                                  CustomText(
                                                                    title: organization.followersCount ==
                                                                                1 ||
                                                                            organization.followersCount ==
                                                                                0
                                                                        ? "${organization.followersCount.toString()} ${LocaleKeys.follower.tr()}"
                                                                        : "${organization.followersCount.toString()} ${LocaleKeys.followers.tr()}",
                                                                    color: AppColor
                                                                        .black,
                                                                    size: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ],
                                                              ),
                                                              Gap.h(5),
                                                              HtmlWidget(
                                                                '''<p style="text-align: justify;">${getLimitedText(organization.description!)}</p>''',
                                                                renderMode:
                                                                    RenderMode
                                                                        .column,
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: AppColor
                                                                        .black),
                                                              ),
                                                              Gap.h(10),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                          ),
                                        )));
                              },
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
