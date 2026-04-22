import 'package:neoncave_arena/screens/create_tournament/view_model/create_tournament_view_model.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/discover/all_organizations/view/all_organizations_view.dart';
import 'package:neoncave_arena/utils/cached_netwrok_image.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

class SelectOrganization extends StatefulWidget {
  const SelectOrganization({super.key});

  @override
  State<SelectOrganization> createState() => _SelectOrganizationState();
}

class _SelectOrganizationState extends State<SelectOrganization> {
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  @override
  void initState() {
    Provider.of<TournamentCreateViewmodel>(context, listen: false)
        .getMyOrganization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<TournamentCreateViewmodel>(
        builder: (context, organizationVm, child) {
          return Column(
            children: [
              // Header Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.primaryColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.business_rounded,
                        size: 40,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Gap.h(16),
                    CustomText(
                      title: LocaleKeys.selectOrganization.tr(),
                      size: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                    Gap.h(8),
                    CustomText(
                      softWrap: true,
                      alignment: TextAlign.center,
                      title: LocaleKeys.chooseTheOrganizationText.tr(),
                      size: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black.withOpacity(0.6),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: _buildMainContent(organizationVm, context),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (organizationVm.organizationData.isNotEmpty) ...[
                      CustomText(
                        title:
                            '${organizationVm.organizationData.length} ${LocaleKeys.availableOrganizations.tr()}',
                        size: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black.withOpacity(0.6),
                      ),
                      Gap.h(16),
                    ],
                    PrimaryBTN(
                        height: 56,
                        callback: () {
                          _handleNext(context, organizationVm);
                        },
                        borderRadius: 10,
                        color: AppColor.primaryColor,
                        title: LocaleKeys.next.tr(),
                        width: AppConfig(context).width),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
      TournamentCreateViewmodel organizationVm, BuildContext context) {
    if (organizationVm.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              color: AppColor.primaryColor,
              radius: 20,
            ),
            Gap.h(16),
            CustomText(
              title: LocaleKeys.loadingOrganizations.tr(),
              size: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.black,
            ),
          ],
        ),
      );
    }

    if (organizationVm.organizationData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business_rounded,
                size: 64,
                color: AppColor.black.withOpacity(0.3),
              ),
              Gap.h(16),
              CustomText(
                alignment: TextAlign.center,
                title: LocaleKeys.youHaveNotCreated.tr(),
                size: 18,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              Gap.h(24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.createOrganization);
                  },
                  icon: Icon(
                    Icons.add_business_rounded,
                    color: AppColor.white,
                  ),
                  label: Text(
                    LocaleKeys.createOrganization.tr(),
                    style: TextStyle(color: AppColor.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: organizationVm.organizationData.length,
      itemBuilder: (context, index) {
        final organization = organizationVm.organizationData[index];
        final isSelected = organizationVm.selectedIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColor.offwhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryColor
                  : AppColor.grey.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? []
                : [
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => organizationVm.selectIndex(index, organization.id!),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Organization Logo
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            cacheImageView(image: organization.logo.toString()),
                      ),
                    ),
                    Gap.w(16),

                    // Organization Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: organization.name.toString(),
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                          if (organization.description != null) ...[
                            Gap.h(4),
                            HtmlWidget(
                              '''<p style="text-align: justify;">${_getLimitedText(organization.description!)}</p>''',
                              renderMode: RenderMode.column,
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.black.withOpacity(0.6)),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Selection Indicator
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColor.primaryColor
                              : Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                        color: isSelected
                            ? AppColor.primaryColor
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleNext(BuildContext context, TournamentCreateViewmodel provider) {
    if (provider.selectedIndex == -1) {
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
          snackbarMessage: SnackbarMessage.smallMessageError(
            content: LocaleKeys.pleaseSelectOrganization.tr(),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        );
      return;
    }
    provider.updatePagerIndex(2);
  }

  String _getLimitedText(String description) {
    int maxLength = 30; // Approximate length for 3 lines
    if (description.length > maxLength) {
      return '${description.substring(0, maxLength)}...'; // Truncate with ellipsis
    }
    return description;
  }
}
