import 'dart:io';
import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/image_picker_handler.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/create_team/view_model/create_team_view_model.dart';
import 'package:neoncave_arena/backend/server_response.dart';
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

class CreateTeam extends StatefulWidget {
  const CreateTeam({super.key});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  @override
  void initState() {
    final teamVm = Provider.of<CreateTeamViewModel>(context, listen: false);
    teamVm.getGames();
    super.initState();
  }

  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createTeam(CreateTeamViewModel teamVm, BuildContext context,
      DialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.creatingTeam.tr());
    try {
      final response = await teamVm.createTeam();
      dialogHelper.dismissProgress();
      if (response.status != 200) {
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
              content: LocaleKeys.teamCreated.tr(),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      // Delay navigation to allow the snackbar to display
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _createTeam(teamVm, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    DefaultStyles customStyles = DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        TextStyle(
            color: AppColor.black, fontSize: 15, fontWeight: FontWeight.w300),
        const HorizontalSpacing(6, 0),
        const VerticalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        null,
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.createTeam.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.h(20),
                Consumer<CreateTeamViewModel>(
                    builder: (context, viewModel, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.groups_rounded,
                                color: AppColor.primaryColor,
                                size: 24,
                              ),
                            ),
                            Gap.w(14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: LocaleKeys.createYourTeam.tr(),
                                    color: AppColor.black,
                                    size: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  Gap.h(4),
                                  CustomText(
                                    title: LocaleKeys.teamProfileDetails.tr(),
                                    color: AppColor.grey,
                                    size: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.photo_camera,
                                      color: AppColor.primaryColor,
                                      size: 20,
                                    ),
                                    Gap.w(8),
                                    CustomText(
                                      title: LocaleKeys.teamLogo.tr(),
                                      color: AppColor.black,
                                      size: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                Gap.h(4),
                                CustomText(
                                  title: LocaleKeys.uploadTeamLogoHint.tr(),
                                  color: AppColor.grey,
                                  size: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Gap.h(16),
                                Center(
                                  child: InkWell(
                                    onTap: () async {
                                      FilePickerHnadler.showImagePicker(
                                        context: context,
                                        onGetImage: (val) async {
                                          if (val != null) {
                                            viewModel.newImagePath(val.path);
                                            viewModel.clearLogoError();
                                          }
                                        },
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      width: double.infinity,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          width: 1,
                                          color: viewModel.logoError != null
                                              ? Colors.red
                                              : AppColor.grey,
                                        ),
                                        color: AppColor.offwhite,
                                      ),
                                      child: viewModel.imagePath.isNotEmpty
                                          ? Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.file(
                                                    File(viewModel.imagePath),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 10,
                                                  top: 10,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        FilePickerHnadler
                                                            .showImagePicker(
                                                          context: context,
                                                          onGetImage:
                                                              (val) async {
                                                            if (val != null) {
                                                              viewModel
                                                                  .newImagePath(
                                                                      val.path);
                                                              viewModel
                                                                  .clearLogoError();
                                                            }
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.panorama_outlined,
                                                  size: 40,
                                                  color: AppColor.primaryColor,
                                                ),
                                                Gap.h(4),
                                                CustomText(
                                                  title: LocaleKeys
                                                      .clickToUpload
                                                      .tr(),
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
                                viewModel.logoError != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            Gap.w(6),
                                            Text(
                                              viewModel.logoError!,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: LocaleKeys.teamName.tr(),
                                  color: AppColor.black,
                                  size: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                Gap.h(8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.offwhite,
                                        border: Border.all(
                                          width: 1,
                                          color: viewModel.teamNameError != null
                                              ? Colors.red
                                              : Colors.transparent,
                                        ),
                                      ),
                                      child: PrimaryTextField(
                                        isPass: false,
                                        onChange: (value) {
                                          viewModel.clearTeamNameError();
                                        },
                                        prefixIcon: 'assets/images/group.png',
                                        hintText: LocaleKeys.enterTeamName.tr(),
                                        textStyle: const TextStyle(
                                            color: AppColor.grey, fontSize: 12),
                                        errorText: '',
                                        width: AppConfig(context).width,
                                        controller: viewModel.teamName,
                                        headingText: '',
                                      ),
                                    ),
                                  ),
                                ),
                                viewModel.teamNameError != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            Gap.w(6),
                                            Expanded(
                                              child: Text(
                                                viewModel.teamNameError!,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                Gap.h(10),
                                CustomText(
                                  title: LocaleKeys.selectGame.tr(),
                                  color: AppColor.black,
                                  size: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                Gap.h(8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: PopupMenuButton<GameModel>(
                                    color: AppColor.screenBG,
                                    shadowColor: AppColor.offwhite,
                                    offset: const Offset(0, 50),
                                    elevation: 5,
                                    tooltip: '',
                                    splashRadius: 0,
                                    onSelected: (GameModel selectedItem) {
                                      viewModel.setSelectedGame(
                                          selectedItem, selectedItem.id!);
                                      viewModel.clearGameIdError();
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    constraints: BoxConstraints(
                                      maxHeight: AppConfig(context).width * .9,
                                      minWidth: AppConfig(context).width - 40,
                                    ),
                                    position: PopupMenuPosition.over,
                                    itemBuilder: (context) {
                                      return viewModel.gameData
                                          .map((GameModel game) {
                                        return PopupMenuItem<GameModel>(
                                          value: game,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: AppColor.primaryColor
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.sports_esports,
                                                    color:
                                                        AppColor.primaryColor,
                                                    size: 16,
                                                  ),
                                                ),
                                                Gap.w(12),
                                                Expanded(
                                                  child: CustomText(
                                                    title: "${game.gameName}",
                                                    color: AppColor.black,
                                                    size: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.offwhite,
                                        border: Border.all(
                                          width: 1,
                                          color: viewModel.gameIdError != null
                                              ? AppColor.red
                                              : AppColor.grey,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.sports_esports,
                                              size: 18,
                                              color:
                                                  viewModel.selectedGame != null
                                                      ? AppColor.primaryColor
                                                      : AppColor.grey,
                                            ),
                                            Gap.w(12),
                                            Expanded(
                                              child: CustomText(
                                                txtOverFlow:
                                                    TextOverflow.visible,
                                                softWrap: true,
                                                alignment: TextAlign.justify,
                                                title: viewModel.selectedGame
                                                        ?.gameName ??
                                                    LocaleKeys.selectGame.tr(),
                                                color: viewModel.selectedGame !=
                                                        null
                                                    ? AppColor.black
                                                    : AppColor.grey,
                                                size: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 22,
                                              color: AppColor.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                viewModel.gameIdError != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            Gap.w(6),
                                            Expanded(
                                              child: Text(
                                                viewModel.gameIdError!,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.description_outlined,
                                      color: AppColor.primaryColor,
                                      size: 20,
                                    ),
                                    Gap.w(8),
                                    CustomText(
                                      title: LocaleKeys.description.tr(),
                                      color: AppColor.black,
                                      size: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                Gap.h(4),
                                CustomText(
                                  title: LocaleKeys.teamDescHint.tr(),
                                  color: AppColor.grey,
                                  size: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Gap.h(16),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color:
                                            viewModel.descriptionError != null
                                                ? AppColor.red
                                                : AppColor.grey,
                                        width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: SizedBox(
                                      height: 220,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.offwhite,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: QuillSimpleToolbar(
                                              controller: viewModel.controller,
                                              config:
                                                  const QuillSimpleToolbarConfig(
                                                      multiRowsDisplay: false),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: AppColor.offwhite,
                                              child: QuillEditor.basic(
                                                controller:
                                                    viewModel.controller,
                                                config: QuillEditorConfig(
                                                  showCursor: true,
                                                  customStyles: customStyles,
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  textSelectionThemeData:
                                                      TextSelectionThemeData(
                                                    cursorColor:
                                                        AppColor.primaryColor,
                                                    selectionHandleColor:
                                                        AppColor.primaryColor,
                                                    selectionColor: AppColor
                                                        .primaryColor
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                viewModel.descriptionError != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, left: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            Gap.w(6),
                                            Expanded(
                                              child: Text(
                                                viewModel.descriptionError!,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap.h(30),
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          Consumer<CreateTeamViewModel>(builder: (context, teamVm, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColor.screenBG,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, -5),
              )
            ],
          ),
          child: PrimaryBTN(
              callback: () {
                if (!teamVm.createTeamValidator()) {
                  return;
                }
                _createTeam(
                  teamVm,
                  context,
                  _dialogueHelper,
                );
              },
              color: AppColor.primaryColor,
              title: LocaleKeys.create.tr(),
              width: AppConfig(context).width,
              height: 55,
              borderRadius: 15,
              fontWeight: FontWeight.w600),
        );
      }),
    );
  }
}
