import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/followed_organizations/view_model/followed_organization_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

import '../../discover/all_organizations/view/all_organizations_view.dart';

class FollowedOrganization extends StatefulWidget {
  const FollowedOrganization({super.key});

  @override
  State<FollowedOrganization> createState() => _FollowedOrganizationState();
}

class _FollowedOrganizationState extends State<FollowedOrganization> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final organizationVm =
          Provider.of<FollowedOrganizationViewModel>(context, listen: false);
      organizationVm.getFollowedOrganization();
      organizationVm.getPopularOrganization();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final organizationVm =
        Provider.of<FollowedOrganizationViewModel>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!organizationVm.isLoadingMore && organizationVm.hasMoreData) {
        if (organizationVm.organizationData.isNotEmpty) {
          organizationVm.getFollowedOrganization(loadMore: true);
        } else {
          organizationVm.getPopularOrganization(loadMore: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowedOrganizationViewModel>(
        builder: (context, organizationVm, child) {
      if (organizationVm.organizationData.isEmpty &&
          organizationVm.popularOrganizationData.isEmpty &&
          !organizationVm.isLoading) {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(
            title: organizationVm.organizationData.isNotEmpty
                ? LocaleKeys.followedOrganizations.tr()
                : LocaleKeys.popularOrganizations.tr(),
          ),
          body: Center(
            child: Text(
              LocaleKeys.noOrganizationAvailable.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.black,
              ),
            ),
          ),
        );
      } else if (organizationVm.isLoading) {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          body: Center(
            child: CupertinoActivityIndicator(
              color: AppColor.primaryColor,
              radius: 20,
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          appBar: CommonAppBar(
            title: organizationVm.organizationData.isNotEmpty
                ? LocaleKeys.followedOrganizations.tr()
                : LocaleKeys.popularOrganizations.tr(),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: (organizationVm.organizationData.isNotEmpty
                              ? organizationVm.organizationData.length
                              : organizationVm.popularOrganizationData.length) +
                          (organizationVm.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >=
                            (organizationVm.organizationData.isNotEmpty
                                ? organizationVm.organizationData.length
                                : organizationVm
                                    .popularOrganizationData.length)) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Column(
                                children: [
                                  CupertinoActivityIndicator(
                                    color: AppColor.primaryColor,
                                    radius: 12,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final organization =
                            organizationVm.organizationData.isNotEmpty
                                ? organizationVm.organizationData[index]
                                : organizationVm.popularOrganizationData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () async {
                              Navigator.pushNamed(
                                  context, MyRoutes.organizationDetail,
                                  arguments: organization);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppColor.offwhite,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(children: [
                                      Positioned(
                                        right: -20,
                                        top: -20,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color:
                                                AppColor.black.withOpacity(0.1),
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
                                            color:
                                                AppColor.black.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          organization.logo ?? '',
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              CustomAssets
                                                                  .placeholder),
                                                      placeholder:
                                                          (context, url) =>
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
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        title:
                                                            organization.name ?? 'Unknown Organization',
                                                        color: AppColor.black,
                                                        size: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      Gap.h(5),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 5,
                                                            width: 5,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: AppColor
                                                                    .red),
                                                          ),
                                                          Gap.w(4),
                                                          CustomText(
                                                            title: organization
                                                                            .followersCount ==
                                                                        1 ||
                                                                    organization
                                                                            .followersCount ==
                                                                        0
                                                                ? "${organization.followersCount.toString()} ${LocaleKeys.follower.tr()}"
                                                                : "${organization.followersCount.toString()} ${LocaleKeys.followers.tr()}",
                                                            color:
                                                                AppColor.black,
                                                            size: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ],
                                                      ),
                                                      Gap.h(5),
                                                      HtmlWidget(
                                                        '''<p style="text-align: justify;">${getLimitedText(organization.description!)}</p>''',
                                                        renderMode:
                                                            RenderMode.column,
                                                        textStyle: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                AppColor.black),
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
                                    ]))),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
