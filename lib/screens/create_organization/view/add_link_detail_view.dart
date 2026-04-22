import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/constant/custom_asset.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/create_organization/view_model/create_organization_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSocialLinksDetail extends StatefulWidget {
  const AddSocialLinksDetail({super.key});

  @override
  State<AddSocialLinksDetail> createState() => _AddSocialLinksDetailState();
}

class _AddSocialLinksDetailState extends State<AddSocialLinksDetail> {
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createOrganization(CreateOrganizationViewModel organizationVm,
      BuildContext context, DialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.creatingOrganization.tr());
    try {
      final response = await organizationVm.createOrganization();
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        print('response--- ${response.status}');
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage:
                SnackbarMessage.smallMessageError(content: response.message),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
          );
        return;
      }
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
            snackbarMessage: SnackbarMessage.smallMessage(
              content: LocaleKeys.organizationCreated.tr(),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.mainScreen, arguments: true, (route) => false);
      });
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _createOrganization(organizationVm, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: SingleChildScrollView(
        child: Consumer<CreateOrganizationViewModel>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          CustomText(
                            title: LocaleKeys.contactInfo.tr(),
                            color: AppColor.primaryColor,
                            size: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          Gap.h(5),
                          CustomText(
                            title: LocaleKeys
                                .connectWithYourAudienceOnVariousPlatforms
                                .tr(),
                            color: AppColor.black.withOpacity(0.6),
                            size: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap.h(20),
                  _buildSocialLinkField(
                    context: context,
                    icon: CustomAssets.facebook,
                    controller: provider.facebookController,
                    hintText: LocaleKeys.addFacebookUsername.tr(),
                  ),
                  Gap.h(16),
                  _buildSocialLinkField(
                    context: context,
                    icon: CustomAssets.instagram,
                    controller: provider.instagramController,
                    hintText: LocaleKeys.addInstagramUsername.tr(),
                  ),
                  Gap.h(16),

                  _buildSocialLinkField(
                    context: context,
                    icon: CustomAssets.web,
                    controller: provider.websiteController,
                    hintText: LocaleKeys.addWebsitelink.tr(),
                  ),
                  Gap.h(16),

                  _buildSocialLinkField(
                    context: context,
                    icon: CustomAssets.youtube,
                    controller: provider.youtubeController,
                    hintText: LocaleKeys.addYoutubeUsername.tr(),
                  ),
                  Gap.h(16),

                  _buildSocialLinkField(
                    context: context,
                    icon: CustomAssets.twitch,
                    controller: provider.twitchController,
                    hintText: LocaleKeys.addTwitchUsername.tr(),
                  ),
                  Gap.h(16),

                  _buildSocialLinkField(
                    context: context,
                    icon: CustomAssets.discord,
                    controller: provider.discordController,
                    hintText: LocaleKeys.addDiscordInviteLink.tr(),
                  ),
                  Gap.h(40),

                  // Button Row
                  Row(
                    children: [
                      // Back button
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColor.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColor.primaryColor,
                          ),
                          onPressed: () {
                            provider.updatePagerIndex(0);
                          },
                        ),
                      ),
                      Gap.w(12),

                      // Create button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: PrimaryBTN(
                            callback: () {
                              // Check if at least one contact info field is filled
                              if (provider.facebookController.text.isEmpty &&
                                  provider.instagramController.text.isEmpty &&
                                  provider.websiteController.text.isEmpty &&
                                  provider.youtubeController.text.isEmpty &&
                                  provider.twitchController.text.isEmpty &&
                                  provider.discordController.text.isEmpty) {
                                // Show error message if none are filled
                                _snackbarHelper
                                  ..injectContext(context)
                                  ..showSnackbar(
                                    snackbarMessage:
                                        SnackbarMessage.smallMessageError(
                                            content: LocaleKeys
                                                .atLeastOneContactInfoIsRequired
                                                .tr()),
                                    margin: const EdgeInsets.only(
                                      left: 25,
                                      right: 25,
                                      bottom: 100,
                                    ),
                                  );
                                return;
                              }
                              _createOrganization(
                                  provider, context, _dialogueHelper);
                            },
                            color: AppColor.primaryColor,
                            title: LocaleKeys.create.tr(),
                            width: double.infinity,
                            height: 55,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap.h(20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialLinkField({
    required BuildContext context,
    required String icon,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: AppColor.primaryColor.withOpacity(0.3),
          ),
          color: AppColor.offwhite,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                icon,
                height: 22,
                color: AppColor.primaryColor,
              ),
              Gap.w(12),
              Container(
                height: 24,
                width: 1,
                color: AppColor.grey.withOpacity(0.5),
              ),
              Gap.w(12),
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: AppColor.black, fontSize: 14),
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColor.grey,
                    ),
                    border: InputBorder.none,
                    fillColor: AppColor.offwhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
