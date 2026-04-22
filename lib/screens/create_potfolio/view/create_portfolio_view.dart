// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/create_potfolio/view_model/create_portfolio_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CreatePortfolio extends StatefulWidget {
  const CreatePortfolio({super.key});

  @override
  State<CreatePortfolio> createState() => _CreatePortfolioState();
}

class _CreatePortfolioState extends State<CreatePortfolio> {
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createPortfolio(
    CreatePortfolioViewModel portfolioVm,
    BuildContext context,
    DialogHelper dialogHelper,
  ) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.creatingPortfolio.tr());
    try {
      final response = await portfolioVm.createPortfolio();
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
              content: LocaleKeys.portfolioAdded.tr(),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.mainScreen, arguments: true, (route) => false);
      });
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _createPortfolio(portfolioVm, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.addPortfolio.tr()),
      body: Consumer<CreatePortfolioViewModel>(
        builder: (context, portfolioVm, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.h(20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColor.primaryColor,
                          size: 24,
                        ),
                        Gap.w(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: LocaleKeys.addToYourPortfolio.tr(),
                                color: AppColor.primaryColor,
                                size: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Gap.h(5),
                              CustomText(
                                title: LocaleKeys.fillOutForm.tr(),
                                color: AppColor.black,
                                size: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.h(25),
                  _buildInputField(
                    title: LocaleKeys.title.tr(),
                    hintText: LocaleKeys.enterTitle.tr(),
                    controller: portfolioVm.titleController,
                    error: portfolioVm.titleError,
                    onChanged: (_) => portfolioVm.emptyTitleErrors(),
                  ),
                  Gap.h(20),
                  _buildInputField(
                    title: LocaleKeys.description.tr(),
                    hintText: LocaleKeys.enterDescription.tr(),
                    controller: portfolioVm.descriptionController,
                    error: portfolioVm.descriptionError,
                    onChanged: (_) => portfolioVm.emptyDescriptionErrors(),
                    maxLines: 4,
                  ),
                  Gap.h(25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            title: LocaleKeys.media.tr(),
                            color: AppColor.black,
                            size: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          Gap.w(5),
                          CustomText(
                            title: LocaleKeys.file.tr(),
                            color: AppColor.primaryColor,
                            size: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      if (portfolioVm.selectedImage != null ||
                          (portfolioVm.videoPlayerController != null &&
                              portfolioVm
                                  .videoPlayerController!.value.isInitialized))
                        InkWell(
                          onTap: () {
                            portfolioVm.resetMedia();
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline,
                                    color: Colors.red.shade700, size: 16),
                                Gap.w(5),
                                CustomText(
                                  title: "Remove",
                                  color: Colors.red.shade700,
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Gap.h(10),
                  InkWell(
                    onTap: () => _showMediaSelectionSheet(),
                    child: Container(
                      height: 200,
                      width: AppConfig(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: portfolioVm.selectedImage != null ||
                                (portfolioVm.videoPlayerController != null &&
                                    portfolioVm.videoPlayerController!.value
                                        .isInitialized)
                            ? Colors.black.withOpacity(0.1)
                            : AppColor.offwhite,
                        border: Border.all(
                            width: 1,
                            color: portfolioVm.mediaError != null
                                ? Colors.red
                                : AppColor.grey.withOpacity(0.3)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: portfolioVm.selectedImage != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    portfolioVm.selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : portfolioVm.videoPlayerController != null &&
                                    portfolioVm.videoPlayerController!.value
                                        .isInitialized
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: portfolioVm
                                            .videoPlayerController!
                                            .value
                                            .aspectRatio,
                                        child: VideoPlayer(
                                            portfolioVm.videoPlayerController!),
                                      ),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 35,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      Gap.h(10),
                                      CustomText(
                                        title: "Add Media Here",
                                        color: AppColor.black.withOpacity(0.6),
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Gap.h(5),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: CustomText(
                                          title: "Tap to upload image or video",
                                          color: AppColor.grey,
                                          size: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                  ),
                  if (portfolioVm.mediaError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Text(
                        portfolioVm.mediaError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  Gap.h(30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: PrimaryBTN(
                      callback: () {
                        if (portfolioVm.portfolioValidator()) {
                          _createPortfolio(
                              portfolioVm, context, _dialogueHelper);
                        }
                      },
                      color: AppColor.primaryColor,
                      title: LocaleKeys.submit.tr(),
                      width: AppConfig(context).width,
                      height: 55,
                    ),
                  ),
                  Gap.h(30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMediaSelectionSheet() {
    final viewModel =
        Provider.of<CreatePortfolioViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.screenBG,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                title: "Select Media",
                color: AppColor.black,
                size: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null && mounted) {
                        final file = File(pickedFile.path);
                        viewModel.handleImageSelection(file);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.image,
                            color: AppColor.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          title: "Image",
                          color: AppColor.black,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      final selectedMedia = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);
                      if (selectedMedia != null && mounted) {
                        final file = File(selectedMedia.path);
                        await viewModel.handleVideoSelection(file);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.videocam,
                            color: AppColor.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          title: "Video",
                          color: AppColor.black,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      final selectedMedia = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (selectedMedia != null && mounted) {
                        final file = File(selectedMedia.path);
                        viewModel.handleImageSelection(file);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColor.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          title: "Camera",
                          color: AppColor.black,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    String? error,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          color: AppColor.black,
          size: 16,
          fontWeight: FontWeight.w600,
        ),
        Gap.h(10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: PrimaryTextField(
            isPass: false,
            onChange: onChanged,
            hintText: hintText,
            textStyle: const TextStyle(
              color: AppColor.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "inter",
            ),
            errorText: '',
            width: AppConfig(context).width,
            controller: controller,
            headingText: '',
            borderColor:
                error != null ? Colors.red : AppColor.grey.withOpacity(0.3),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
