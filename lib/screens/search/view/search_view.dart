import 'package:neoncave_arena/screens/search/view/search_organization_view.dart';
import 'package:neoncave_arena/screens/search/view/search_users_tab_view.dart';
import 'package:neoncave_arena/screens/search/view/search_tournament_tab_view.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/screens/search/view_model/search_view_model.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColor.black,
                        ),
                      ),
                      Gap.w(10),
                      Expanded(
                        child: Consumer<SearchViewModel>(
                            builder: (context, value, child) {
                          return PrimaryTextField(
                            isPass: false,
                            readOnly: false,
                            controller: value.searchController,
                            onChange: (text) {
                              if (text.length > 3) {
                                context
                                    .read<SearchViewModel>()
                                    .setSearchQuery(text);
                              }
                            },
                            onSubmitted: (text) {
                              context
                                  .read<SearchViewModel>()
                                  .searchAPI(context);
                            },
                            hintText:
                                LocaleKeys.searchForUserOrganizationText.tr(),
                            textStyle: const TextStyle(
                                fontSize: 12, color: AppColor.grey),
                            errorText: '',
                            prefixIcon: 'assets/images/Search.png',
                            width: AppConfig(context).width,
                            headingText: '',
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Gap.h(20),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Consumer<SearchViewModel>(
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              value.setSelectedTabIndex(0);
                            },
                            child: SizedBox(
                              width: AppConfig(context).width * .3,
                              child: Column(
                                children: [
                                  CustomText(
                                    title: LocaleKeys.organizations.tr(),
                                    size: 14,
                                    color: value.selectedTabIndex == 0
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Gap.h(5),
                                  Container(
                                    height: 2,
                                    width: 90,
                                    color: value.selectedTabIndex == 0
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              value.setSelectedTabIndex(1);
                            },
                            child: SizedBox(
                              width: AppConfig(context).width * .4,
                              child: Column(
                                children: [
                                  CustomText(
                                    title: LocaleKeys.tournament.tr(),
                                    size: 14,
                                    color: value.selectedTabIndex == 1
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Gap.h(5),
                                  Container(
                                    height: 2,
                                    width: 80,
                                    color: value.selectedTabIndex == 1
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              value.setSelectedTabIndex(2);
                            },
                            child: SizedBox(
                              width: AppConfig(context).width * .25,
                              child: Column(
                                children: [
                                  CustomText(
                                    title: LocaleKeys.users.tr(),
                                    size: 13,
                                    color: value.selectedTabIndex == 2
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Gap.h(5),
                                  Container(
                                    height: 2,
                                    width: 40,
                                    color: value.selectedTabIndex == 2
                                        ? AppColor.primaryColor
                                        : AppColor.grey,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Gap.h(10),
                Consumer<SearchViewModel>(
                  builder: (context, value, child) {
                    return value.selectedTabIndex == 0
                        ? SearchOrganizationTab(
                            data: value.organizations,
                            hasSearched: value.hasSearched,
                          )
                        : value.selectedTabIndex == 1
                            ? SearchTournamentTab(
                                data: value.tournaments,
                                hasSearched: value.hasSearched,
                              )
                            : SearchUsersTab(
                                data: value.users,
                                hasSearched: value.hasSearched,
                              );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildMessage(
    BuildContext context, String animationPath, String message) {
  return Column(
    children: [
      SizedBox(
        height: AppConfig(context).height * .2,
      ),
      Center(
        child: SizedBox(
          width: 230,
          child: Lottie.asset(animationPath),
        ),
      ),
      Gap.h(20),
      CustomText(
        alignment: TextAlign.center,
        title: message,
        color: AppColor.black,
        size: 15,
        fontWeight: FontWeight.w600,
      ),
    ],
  );
}
