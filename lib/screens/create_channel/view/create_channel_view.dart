import 'dart:io';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/image_picker_handler.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/create_channel/view_model/create_channel_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class CreateChannel extends StatefulWidget {
  final String orgId;
  const CreateChannel({super.key, required this.orgId});

  @override
  State<CreateChannel> createState() => _CreateChannelState();
}

class _CreateChannelState extends State<CreateChannel> {
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createChannel(
    CreateChannelViewModel channelVm,
    BuildContext context,
    DialogHelper dialogHelper,
    String orgId,
  ) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.creatingChannel.tr());
    try {
      final response = await channelVm.createChannel(orgId);
      dialogHelper.dismissProgress();
      if (response.status != 200) {
        debugPrint('response--- ${response.status}');
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
              content: LocaleKeys.channelCreated.tr(),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));

      // Navigator.pop(context);
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(
          MaterialDialogContent.networkError(),
          () => _createChannel(
                channelVm,
                context,
                dialogHelper,
                orgId,
              ));
    }
  }

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

    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(
        title: LocaleKeys.createChannel.tr(),
      ),
      body: SafeArea(
        child: Consumer<CreateChannelViewModel>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Gap.h(10),
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
                              title: "Create Your Channel",
                              color: AppColor.primaryColor,
                              size: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            Gap.h(5),
                            CustomText(
                              title:
                                  "Set up your streaming channel with your details",
                              color: AppColor.black.withOpacity(0.6),
                              size: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap.h(20),
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
                                      title: LocaleKeys.backgroundImage.tr(),
                                      color: AppColor.black,
                                      size: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    Gap.h(2),
                                    CustomText(
                                      title: "Recommended size: 1200 x 300",
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

                    // Channel name section
                    _buildFormLabel(LocaleKeys.channelName.tr()),
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
                        onChange: (context) {
                          provider.clearNameError();
                        },
                        hintText: LocaleKeys.channelName.tr(),
                        textStyle:
                            const TextStyle(color: AppColor.grey, fontSize: 14),
                        errorText: '',
                        width: AppConfig(context).width,
                        controller: provider.channelName,
                        headingText: '',
                      ),
                    ),
                    _buildErrorText(provider.channelNameError),
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
                                      selectionHandleColor:
                                          AppColor.primaryColor,
                                      selectionColor: AppColor.primaryColor
                                          .withOpacity(0.2),
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

                    // Create button
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
                          _createChannel(
                            provider,
                            context,
                            _dialogueHelper,
                            widget.orgId,
                          );
                        },
                        color: AppColor.primaryColor,
                        title: LocaleKeys.create.tr(),
                        width: AppConfig(context).width,
                        height: 55,
                      ),
                    ),
                    Gap.h(20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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
