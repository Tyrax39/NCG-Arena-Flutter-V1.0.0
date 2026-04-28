// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, avoid_print

import 'package:neoncave_arena/constant/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';

class ProfileSuccessPopup extends StatefulWidget {
  const ProfileSuccessPopup({
    super.key,
  });

  @override
  State<ProfileSuccessPopup> createState() => _ProfileSuccessPopupState();
}

class _ProfileSuccessPopupState extends State<ProfileSuccessPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.mainScreen, (route) => false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.screenBG,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 420,
          width: double.infinity,
          child: Column(
            children: [
              Gap.h(20),
              Image.asset(
                'assets/images/success image.png',
                scale: 3,
              ),
              Gap.h(20),
              CustomText(
                alignment: TextAlign.center,
                title: "Successfull!",
                size: 18,
                fontWeight: FontWeight.w900,
                color: AppColor.primaryColor,
              ),
              Gap.h(10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: CustomText(
                  alignment: TextAlign.center,
                  softWrap: true,
                  title:
                      "Please wait a moment, we are looking for a suitable recommendation \nfor you.",
                  size: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
              Gap.h(40),
              CupertinoActivityIndicator(
                radius: 25,
                color: AppColor.primaryColor,
              ),
              Gap.h(30),
            ],
          ),
        ),
      ),
    );
  }
}
