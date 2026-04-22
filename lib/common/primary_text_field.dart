import 'package:neoncave_arena/common/font_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neoncave_arena/theme/colors.dart';
//
// class PrimaryTextField extends StatefulWidget {
//   final bool isPass;
//   final bool isEmail;
//   final bool isPadding;
//   final bool isPhone;
//   final String hintText;
//   final TextStyle textStyle;
//   final String? Function(String?)? validator;
//   final String headingText;
//   final String errorText;
//   final double width;
//   final String prefixIcon;
//   final bool showPrefixIcon;
//   final bool isName;
//   final bool readOnly;
//   final bool isOptional;
//   final int maxLine;
//   final VoidCallback? callback;
//   final Function(String value)? onSubmitted;
//   final String sufixIcon;
//   final Function(String value) onChange;
//   final TextEditingController controller;
//   final TextInputType keyBoardType;
//   final int? maxLength;
//   final Color? fillColor;
//   final List<TextInputFormatter>? inputFormatters;
//   TextCapitalization textCapitalization;
//   final VoidCallback? onTap;
//   final Color? borderColor;
//   final String? counterText;
//
//   PrimaryTextField(
//       {super.key,
//       this.validator,
//       this.inputFormatters,
//       required this.isPass,
//       this.maxLength,
//       required this.onChange,
//       this.onSubmitted,
//       this.fillColor,
//       this.isPadding = true,
//       this.keyBoardType = TextInputType.text,
//       this.isPhone = false,
//       this.isEmail = false,
//       this.textCapitalization = TextCapitalization.none,
//       this.readOnly = false,
//       this.isOptional = false,
//       this.isName = false,
//       this.sufixIcon = "",
//       this.prefixIcon = "",
//       this.showPrefixIcon = true,
//       required this.hintText,
//       required this.textStyle,
//       required this.errorText,
//       required this.width,
//       required this.controller,
//       this.callback,
//       required this.headingText,
//       this.maxLine = 1,
//       this.onTap,
//       this.borderColor,
//       this.counterText
//       // Initialize the onTap property
//       });
//
//   @override
//   _PrimaryTextFieldState createState() => _PrimaryTextFieldState();
// }
//
// class _PrimaryTextFieldState extends State<PrimaryTextField> {
//   bool _showPassword = false;
//   String countryCode = "+1";
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isPass) {
//       _showPassword = true;
//     }
//   }
//
//   FocusNode focusNode = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widget.isPadding ? 0 : 0),
//       child: TextFormField(
//         inputFormatters: widget.inputFormatters,
//         enableInteractiveSelection: true,
//         textCapitalization: widget.textCapitalization,
//         maxLength: widget.maxLength,
//         onFieldSubmitted: widget.onSubmitted,
//         maxLengthEnforcement: widget.maxLength == null
//             ? MaxLengthEnforcement.none
//             : MaxLengthEnforcement.enforced,
//         readOnly: widget.readOnly,
//         controller: widget.controller,
//         keyboardType: widget.keyBoardType,
//         focusNode: widget.readOnly ? AlwaysDisabledFocusNode() : focusNode,
//         cursorColor: AppColor.primaryColor,
//         maxLines: widget.isPass
//             ? 1
//             : widget.maxLine, // Ensuring maxLines is set correctly
//         obscureText: widget.isPass && widget.maxLine == 1
//             ? _showPassword
//             : false, // Prevents multi-line password issues
//         style: TextStyle(
//           color: AppColor.black,
//           fontSize: 12,
//           fontFamily: FontType.Roboto.toString(),
//           fontWeight: FontWeight.w400,
//         ),
//         validator: widget.validator,
//         onChanged: (value) {
//           widget.onChange(value);
//         },
//         onTap: widget.onTap, // Use the onTap property
//         decoration: InputDecoration(
//           counterText: widget.counterText,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//                 color: widget.borderColor ?? AppColor.grey, width: .8),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//                 color: widget.borderColor ?? AppColor.primaryColor, width: .8),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//                 color: widget.borderColor ?? AppColor.grey, width: .8),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//                 color: widget.borderColor ?? AppColor.red, width: .8),
//           ),
//           prefixIcon: widget.showPrefixIcon && widget.prefixIcon.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.all(0.0),
//                   child: Image.asset(
//                     widget.prefixIcon,
//                     scale: 30,
//                     color: Colors.grey[500],
//                   ),
//                 )
//               : null,
//           suffixIcon: widget.isPass
//               ? GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _showPassword = !_showPassword;
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         right: 20, left: 10, bottom: 18, top: 18),
//                     child: Icon(
//                       _showPassword ? Icons.visibility_off : Icons.visibility,
//                       color: AppColor.grey,
//                       size: 20,
//                     ),
//                   ),
//                 )
//               : widget.sufixIcon.isNotEmpty
//                   ? Padding(
//                       padding: const EdgeInsets.only(
//                           right: 15, left: 15, bottom: 15, top: 15),
//                       child: Image(
//                         height: 10,
//                         width: 20,
//                         color: AppColor.greyText,
//                         image: AssetImage(widget.sufixIcon),
//                       ),
//                     )
//                   : const SizedBox(),
//           filled: true,
//           errorStyle: TextStyle(
//             color: AppColor.red,
//             fontSize: 12,
//             fontFamily: FontType.Roboto.toString(),
//             fontWeight: FontWeight.w400,
//           ),
//           hintStyle: widget.textStyle,
//           hintText: widget.hintText,
//           fillColor: widget.fillColor ?? AppColor.offwhite,
//           contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 0),
//         ),
//       ),
//     );
//   }
// }
//
// class AlwaysDisabledFocusNode extends FocusNode {
//   @override
//   bool get hasFocus => false;
// }
//
// class SocialMediaLinkFormatter extends TextInputFormatter {
//   // Regular expression to validate the URL format
//   static final RegExp _urlRegExp = RegExp(
//     r'^(https:\/\/)(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,6}(/.*)?$',
//   );
//
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     // If the new value doesn't match the URL pattern, don't change it
//     if (_urlRegExp.hasMatch(newValue.text)) {
//       return newValue;
//     } else {
//       return oldValue;
//     }
//   }
// }
//

class PrimaryTextField extends StatefulWidget {
  final bool isPass;
  final bool isEmail;
  final bool isPadding;
  final bool isPhone;
  final String hintText;
  final TextStyle textStyle;
  final String? Function(String?)? validator;
  final String headingText;
  final String errorText;
  final double width;
  final String prefixIcon;
  final bool showPrefixIcon;
  final bool isName;
  final bool readOnly;
  final bool isOptional;
  final int maxLine;
  final VoidCallback? callback;
  final Function(String value)? onSubmitted;
  final String sufixIcon;
  final Function(String value) onChange;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final int? maxLength;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final Color? borderColor;
  final String? counterText;
  final double? borderRadius; // Customizable border radius
  final double? borderWidth; // Customizable border width

  PrimaryTextField({
    super.key,
    this.validator,
    this.inputFormatters,
    required this.isPass,
    this.maxLength,
    required this.onChange,
    this.onSubmitted,
    this.fillColor,
    this.isPadding = true,
    this.keyBoardType = TextInputType.text,
    this.isPhone = false,
    this.isEmail = false,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.isOptional = false,
    this.isName = false,
    this.sufixIcon = "",
    this.prefixIcon = "",
    this.showPrefixIcon = true,
    required this.hintText,
    required this.textStyle,
    required this.errorText,
    required this.width,
    required this.controller,
    this.callback,
    required this.headingText,
    this.maxLine = 1,
    this.onTap,
    this.borderColor,
    this.counterText,
    this.borderRadius = 8.0, // Default value for border radius
    this.borderWidth = 0.8, // Default value for border width
  });

  @override
  _PrimaryTextFieldState createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPass) {
      _showPassword = true;
    }
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isPadding ? 0 : 0),
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        enableInteractiveSelection: true,
        textCapitalization: widget.textCapitalization,
        maxLength: widget.maxLength,
        onFieldSubmitted: widget.onSubmitted,
        maxLengthEnforcement: widget.maxLength == null
            ? MaxLengthEnforcement.none
            : MaxLengthEnforcement.enforced,
        readOnly: widget.readOnly,
        controller: widget.controller,
        keyboardType: widget.keyBoardType,
        focusNode: widget.readOnly ? AlwaysDisabledFocusNode() : focusNode,
        cursorColor: AppColor.primaryColor,
        maxLines: widget.isPass
            ? 1
            : widget.maxLine, // Ensuring maxLines is set correctly
        obscureText: widget.isPass && widget.maxLine == 1
            ? _showPassword
            : false, // Prevents multi-line password issues
        style: TextStyle(
          color: AppColor.black,
          fontSize: 12,
          fontFamily: FontType.Roboto.toString(),
          fontWeight: FontWeight.w400,
        ),
        validator: widget.validator,
        onChanged: (value) {
          widget.onChange(value);
        },
        onTap: widget.onTap, // Use the onTap property
        decoration: InputDecoration(
          counterText: widget.counterText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? 8.0), // Use customizable border radius
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColor.grey,
              width: widget.borderWidth ?? 0.8, // Use customizable border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? 8.0), // Use customizable border radius
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColor.primaryColor,
              width: widget.borderWidth ?? 0.8, // Use customizable border width
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? 8.0), // Use customizable border radius
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColor.grey,
              width: widget.borderWidth ?? 0.8, // Use customizable border width
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? 8.0), // Use customizable border radius
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColor.red,
              width: widget.borderWidth ?? 0.8, // Use customizable border width
            ),
          ),
          prefixIcon: widget.showPrefixIcon && widget.prefixIcon.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(
                    widget.prefixIcon,
                    scale: 30,
                    color: Colors.grey[500],
                  ),
                )
              : null,
          suffixIcon: widget.isPass
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 10, bottom: 18, top: 18),
                    child: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColor.grey,
                      size: 20,
                    ),
                  ),
                )
              : widget.sufixIcon.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 15, top: 15),
                      child: Image(
                        height: 10,
                        width: 20,
                        color: AppColor.greyText,
                        image: AssetImage(widget.sufixIcon),
                      ),
                    )
                  : const SizedBox(),
          filled: true,
          errorStyle: TextStyle(
            color: AppColor.red,
            fontSize: 12,
            fontFamily: FontType.Roboto.toString(),
            fontWeight: FontWeight.w400,
          ),
          hintStyle: widget.textStyle,
          hintText: widget.hintText,
          fillColor: widget.fillColor ?? AppColor.offwhite,
          contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 0),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
