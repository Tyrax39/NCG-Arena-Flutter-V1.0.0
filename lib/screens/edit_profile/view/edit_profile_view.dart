// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/date_time_picker.dart';
import 'package:neoncave_arena/common/image_picker_handler.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/screens/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_appbar.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();
  DialogHelper get _dialogueHelper => DialogHelper.instance();

  @override
  void initState() {
    context.read<EditProfileViewModel>().getUserFromSharedPref();
    super.initState();
  }

  Future<void> _handleUpdateProfile(EditProfileViewModel profileVm) async {
    if (!_validateFields(profileVm)) return;

    try {
      _dialogueHelper
        ..injectContext(context)
        ..showProgressDialog('Updating Profile...');

      final response = await profileVm.createProfile(context);

      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      _dialogueHelper.dismissProgress();

      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      if (response.status != 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
            snackbarMessage: SnackbarMessage.smallMessageError(
              content: response.message,
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
          );
        return;
      }

      // Show success message
      _snackbarHelper
        ..injectContext(context)
        ..showSnackbar(
          snackbarMessage: const SnackbarMessage.smallMessage(
            content: 'Profile Updated Successfully',
          ),
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
        );

      // Delay navigation to allow the snackbar to display
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Navigate back after showing the success message
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        _dialogueHelper.dismissProgress();
        _dialogueHelper.showTitleContentDialog(
          MaterialDialogContent.networkError(),
          () => profileVm.createProfile(context),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<EditProfileViewModel>(
            builder: (context, profileVM, child) {
              return Column(
                children: [
                  PrimaryAppBar(
                    title: LocaleKeys.fillYourProfile.tr(),
                    isBackIcon: true,
                  ),
                  Gap.h(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: LocaleKeys.profileImage.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 125,
                                width: 125,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.offwhite,
                                        blurRadius: 2,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]),
                                child: profileVM.imageLogoPath.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File(profileVM.imageLogoPath),
                                          fit: BoxFit.cover,
                                          height: 125,
                                          width: 125,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: profileVM.profile_image,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/images/profilePlaceholder.jpg'),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.transparent,
                                            height: 100,
                                            width: 100,
                                            child: const Icon(
                                              Icons.person,
                                              size: 80,
                                              color: AppColor.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FilePickerHnadler.showImagePicker(
                                    context: context,
                                    onGetImage: (val) async {
                                      if (val != null) {
                                        profileVM.newImageLogoPath(val.path);
                                      }
                                      // log('val------------->>>>>> $val');
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 80, left: 90),
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColor.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          title: LocaleKeys.headerImage.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
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
                                    profileVM.newImageHeaderPath(val.path);
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
                                  color: AppColor.grey,
                                ),
                                color: AppColor.offwhite,
                              ),
                              child: profileVM.headerImagePath.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(profileVM.headerImagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : profileVM.cover_image.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: profileVM.cover_image,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.primaryColor,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.transparent,
                                              child: const Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 40,
                                                color: AppColor.grey,
                                              ),
                                            ),
                                          ),
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
                                              title: LocaleKeys.backgroundImage
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
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.firstName.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        PrimaryTextField(
                          keyBoardType: TextInputType.emailAddress,
                          isPass: false,
                          onChange: (String? value) async {},
                          hintText: LocaleKeys.enterFirstName.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.enterNickname.tr(),
                          width: 0,
                          controller: profileVM.firstNameController,
                          headingText: "headingText",
                          prefixIcon: 'assets/images/nameIcon.png',
                        ),
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.lastName.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        PrimaryTextField(
                          keyBoardType: TextInputType.emailAddress,
                          isPass: false,
                          onChange: (String? value) async {},
                          hintText: LocaleKeys.enterLastName.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.enterNickname.tr(),
                          width: 0,
                          controller: profileVM.lastNameController,
                          headingText: "headingText",
                          prefixIcon: 'assets/images/nameIcon.png',
                        ),
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.username.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        PrimaryTextField(
                          keyBoardType: TextInputType.emailAddress,
                          isPass: false,
                          onChange: (String? value) async {
                            if (value == null) return;
                            await profileVM.validateUsername(value);
                          },
                          hintText: LocaleKeys.enterUsername.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.enterNickname.tr(),
                          width: 0,
                          controller: profileVM.username,
                          headingText: "headingText",
                          prefixIcon: 'assets/images/username.png',
                        ),
                        profileVM.usernameErrorText.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Text(
                                  profileVM.usernameErrorText,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.email.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        PrimaryTextField(
                          keyBoardType: TextInputType.emailAddress,
                          isPass: false,
                          readOnly: true,
                          onChange: (String? value) async {},
                          hintText: LocaleKeys.enterEmail.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.enterNickname.tr(),
                          width: 0,
                          controller: profileVM.emailController,
                          headingText: "headingText",
                          prefixIcon: 'assets/images/email.png',
                        ),
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.userRole.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        SizedBox(
                          child: PopupMenuButton<int>(
                            color: AppColor.screenBG,
                            shadowColor: AppColor.border,
                            offset: const Offset(0, 50),
                            elevation: 2,
                            tooltip: '',
                            splashRadius: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              maxHeight: AppConfig(context).width * .9,
                              minWidth: AppConfig(context).width - 40,
                            ),
                            position: PopupMenuPosition.over,
                            itemBuilder: (context) {
                              return profileVM.userRoles.entries.map((entry) {
                                return PopupMenuItem<int>(
                                  value: entry
                                      .key, // Return the role ID as the value
                                  child: GestureDetector(
                                    onTap: () {
                                      profileVM.selectedUserRoles
                                              .contains(entry.key)
                                          ? profileVM.selectedUserRoles
                                              .remove(entry.key)
                                          : profileVM.selectedUserRoles
                                              .add(entry.key);

                                      profileVM.updateSelectedRoles(
                                          profileVM.selectedUserRoles);
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                        height: 30,
                                        width: AppConfig(context).width * .8,
                                        child: CustomText(
                                          title: entry
                                              .value, // Display the role name
                                          color: AppColor.primaryColor,
                                          size: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            child: Container(
                              height: 50,
                              width: AppConfig(context).width,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColor.grey, width: .8),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColor.offwhite,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Gap.w(8),
                                    Image.asset(
                                      'assets/images/userrole.png',
                                      height: 14,
                                      color: AppColor.grey,
                                    ),
                                    Gap.w(15),
                                    Expanded(
                                      child: CustomText(
                                        txtOverFlow: TextOverflow.visible,
                                        softWrap: true,
                                        alignment: TextAlign.justify,
                                        title: profileVM
                                                .selectedUserRoles.isEmpty
                                            ? LocaleKeys.selectRole.tr()
                                            : profileVM.selectedUserRoles
                                                .map((roleId) =>
                                                    profileVM
                                                        .userRoles[roleId] ??
                                                    '')
                                                .join(', '),
                                        color: profileVM
                                                .selectedUserRoles.isNotEmpty
                                            ? AppColor.black
                                            : AppColor.grey,
                                        size: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                      color: AppColor.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.dateOfBirth.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        PrimaryTextField(
                          isPass: false,
                          readOnly: true,
                          onTap: () async {
                            final DateTime today = DateTime.now();
                            final DateTime maxAllowedDOB = DateTime(
                                today.year - 13, today.month, today.day);

                            // Parse existing date if available
                            DateTime initialDate = maxAllowedDOB;
                            if (profileVM.ageController.text.isNotEmpty) {
                              try {
                                initialDate = DateTime.parse(
                                    profileVM.ageController.text);
                                // Ensure the initial date is not after the max allowed DOB
                                if (initialDate.isAfter(maxAllowedDOB)) {
                                  initialDate = maxAllowedDOB;
                                }
                              } catch (e) {
                                // If parsing fails, use the default max allowed DOB
                                initialDate = maxAllowedDOB;
                              }
                            }

                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate:
                                  DateTime(1900), // any reasonable past year
                              lastDate: maxAllowedDOB,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColor.primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              profileVM.onSelectAgeExpiry(date);
                            }
                          },
                          onChange: (onChange) {},
                          hintText: LocaleKeys.enterDateOfBirth.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.enterDateOfBirth.tr(),
                          width: 0,
                          controller: profileVM.ageDisplayController,
                          headingText: "",
                          prefixIcon: 'assets/images/calendar.png',
                        ),
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.gender.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        SizedBox(
                          child: PopupMenuButton<String>(
                              color: AppColor.screenBG,
                              shadowColor: AppColor.border,
                              offset: const Offset(0, 50),
                              elevation: 2,
                              tooltip: '',
                              splashRadius: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                  maxHeight: AppConfig(context).width * .9,
                                  minWidth: AppConfig(context).width - 40),
                              position: PopupMenuPosition.over,
                              itemBuilder: (context) {
                                return profileVM.selectGender
                                    .map((String item) {
                                  return PopupMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              onSelected: (selectedItem) {
                                profileVM.setSelectedGender(selectedItem);
                              },
                              child: Container(
                                height: 55,
                                width: AppConfig(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.offwhite,
                                  border: Border.all(
                                      color: AppColor.grey, width: .8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Gap.w(8),
                                      Image.asset(
                                        'assets/images/genders.png',
                                        height: 14,
                                        color: AppColor.grey,
                                      ),
                                      Gap.w(15),
                                      CustomText(
                                        title: profileVM.selectedGender,
                                        color:
                                            profileVM.selectedGender.isNotEmpty
                                                ? AppColor.black
                                                : AppColor.grey,
                                        size: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 20,
                                        color: AppColor.black,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        Gap.h(20),
                        CustomText(
                          title: LocaleKeys.about.tr(),
                          color: AppColor.black,
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.h(10),
                        PrimaryTextField(
                          keyBoardType: TextInputType.emailAddress,
                          isPass: false,
                          maxLine: 8,
                          maxLength: 500,
                          onChange: (String? value) async {},
                          hintText: LocaleKeys.about.tr(),
                          textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter"),
                          errorText: LocaleKeys.about.tr(),
                          width: 0,
                          controller: profileVM.aboutController,
                          headingText: "headingText",
                          prefixIcon: '',
                        ),
                        if (profileVM.aboutError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              profileVM.aboutError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar:
          Consumer<EditProfileViewModel>(builder: (context, profileVm, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryBTN(
            callback: () => _handleUpdateProfile(profileVm),
            color: AppColor.primaryColor,
            title: LocaleKeys.editProfile.tr(),
            width: AppConfig(context).width - 0,
          ),
        );
      }),
    );
  }

  bool _validateFields(EditProfileViewModel profileVm) {
    if (profileVm.firstNameController.text.trim().isEmpty) {
      _showError('Please enter first name');
      return false;
    }

    if (profileVm.lastNameController.text.trim().isEmpty) {
      _showError('Please enter last name');
      return false;
    }

    if (profileVm.username.text.trim().isEmpty) {
      _showError('Please enter username');
      return false;
    }

    if (profileVm.usernameErrorText.isNotEmpty) {
      _showError('Please choose a different username');
      return false;
    }

    if (profileVm.selectedUserRoles.isEmpty) {
      _showError('Please select at least one user role');
      return false;
    }

    if (!profileVm.isValidAbout()) {
      _showError('Please enter a valid about section (10-500 characters)');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    _snackbarHelper
      ..injectContext(context)
      ..showSnackbar(
        snackbarMessage: SnackbarMessage.smallMessageError(content: message),
        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100),
      );
  }
}
