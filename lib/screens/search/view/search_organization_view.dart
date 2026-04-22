import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/search/view/search_view.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';

class SearchOrganizationTab extends StatelessWidget {
  final List<OrganizationsModel> data;
  final bool hasSearched;
  const SearchOrganizationTab(
      {super.key, required this.data, required this.hasSearched});

  @override
  Widget build(BuildContext context) {
    if (!hasSearched) {
      return buildMessage(
        context,
        "assets/lotties/searching.json",
        LocaleKeys.emptySearchText.tr(),
      );
    } else if (data.isEmpty) {
      return buildMessage(
        context,
        "assets/lotties/empty_search.json",
        LocaleKeys.thereAreNoSearchResults.tr(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var organization = data[index];
          return InkWell(
            onTap: () async {
              Navigator.pushNamed(context, MyRoutes.organizationDetail,
                  arguments: organization);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade300),
                color: AppColor.screenBG,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  cacheImageView(image: organization.logo!)),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: organization.name ?? 'Unknown Organization',
                              color: AppColor.black,
                              size: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            Gap.h(5),
                            CustomText(
                              title: organization.followersCount == 0 ||
                                      organization.followersCount == 1
                                  ? '${organization.followersCount!} ${LocaleKeys.follower.tr()}'
                                  : '${organization.followersCount!} ${LocaleKeys.followers.tr()}',
                              color: AppColor.black,
                              size: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            Gap.h(10),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
