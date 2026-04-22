import 'package:neoncave_arena/constant/app_config.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpFormFields extends StatelessWidget {
  Function onComplete;
  TextEditingController controller;

  OtpFormFields(
      {super.key, required this.onComplete, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: 6,
      controller: controller,
      obscureText: false,
      textStyle: TextStyle(
          color: AppColor.black,
          fontFamily: "Plus Jakarta Sans",
          fontWeight: FontWeights.medium),
      animationType: AnimationType.fade,
      keyboardType: TextInputType.phone,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: 50,
        fieldWidth: AppConfig(context).width / 9,
        activeFillColor: AppColor.offwhite,
        selectedColor: AppColor.primaryColor,
        activeColor: AppColor.primaryColor,
        inactiveColor: AppColor.lightgrey,
        selectedFillColor: AppColor.offwhite,
        borderWidth: 0,
        inactiveFillColor: AppColor.screenBG,
        disabledColor: AppColor.red,
        fieldOuterPadding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter OTP ";
        }
        return null;
      },
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      onCompleted: (v) {
        //
        debugPrint("Completed");
      },
      onChanged: (value) {
        debugPrint(value);
      },
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
    );
  }
}
