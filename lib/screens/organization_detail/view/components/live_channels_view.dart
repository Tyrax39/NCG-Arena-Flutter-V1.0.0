import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/screens/organization_detail/view_model/organization_detail_view_model.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class ChannelsTab extends StatelessWidget {
  const ChannelsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final organizationVm =
        Provider.of<OrganizationViewModel>(context, listen: true);
    return Column(children: [
      if (organizationVm.isLoading == true) ...[
        SizedBox(
          height: AppConfig(context).height * .2,
        ),
        CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ] else ...[
        organizationVm.channelData.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: organizationVm.channelData.length,
                itemBuilder: (context, index) {
                  var channelData = organizationVm.channelData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: AppColor.offwhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MyRoutes.channelDetailScreen,
                                arguments: channelData);
                          },
                          child: SizedBox(
                            height: 160,
                            width: AppConfig(context).width,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: channelData.header!,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Image.asset(CustomAssets.placeholder),
                                placeholder: (context, url) => Center(
                                  child: CupertinoActivityIndicator(
                                    color: AppColor.primaryColor,
                                    radius: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: channelData.logo!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(CustomAssets.placeholder),
                                    placeholder: (context, url) => Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColor.primaryColor,
                                        radius: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gap.w(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: channelData.name.toString(),
                                    color: AppColor.black,
                                    size: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  Gap.h(3),
                                  Row(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColor.red,
                                        ),
                                      ),
                                      Gap.w(4),
                                      CustomText(
                                        title: channelData.followerCount == 1 ||
                                                channelData.followerCount == 0
                                            ? "${channelData.followerCount.toString()} ${LocaleKeys.subscriber.tr()}"
                                            : "${channelData.followerCount.toString()} ${LocaleKeys.subscribers.tr()}",
                                        color: AppColor.black,
                                        size: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : SizedBox(
                height: AppConfig(context).height * .5,
                child: Center(
                  child: CustomText(
                    title: LocaleKeys.organizationChannelsNotFound.tr(),
                    color: AppColor.black,
                  ),
                ),
              ),
      ],
    ]);
  }
}
