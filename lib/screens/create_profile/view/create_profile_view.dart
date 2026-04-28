import 'dart:io';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/common/date_time_picker.dart';
import 'package:neoncave_arena/common/image_picker_handler.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/screens/create_profile/view_model/create_profile_view_model.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/phone_number_field.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_appbar.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  DialogHelper get _dialogueHelper => DialogHelper.instance();

  Future<void> _createProfile(CreateProfileViewModel profileVm,
      BuildContext context, DialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.profileCreating.tr());
    try {
      final response = await profileVm.createProfile(context);
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
              content: LocaleKeys.profileCreatedSuccessfully.tr(),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 100));
      Navigator.pushNamed(
        context,
        MyRoutes.selectChannel,
      );
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _createProfile(profileVm, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.screenBG,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Consumer<CreateProfileViewModel>(
              builder: (context, profileVM, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryAppBar(
                      title: LocaleKeys.fillYourProfile.tr(),
                      isBackIcon: false,
                    ),
                    Gap.h(30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  child: profileVM.imagePath.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.file(
                                            File(profileVM.imagePath),
                                            fit: BoxFit.cover,
                                            height: 125,
                                            width: 125,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: profileVM.imagePath,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                    'assets/images/profilePlaceholder.jpg'),
                                            // const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
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
                                          profileVM.newImagePath(val.path);
                                          profileVM.clearImageError();
                                        }
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 80, left: 90),
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                          if (profileVM.imageError != null)
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Text(
                                profileVM.imageError!,
                                style: const TextStyle(
                                  color: AppColor.red,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                          Gap.h(20),
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
                            prefixIcon: 'assets/images/nameIcon.png',
                          ),
                          profileVM.usernameError != null &&
                                  profileVM.usernameError!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    profileVM.usernameError!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          Gap.h(20),
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
                                minWidth: AppConfig(context).width - 40,
                              ),
                              position: PopupMenuPosition.over,
                              itemBuilder: (context) {
                                return profileVM.roleName.keys
                                    .map((String role) {
                                  return PopupMenuItem<String>(
                                    value: role,
                                    child: GestureDetector(
                                      onTap: () {
                                        profileVM.setSelectedRole(role);
                                        Navigator.pop(context);
                                        profileVM.clearRoleError();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Container(
                                          color: AppColor.screenBG,
                                          height: 30,
                                          width: AppConfig(context).width,
                                          child: CustomText(
                                            title: role,
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
                                    border: Border.all(
                                        color: AppColor.grey, width: .8),
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColor.offwhite),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Gap.w(8),
                                      Image.asset(
                                        'assets/images/userrole.png',
                                        height: 17,
                                        color: AppColor.grey,
                                      ),
                                      Gap.w(15),
                                      Expanded(
                                        child: CustomText(
                                          txtOverFlow: TextOverflow.visible,
                                          softWrap: true,
                                          alignment: TextAlign.justify,
                                          title: profileVM.selectedRoleId !=
                                                  null
                                              ? profileVM.roleName.keys
                                                  .firstWhere(
                                                  (role) =>
                                                      profileVM
                                                          .roleName[role] ==
                                                      profileVM.selectedRoleId,
                                                  orElse: () => LocaleKeys
                                                      .selectRole
                                                      .tr(),
                                                )
                                              : LocaleKeys.selectRole.tr(),
                                          color:
                                              profileVM.selectedRoleId != null
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
                          profileVM.roleError != null &&
                                  profileVM.roleError!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    profileVM.roleError!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          Gap.h(20),
                          PrimaryTextField(
                            isPass: false,
                            readOnly: true,
                            onTap: () async {
                              // final DateTime? date = await showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime.now(),
                              //   lastDate: DateTime(2101),
                              //   builder: (context, child) {
                              //     return Theme(
                              //       data: Theme.of(context).copyWith(
                              //         colorScheme: ColorScheme.light(
                              //           primary: AppColor.primaryColor,
                              //         ),
                              //       ),
                              //       child: child!,
                              //     );
                              //   },
                              // );
                              // if (date != null) {
                              //   profileVM.onSelectAgeExpiry(date);
                              //   profileVM.clearDobError();
                              // }
                              final DateTime today = DateTime.now();
                              final DateTime maxAllowedDOB = DateTime(today.year - 13, today.month, today.day);

                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: maxAllowedDOB,
                                firstDate: DateTime(1900), // any reasonable past year
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
                                profileVM.clearDobError();
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
                            controller: profileVM.ageController,
                            headingText: "",
                            prefixIcon: 'assets/images/calendar.png',
                          ),
                          profileVM.dobError != null &&
                                  profileVM.dobError!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    profileVM.dobError!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          Gap.h(20),
                          PhoneNumberField(
                            isMyProfile: false,
                            keyBoardType: TextInputType.phone,
                            onChange: (onChange) {
                              profileVM.clearPhoneError();
                            },
                            hintText: LocaleKeys.enterYourPhone.tr(),
                            textStyle: const TextStyle(
                              color: AppColor.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                            errorText: LocaleKeys.enterYourPhone.tr(),
                            maxLength: 14,
                            width: 0,
                            controller: profileVM.phoneController,
                            countryPickerCallBack: (String countryCode,
                                String flagEmoji, String phoneCode) {
                              profileVM.addPhoneValue(
                                  countryCode, phoneCode, flagEmoji);
                            },
                            initialFlagEmoji: profileVM.flagEmoji,
                            initialPhoneCode: profileVM.phoneCode,
                          ),
                          profileVM.phoneError != null &&
                                  profileVM.phoneError!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    profileVM.phoneError!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          Gap.h(20),
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
                                  profileVM.clearGenderError();
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
                                          color: profileVM
                                                  .selectedGender.isNotEmpty
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
                          profileVM.genderError != null &&
                                  profileVM.genderError!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    profileVM.genderError!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Consumer<CreateProfileViewModel>(
            builder: (context, profileVm, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: PrimaryBTN(
              callback: () async {
                if (profileVm.profileValidator()) {
                  _createProfile(profileVm, context, _dialogueHelper);
                }
              },
              color: AppColor.primaryColor,
              title: LocaleKeys.continueText.tr(),
              width: AppConfig(context).width - 0,
            ),
          );
        }),
      ),
    );
  }
}
