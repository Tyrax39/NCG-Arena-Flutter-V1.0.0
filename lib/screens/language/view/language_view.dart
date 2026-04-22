// import 'package:easy_localization/easy_localization.dart';

import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/screens/language/view_model/language_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/screens/language/model/language_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.language.tr()),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: SingleChildScrollView(
                  child: Consumer<LanguageViewModel>(
                    builder: (context, languageViewModel, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: languageList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              bool isSelected = index ==
                                  languageViewModel.selectedLanguageIndex;
                              return GestureDetector(
                                onTap: () async {
                                  Navigator.pop(context);

                                  Locale selectedLocale =
                                      Locale(languageList[index].code);
                                  await context.setLocale(selectedLocale);
                                  languageViewModel
                                      .saveLanguage(selectedLocale);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColor.screenBG,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              title:
                                                  languageList[index].name.tr(),
                                              color: AppColor.black,
                                              size: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: AppColor.primaryColor,
                                                ),
                                              ),
                                              child: isSelected
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: AppColor
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
