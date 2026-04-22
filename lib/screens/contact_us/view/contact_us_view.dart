// ignore_for_file: use_build_context_synchronously

import 'package:neoncave_arena/common/app_bar.dart';
import 'package:neoncave_arena/common/material_dialouge_content.dart';
import 'package:neoncave_arena/common/primary_button.dart';
import 'package:neoncave_arena/common/primary_text_field.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/contact_us/view_model/contact_us_view_model.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:neoncave_arena/utils/dialogue_helper.dart';
import 'package:neoncave_arena/utils/snakbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  static const String route = 'contact_us_screen_route';

  const ContactUsScreen({super.key});

  DialogHelper get _dialogHelper => DialogHelper.instance();
  SnackbarHelper get _snackbarHelper => SnackbarHelper.instance();

  Future<void> _contactUs(ContactUsViewModel contactVm, BuildContext context,
      DialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(LocaleKeys.contactUpdate.tr());

    try {
      final response = await contactVm.contactUs(
        name: contactVm.nameController.text,
        message: contactVm.messageController.text,
        email: contactVm.emailController.text,
      );
      dialogHelper.dismissProgress();

      if (response.status == 200) {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessage(content: response.message),
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 90));
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        _snackbarHelper
          ..injectContext(context)
          ..showSnackbar(
              snackbarMessage:
                  SnackbarMessage.smallMessageError(content: response.message),
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 90));
      }
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showTitleContentDialog(MaterialDialogContent.networkError(),
          () => _contactUs(contactVm, context, dialogHelper));
    }
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactVm = Provider.of<ContactUsViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      appBar: CommonAppBar(title: LocaleKeys.contactUs.tr()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: AppConfig(context).width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.grey.withOpacity(.2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.h(10),
                    Center(
                      child: Text(
                        LocaleKeys.quickContact.tr(),
                        style: TextStyle(
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    Gap.h(10),
                    Text(
                      LocaleKeys.name.tr(),
                      style: TextStyle(
                        color: AppColor.black,
                      ),
                    ),
                    Gap.h(10),
                    Consumer<ContactUsViewModel>(
                        builder: (context, contactVm, child) {
                      return PrimaryTextField(
                        keyBoardType: TextInputType.visiblePassword,
                        isPass: false,
                        onChange: (onChange) {},
                        hintText: LocaleKeys.enterName.tr(),
                        textStyle: const TextStyle(
                            color: AppColor.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "inter"),
                        errorText: '',
                        width: 0,
                        prefixIcon: 'assets/images/nameIcon.png',
                        controller: contactVm.nameController,
                        headingText: "",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.nameIsRequired.tr();
                          }
                          return null;
                        },
                      );
                    }),
                    contactVm.nameError != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              contactVm.nameError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          )
                        : const SizedBox(),
                    Gap.h(20),
                    Text(
                      LocaleKeys.email.tr(),
                      style: TextStyle(
                        color: AppColor.black,
                      ),
                    ),
                    Gap.h(10),
                    Consumer<ContactUsViewModel>(
                        builder: (context, contactVm, child) {
                      return PrimaryTextField(
                        keyBoardType: TextInputType.visiblePassword,
                        isPass: false,
                        onChange: (onChange) {},
                        hintText: LocaleKeys.enterEmail.tr(),
                        textStyle: const TextStyle(
                            color: AppColor.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "inter"),
                        errorText: '',
                        width: 0,
                        prefixIcon: 'assets/images/email.png',
                        controller: contactVm.emailController,
                        headingText: "",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.emailIsRequired.tr();
                          }
                          return null;
                        },
                      );
                    }),
                    contactVm.emailError != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              contactVm.emailError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          )
                        : const SizedBox(),
                    Gap.h(20),
                    Text(
                      LocaleKeys.message.tr(),
                      style: TextStyle(
                        color: AppColor.black,
                      ),
                    ),
                    Gap.h(10),
                    Consumer<ContactUsViewModel>(
                        builder: (context, contactVm, child) {
                      return PrimaryTextField(
                        keyBoardType: TextInputType.multiline,
                        isPass: false,
                        onChange: (onChange) {},
                        hintText: LocaleKeys.enterMessage.tr(),
                        textStyle: const TextStyle(
                            color: AppColor.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "inter"),
                        errorText: '',
                        width: 0,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.messageIsRequired.tr();
                          }
                          return null;
                        },
                        controller: contactVm.messageController,
                        headingText: "",
                        maxLine: 5,
                      );
                    }),
                    contactVm.messageError != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              contactVm.messageError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          )
                        : const SizedBox(),
                    Gap.h(20),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Consumer<ContactUsViewModel>(
                        builder: (context, contactVm, child) {
                          return PrimaryBTN(
                              callback: () {
                                if (!contactVm.contactValidator()) {
                                  return;
                                }

                                _contactUs(contactVm, context, _dialogHelper);
                              },
                              color: AppColor.primaryColor,
                              title: LocaleKeys.send.tr(),
                              width: AppConfig(context).width);
                        },
                      ),
                    ),
                    Gap.h(40),
                    Row(
                      // Add row for social icons
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            _launchUrl(Uri.parse('https://www.tiktok.com'));
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: AppColor.grey.withOpacity(.23),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Image.asset(
                                height: 25,
                                width: 25,
                                color: AppColor.black,
                                "assets/images/contact_tiktok.png",
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchUrl(Uri.parse('https://www.instagram.com'));
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: AppColor.grey.withOpacity(.23),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Image.asset(
                                height: 25,
                                width: 25,
                                color: AppColor.black,
                                "assets/images/contact_instagram.png",
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchUrl(Uri.parse('https://youtube.com'));
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: AppColor.grey.withOpacity(.23),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Image.asset(
                                height: 25,
                                width: 25,
                                color: AppColor.black,
                                "assets/images/contact_youtube.png",
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchUrl(
                              Uri.parse(
                                'https://twitter.com',
                              ),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColor.grey.withOpacity(.23),
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                height: 25,
                                width: 25,
                                color: AppColor.black,
                                "assets/images/contact_twitter.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
