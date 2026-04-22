import 'package:flutter/material.dart';

class AppBranding {
  AppBranding._();

  static const String appDisplayName = 'Neoncave Arena';
  static const String headerLogo = 'assets/images/neoncave_header_logo.png';
  static const String splashLogoLight = 'assets/branding/logo_stacked_light.png';
  static const String splashLogoDark = 'assets/branding/logo_stacked_dark.png';
  static const String authLogoAsset = 'assets/branding/logo_horizontal.png';

  static Widget authLogo(BuildContext context, ThemeMode _themeMode) {
    return Image.asset(
      authLogoAsset,
      width: authLogoWidth(context),
      fit: BoxFit.contain,
    );
  }

  static Widget splashLogo(BuildContext context, ThemeMode themeMode) {
    return Image.asset(
      _logoForTheme(themeMode),
      width: splashLogoWidth(context),
      fit: BoxFit.contain,
    );
  }

  static String _logoForTheme(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ? splashLogoDark : splashLogoLight;
  }

  static double authLogoWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.74;
    return width.clamp(220.0, 330.0).toDouble();
  }

  static double splashLogoWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.82;
    return width.clamp(250.0, 390.0).toDouble();
  }
}