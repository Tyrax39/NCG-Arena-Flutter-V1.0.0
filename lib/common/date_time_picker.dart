// ignore_for_file: avoid_print

import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showIOSDatePicker(
    {required BuildContext context,
    required Function onSelect,
    DateTime? mindate}) {
  DateTime dateTime = mindate ?? DateTime.now();
  showCupertinoModalPopup(
    useRootNavigator: true,
    context: context,
    builder: (_) => Container(
      height: 350,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const CustomText(
                    title: "Cancel",
                    color: AppColor.red,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onSelect(dateTime);
                    Navigator.pop(context);
                  },
                  child: CustomText(
                    title: "Select",
                    color: AppColor.primaryColor,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: mindate ?? DateTime.now(),
              minimumDate: mindate ?? DateTime(1970),
              maximumDate: DateTime(DateTime.now().year + 10),
              onDateTimeChanged: (val) {
                dateTime = val;
              },
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

void showIOSTimePicker(
    {required BuildContext context, required Function onImageGet}) {
  DateTime dateTime = DateTime.now();

  showCupertinoModalPopup(
    context: context,
    builder: (_) => Container(
      height: 350,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const CustomText(
                    title: "Cancel",
                    color: AppColor.red,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onImageGet(dateTime);
                    Navigator.pop(context);
                  },
                  child: CustomText(
                    title: "Select",
                    color: AppColor.primaryColor,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: CupertinoDatePicker(
              backgroundColor: Colors.white,
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              onDateTimeChanged: (DateTime newTime) {
                print(newTime);
                dateTime = newTime;
              },
            ),
          ),
        ],
      ),
    ),
  );
}
