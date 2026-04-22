import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:flutter/material.dart';

class PrimaryBTN extends StatelessWidget {
  final double width;
  final String title;
  final VoidCallback? callback;
  final double height;
  final double fontSize;
  final double borderRadius;
  final bool isGradiant;

  final Color color;
  final Color textCLR;
  final FontWeight fontWeight;

  const PrimaryBTN({
    super.key,
    this.borderRadius = 30,
    required this.callback,
    required this.color,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.height = 50,
    this.isGradiant = true,
    this.textCLR = Colors.white,
    required this.title,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: CustomText(
            title: title,
            color: textCLR,
            size: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final Icon icon;
  final Text label;
  final VoidCallback onPressed;
  final Color color;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
