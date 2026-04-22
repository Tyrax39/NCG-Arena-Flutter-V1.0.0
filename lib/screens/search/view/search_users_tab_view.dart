import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/screens/search/view/search_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';

class SearchUsersTab extends StatelessWidget {
  final List<UserDataModel> data;
  final bool hasSearched;
  const SearchUsersTab(
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
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  MyRoutes.userProfileScreen,
                  arguments: [data[index].id],
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.offwhite,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black12,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: data[index].profileImage ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            placeholder: (context, url) => Center(
                              child: CupertinoActivityIndicator(
                                color: AppColor.primaryColor,
                                radius: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: data[index].username ?? '',
                            color: AppColor.black,
                            size: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          Gap.h(5),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
