import 'dart:io';

import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/image_picker_handler.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/create_organization/view_model/create_organization_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class BasicForm extends StatelessWidget {
  const BasicForm({super.key});
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
    return Consumer<CreateOrganizationViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColor.screenBG,
          body: SingleChildScrollView(
            child: Padding(
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
                            title: LocaleKeys.createYourOrganization.tr(),
                            color: AppColor.primaryColor,
                            size: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          Gap.h(5),
                          CustomText(
                            title: LocaleKeys.fillDetailText.tr(),
                            color: AppColor.black.withOpacity(0.6),
                            size: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap.h(20),

                  // Logo section
                  _buildFormLabel(LocaleKeys.logo.tr()),
                  Gap.h(10),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        FilePickerHnadler.showImagePicker(
                          context: context,
                          onGetImage: (val) async {
                            if (val != null) {
                              provider.newImageLogoPath(val.path);
                            }
                          },
                        );
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: provider.imageLogoPath.isNotEmpty
                              ? Colors.transparent
                              : AppColor.offwhite,
                          border: Border.all(
                            width: 1,
                            color: AppColor.primaryColor.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: provider.imageLogoPath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  File(provider.imageLogoPath),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 35,
                                    color: AppColor.primaryColor,
                                  ),
                                  Gap.h(4),
                                  CustomText(
                                    title: LocaleKeys.logo.tr(),
                                    color: AppColor.black,
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  _buildErrorText(provider.logoError),
                  Gap.h(24),

                  // Header image section
                  _buildFormLabel(LocaleKeys.headerImage.tr()),
                  Gap.h(10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () async {
                        FilePickerHnadler.showImagePicker(
                          context: context,
                          onGetImage: (val) async {
                            if (val != null) {
                              provider.newImageHeaderPath(val.path);
                            }
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 1,
                            color: AppColor.primaryColor.withOpacity(0.3),
                          ),
                          color: AppColor.offwhite,
                        ),
                        child: provider.imageHeaderPath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(provider.imageHeaderPath),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.panorama_outlined,
                                    size: 40,
                                    color: AppColor.primaryColor,
                                  ),
                                  Gap.h(4),
                                  CustomText(
                                    title: LocaleKeys.headerImage.tr(),
                                    color: AppColor.black,
                                    size: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  Gap.h(2),
                                  CustomText(
                                    title:
                                        "${LocaleKeys.recommendedSize.tr()}: 1200 x 300",
                                    color: AppColor.grey,
                                    size: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  _buildErrorText(provider.headerError),
                  Gap.h(24),

                  // Organization name section
                  _buildFormLabel(LocaleKeys.organizationName.tr()),
                  Gap.h(10),
                  Container(
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
                    child: PrimaryTextField(
                      isPass: false,
                      onChange: (context) {},
                      hintText: LocaleKeys.organizationName.tr(),
                      textStyle:
                          const TextStyle(color: AppColor.grey, fontSize: 14),
                      errorText: '',
                      width: AppConfig(context).width,
                      controller: provider.organizationName,
                      headingText: '',
                    ),
                  ),
                  _buildErrorText(provider.organizationNameError),
                  Gap.h(24),

                  // Type section
                  _buildFormLabel(LocaleKeys.type.tr()),
                  Gap.h(10),
                  Container(
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
                    child: PopupMenuButton<String>(
                      color: AppColor.screenBG,
                      shadowColor: AppColor.border,
                      offset: const Offset(0, 50),
                      elevation: 3,
                      tooltip: '',
                      splashRadius: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: AppConfig(context).width * .9,
                        minWidth: AppConfig(context).width - 40,
                      ),
                      position: PopupMenuPosition.under,
                      onSelected: (value) {
                        provider.setSelectedType(value);
                      },
                      itemBuilder: (context) {
                        return provider.typeName.keys.map((String type) {
                          return PopupMenuItem<String>(
                            value: type,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 40,
                                width: AppConfig(context).width,
                                child: CustomText(
                                  title: type,
                                  color: AppColor.black,
                                  size: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        height: 55,
                        width: AppConfig(context).width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor.withOpacity(0.3),
                              width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.offwhite,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  txtOverFlow: TextOverflow.visible,
                                  softWrap: true,
                                  alignment: TextAlign.start,
                                  title: provider.selectedTypeId != null
                                      ? provider.typeName.keys.firstWhere(
                                          (type) =>
                                              provider.typeName[type] ==
                                              provider.selectedTypeId,
                                          orElse: () => LocaleKeys
                                              .selectOrganizationType
                                              .tr(),
                                        )
                                      : LocaleKeys.selectOrganizationType.tr(),
                                  color: provider.selectedTypeId != null
                                      ? AppColor.black
                                      : AppColor.grey,
                                  size: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 22,
                                color: AppColor.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildErrorText(provider.typeError),
                  Gap.h(24),

                  // Description section
                  _buildFormLabel(LocaleKeys.description.tr()),
                  Gap.h(10),
                  Container(
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
                      height: 200,
                      width: AppConfig(context).width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.offwhite,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.05),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: QuillSimpleToolbar(
                              controller: provider.quillController,
                              config: const QuillSimpleToolbarConfig(
                                multiRowsDisplay: false,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: QuillEditor.basic(
                                controller: provider.quillController,
                                config: QuillEditorConfig(
                                  showCursor: true,
                                  customStyles: customStyles,
                                  textSelectionThemeData:
                                      TextSelectionThemeData(
                                    cursorColor: AppColor.primaryColor,
                                    selectionHandleColor: AppColor.primaryColor,
                                    selectionColor:
                                        AppColor.primaryColor.withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  _buildErrorText(provider.descriptionError),
                  Gap.h(40),
                  Container(
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
                        if (!provider.validateForm()) {
                          return;
                        }
                        provider.updatePagerIndex(1);
                      },
                      color: AppColor.primaryColor,
                      title: LocaleKeys.next.tr(),
                      width: AppConfig(context).width,
                      height: 55,
                    ),
                  ),
                  Gap.h(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper widgets for cleaner code
  Widget _buildFormLabel(String label) {
    return Row(
      children: [
        CustomText(
          title: label,
          color: AppColor.black,
          size: 15,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildErrorText(String? errorText) {
    return errorText != null
        ? Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          )
        : const SizedBox();
  }
}
