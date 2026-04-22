import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/theme/colors.dart';

class SearchTabButton extends StatelessWidget {
  final String barName;
  final bool isSelected;
  final double width;
  final Color tileColor;
  final Color titleColor;

  const SearchTabButton(
      {super.key,
      required this.barName,
      this.isSelected = false,
      this.width = 120,
      this.tileColor = Colors.transparent,
      this.titleColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        color: isSelected ? tileColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: CustomText(
          title: barName,
          color: isSelected ? AppColor.black : AppColor.grey,
          fontWeight: FontWeight.w600,
          size: 15,
        ),
      ),
    );
  }
}
