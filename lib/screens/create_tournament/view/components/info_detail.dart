import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

// Common widget for form sections
class FormSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool hasError;
  final String? errorText;

  const FormSection({
    required this.title,
    this.subtitle,
    required this.child,
    this.hasError = false,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          size: 16,
          fontWeight: FontWeight.w600,
          color: AppColor.black,
        ),
        if (subtitle != null) ...[
          Gap.h(4),
          CustomText(
            title: subtitle!,
            size: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.black.withOpacity(0.6),
          ),
        ],
        Gap.h(12),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? AppColor.red.withOpacity(0.5)
                    : AppColor.grey.withOpacity(0.2),
                width: hasError ? 2 : 1,
              ),
              color: AppColor.screenBG),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
        ),
        if (hasError && errorText != null) ...[
          Gap.h(8),
          CustomText(
            title: errorText!,
            size: 12,
            fontWeight: FontWeight.w400,
            color: AppColor.red,
          ),
        ],
      ],
    );
  }
}

class InfoDetail extends StatelessWidget {
  const InfoDetail({super.key});

  @override
  Widget build(BuildContext context) {
    DefaultStyles customStyles = DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        TextStyle(
          color: AppColor.black,
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
        const HorizontalSpacing(6, 0),
        const VerticalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        null,
      ),
    );

    return Consumer<TournamentCreateViewmodel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.h(24),

              // Contact Section
              FormSection(
                title: LocaleKeys.howWillPeopleContactYou.tr(),
                subtitle: LocaleKeys.chooseHowParticipants.tr(),
                hasError: viewModel.contactError != null,
                errorText: viewModel.contactError,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Social Media Type Selector
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.offwhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PopupMenuButton<String>(
                        offset: const Offset(0, 50),
                        color: AppColor.screenBG,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) {
                          return viewModel.socialLinkName.keys
                              .map((String type) {
                            return PopupMenuItem<String>(
                              value: type,
                              child:
                                  _buildSocialOption(type, viewModel, context),
                            );
                          }).toList();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.contact_page_rounded,
                                size: 20,
                                color: AppColor.primaryColor,
                              ),
                              Gap.w(12),
                              Expanded(
                                child: Text(
                                  viewModel.selectedSocialLinkId != null
                                      ? viewModel.socialLinkName.keys
                                          .firstWhere(
                                          (type) =>
                                              viewModel.socialLinkName[type] ==
                                              viewModel.selectedSocialLinkId,
                                          orElse: () =>
                                              LocaleKeys.selectContact.tr(),
                                        )
                                      : LocaleKeys.selectContact.tr(),
                                  style: TextStyle(
                                    color:
                                        viewModel.selectedSocialLinkId != null
                                            ? AppColor.black
                                            : AppColor.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: AppColor.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Social Media Input Field
                    if (viewModel.selectedSocialLinkId != null) ...[
                      Gap.h(12),
                      _buildSocialInputField(viewModel),
                      if (viewModel.contactValueError != null) ...[
                        Gap.h(8),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: CustomText(
                            title: viewModel.contactValueError!,
                            size: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColor.red,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              Gap.h(32),

              // Rules Section
              FormSection(
                title: LocaleKeys.rules.tr(),
                subtitle: LocaleKeys.tournamentRules.tr(),
                hasError: viewModel.rulesError != null,
                errorText: viewModel.rulesError,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.screenBG,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: QuillSimpleToolbar(
                          controller: viewModel.rulesController,
                          config: const QuillSimpleToolbarConfig(
                            multiRowsDisplay: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: QuillEditor.basic(
                          controller: viewModel.rulesController,
                          config: QuillEditorConfig(
                            showCursor: true,
                            customStyles: customStyles,
                            padding: const EdgeInsets.all(16),
                            textSelectionThemeData: TextSelectionThemeData(
                              cursorColor: AppColor.primaryColor,
                              selectionHandleColor: AppColor.primaryColor,
                              selectionColor:
                                  AppColor.primaryColor.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap.h(32),
              // Schedule Section
              FormSection(
                title: LocaleKeys.schedule.tr(),
                subtitle: LocaleKeys.planTournamentTimeline.tr(),
                hasError: viewModel.scheduleError != null,
                errorText: viewModel.scheduleError,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.screenBG,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: QuillSimpleToolbar(
                          controller: viewModel.scheduleController,
                          config: const QuillSimpleToolbarConfig(
                            multiRowsDisplay: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: QuillEditor.basic(
                          controller: viewModel.scheduleController,
                          config: QuillEditorConfig(
                            showCursor: true,
                            customStyles: customStyles,
                            padding: const EdgeInsets.all(16),
                            textSelectionThemeData: TextSelectionThemeData(
                              cursorColor: AppColor.primaryColor,
                              selectionHandleColor: AppColor.primaryColor,
                              selectionColor:
                                  AppColor.primaryColor.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap.h(32),
              PrimaryBTN(
                  height: 56,
                  callback: () {
                    if (!viewModel.infoDetailValidator()) {
                      return;
                    }
                    viewModel.updatePagerIndex(5);
                  },
                  borderRadius: 10,
                  color: AppColor.primaryColor,
                  title: LocaleKeys.next.tr(),
                  width: AppConfig(context).width),
              // Next Button

              Gap.h(24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialOption(
      String type, TournamentCreateViewmodel viewModel, BuildContext context) {
    final Map<String, IconData> socialIcons = {
      'Discord': Icons.discord,
      'Facebook': Icons.facebook,
      'Youtube': Icons.youtube_searched_for,
      'Twitch': Icons.tv,
      'Instagram': Icons.camera_alt,
      'LinkedIn': Icons.work,
    };

    return InkWell(
      onTap: () {
        viewModel.setSelectedSocialLink(type);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(
              socialIcons[type] ?? Icons.link,
              size: 20,
              color: AppColor.primaryColor,
            ),
            Gap.w(12),
            CustomText(
              title: type,
              size: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialInputField(TournamentCreateViewmodel viewModel) {
    final Map<int, String> hintTexts = {
      1: LocaleKeys.addDiscordInviteLink.tr(),
      2: LocaleKeys.addFacebookUsername.tr(),
      3: LocaleKeys.addYoutubeUsername.tr(),
      4: LocaleKeys.addTwitchUsername.tr(),
      5: LocaleKeys.addInstagramUsername.tr(),
      6: LocaleKeys.addLinkedInUsername.tr(),
    };

    return TextFormField(
      style: TextStyle(
        color: AppColor.black,
        fontSize: 14,
      ),
      controller: viewModel.linkController,
      onChanged: (value) {
        viewModel.handleContactValueChange(value);
      },
      decoration: InputDecoration(
        hintText: hintTexts[viewModel.selectedSocialLinkId] ?? '',
        hintStyle: const TextStyle(
          color: AppColor.grey,
          fontSize: 14,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/${_getSocialIcon(viewModel.selectedSocialLinkId)}',
            width: 24,
            height: 24,
            color: AppColor.primaryColor,
          ),
        ),
      ),
    );
  }

  String _getSocialIcon(int? socialId) {
    switch (socialId) {
      case 1:
        return 'discord.png';
      case 2:
        return 'facebook.png';
      case 3:
        return 'youtube.png';
      case 4:
        return 'twitch.png';
      case 5:
        return 'instagram.png';
      case 6:
        return 'linkedin.png';
      default:
        return 'link.png';
    }
  }
}
