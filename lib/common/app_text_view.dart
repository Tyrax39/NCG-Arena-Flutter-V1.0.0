import 'package:neoncave_arena/common/font_type.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';

class CustomText extends StatelessWidget {
  final String title;
  final TextAlign alignment;
  final TextOverflow txtOverFlow;
  final FontStyle style;
  final double letterSpacce;
  final Color color;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;
  final double size;
  final FontType fontType;
  final int? maxLines;
  final bool softWrap;
  final String fontFamily;
  const CustomText({
    super.key,
    this.alignment = TextAlign.center,
    this.fontType = FontType.Roboto,
    this.size = 14,
    this.fontWeight = FontWeights.regular,
    this.textDecoration = TextDecoration.none,
    this.color = Colors.black,
    this.letterSpacce = 0,
    this.style = FontStyle.normal,
    this.txtOverFlow = TextOverflow.visible,
    required this.title,
    this.maxLines,
    this.softWrap = true,
    this.fontFamily = "inter",
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: alignment,
      maxLines: maxLines,
      softWrap: softWrap,
      // style: GoogleFonts.quicksand(
      //   fontStyle: style,
      //   letterSpacing: letterSpacce,
      //   color: color,
      //   decoration: textDecoration,
      //   fontWeight: fontWeight,
      //   fontSize: size,
      // ),
      style: TextStyle(
        fontStyle: style,
        fontFamily: fontFamily,
        letterSpacing: letterSpacce,
        color: color,
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontSize: size,
      ),
    );
  }
}
