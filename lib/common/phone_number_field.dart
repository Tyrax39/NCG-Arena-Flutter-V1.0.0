// ignore_for_file: library_private_types_in_public_api, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, body_might_complete_normally_nullable, avoid_unnecessary_containers

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';

validatePassword(String value) {
  if (!(value.length > 5) && value.isNotEmpty) {
    return "Password should contain more than 5 characters";
  }
  return null;
}

class PhoneNumberField extends StatefulWidget {
  final bool isPadding;
  final String hintText;
  final TextStyle textStyle;
  final String errorText;
  final double width;
  final bool isOptional;
  final VoidCallback? callback;
  final Function countryPickerCallBack;
  final String sufixIcon;
  final Function(String value) onChange;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final int? maxLength;
  final bool readOnly;
  final String? initialPhoneCode;
  final String? initialFlagEmoji;
  final bool isMyProfile;
  const PhoneNumberField({
    super.key,
    this.maxLength,
    required this.onChange,
    required this.countryPickerCallBack,
    this.isPadding = true,
    this.keyBoardType = TextInputType.text,
    this.isOptional = false,
    this.sufixIcon = "",
    required this.hintText,
    required this.textStyle,
    this.readOnly = false,
    required this.errorText,
    required this.width,
    required this.controller,
    this.callback,
    this.initialPhoneCode,
    this.initialFlagEmoji,
    this.isMyProfile = false,
  });
  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isPadding ? 0 : 0),
      child: TextFormField(
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLength == null
              ? MaxLengthEnforcement.none
              : MaxLengthEnforcement.enforced,
          controller: widget.controller,
          keyboardType: widget.keyBoardType,
          focusNode: focusNode,
          cursorColor: AppColor.primaryColor,
          style: TextStyle(
              color: AppColor.darkText, fontSize: 14, fontFamily: "poppins"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Phone number is required";
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return "Phone number can only contain numbers";
            }
            if (value.length < 9 || value.length > 15) {
              return "Provide a valid phone no";
            }
            return null;
          },
          onChanged: (value) {
            widget.onChange(value);
          },
          onTap: widget.callback,
          decoration: InputDecoration(
              counter: const Offstage(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColor.grey),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  height: 53,
                  width: 90,
                  child: GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            widget.countryPickerCallBack(country.countryCode,
                                country.flagEmoji, "+${country.phoneCode}");
                          });
                        },
                      );
                    },
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap.w(5),
                            Text(
                              widget.initialPhoneCode != null
                                  ? widget.initialPhoneCode!
                                  : '+1',
                              style: TextStyle(
                                  fontSize: 14, color: AppColor.black),
                            ),
                            Gap.w(5),
                            Text(
                              widget.initialFlagEmoji != null
                                  ? widget.initialFlagEmoji!
                                  : '🇺🇸',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Gap.w(10),
                            const SizedBox(
                              height: 20,
                              child: VerticalDivider(
                                width: 5,
                                color: AppColor.grey,
                              ),
                            ),
                            Gap.w(5),
                          ]),
                    ),
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColor.grey),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColor.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.red),
              ),
              filled: true,
              fillColor: AppColor.offwhite,
              hintStyle: widget.textStyle,
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.only(left: 20, top: 15, bottom: 0))),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
