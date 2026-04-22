import 'dart:io';

import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/image_picker_handler.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/create_live_stream_form/view_model/create_live_stream_form_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateLiveStreamForm extends StatelessWidget {
  final String channelId;
  final String channelName;

  const CreateLiveStreamForm({
    super.key,
    required this.channelId,
    required this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    final createLiveVm =
        Provider.of<CreateLiveStreamFormViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.createLiveStrem.tr()),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.live_tv_rounded,
                            size: 48,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          LocaleKeys.startLiveStreaming.tr(),
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleKeys.createEngagingLiveStream.tr(),
                          style: TextStyle(
                            color: AppColor.black.withOpacity(0.6),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stream Title Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.liveStreamTitle.tr(),
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleKeys.chooseAttractiveTitle.tr(),
                        style: TextStyle(
                          color: AppColor.black.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<CreateLiveStreamFormViewModel>(
                        builder: (context, streamVm, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColor.screenBG,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: streamVm.nameError != null
                                    ? AppColor.red.withOpacity(0.5)
                                    : AppColor.grey.withOpacity(0.2),
                                width: streamVm.nameError != null ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: streamVm.nameController,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.black,
                              ),
                              decoration: InputDecoration(
                                hintText: LocaleKeys.enterStreamTitle.tr(),
                                hintStyle: TextStyle(
                                  color: AppColor.grey.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                prefixIcon: Icon(
                                  Icons.title_rounded,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (createLiveVm.nameError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            createLiveVm.nameError!,
                            style: const TextStyle(
                              color: AppColor.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Thumbnail Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.liveStreamThumbnail.tr(),
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleKeys.addThumbnail.tr(),
                        style: TextStyle(
                          color: AppColor.black.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<CreateLiveStreamFormViewModel>(
                        builder: (context, streamVm, child) {
                          return InkWell(
                            onTap: () async {
                              FilePickerHnadler.showImagePicker(
                                context: context,
                                onGetImage: (val) async {
                                  if (val != null) {
                                    streamVm.setImagePath(val.path);
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: AppColor.screenBG,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: streamVm.logoError != null
                                      ? AppColor.red.withOpacity(0.5)
                                      : AppColor.grey.withOpacity(0.2),
                                  width: streamVm.logoError != null ? 2 : 1,
                                ),
                              ),
                              child: streamVm.imagePath.isNotEmpty
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                            File(streamVm.imagePath),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          right: 12,
                                          top: 12,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColor.black
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: AppColor.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_rounded,
                                          size: 48,
                                          color: AppColor.primaryColor,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          LocaleKeys.clickUploadThumbnail.tr(),
                                          style: TextStyle(
                                            color:
                                                AppColor.black.withOpacity(0.6),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${LocaleKeys.recommendedSize.tr()}: 1280x720',
                                          style: TextStyle(
                                            color:
                                                AppColor.black.withOpacity(0.4),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                      if (createLiveVm.logoError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            createLiveVm.logoError!,
                            style: const TextStyle(
                              color: AppColor.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Start Stream Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: AppIconButton(
                      color: AppColor.primaryColor,
                      onPressed: () {
                        if (!createLiveVm.validateForm()) return;
                        createLiveVm.createLiveStreaming(
                          channelName:
                              "$channelName$channelId${createLiveVm.nameController.text}",
                          channelId: channelId,
                          context: context,
                        );
                      },
                      icon: const Icon(
                        Icons.live_tv_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        LocaleKeys.goLive.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Overlay
          if (createLiveVm.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        LocaleKeys.creatingLiveStream.tr(),
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
