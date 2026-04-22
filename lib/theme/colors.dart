import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../DB/local_handler.dart';

class AppColor extends ChangeNotifier {
  LocalHandler localHandler = LocalHandler();
  ThemeMode? _themeMode;
  AppColor() {
    initializeTheme();
  }
  ThemeMode get getTheme => _themeMode ?? ThemeMode.dark;
  set _setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
  }

  // Get current theme as a string for URL parameters
  String getCurrentThemeForUrl() {
    return _themeMode == ThemeMode.dark ? 'dark' : 'light';
  }

  // Get current theme mode value
  bool isDarkMode() {
    return _themeMode == ThemeMode.dark;
  }

  Future<void> initializeTheme() async {
    String? savedTheme = await localHandler.getTheme();
    if (savedTheme.isNotEmpty) {
      _setThemeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    } else {
      // Default to dark theme when no saved theme is found
      _setThemeMode = ThemeMode.dark;
    }
    setTheme(_themeMode!, notify: false);
  }

  Future<void> setTheme(ThemeMode themeMode, {bool notify = true}) async {
    await localHandler.setTheme(themeMode.name);
    _setThemeMode = themeMode;
    _applyColorsBasedOnTheme();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Platform.isIOS
              ? (themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light)
              : (themeMode == ThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark),
          statusBarColor: screenBG,
          statusBarIconBrightness: Platform.isIOS
              ? (themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light)
              : (themeMode == ThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark),
          systemNavigationBarDividerColor: screenBG,
          systemNavigationBarColor: screenBG,
          systemNavigationBarIconBrightness: Platform.isIOS
              ? (themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light)
              : (themeMode == ThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark),
        ),
      );
    });
    if (notify) notifyListeners();
  }

  void _applyColorsBasedOnTheme() {
    if (_themeMode == ThemeMode.dark) {
      darkText = Colors.white;
      screenBG = const Color(0xff1d2635);
      white = Colors.black;
      primaryColor = const Color(0xff7e5ddc);
      black = Colors.white;
      lightgrey = const Color(0xff232D35);
      offwhite = const Color(0xffFFFFFF).withOpacity(0.05);
      notify = const Color(0xffF9F9F9);
      themeSwitch = const Color(0xff7E0FC6);
      seetingText = Colors.white;
      darkgrey = Colors.white;
      appleTile = const Color(0xffFFFFFF);
      tileText = Colors.black;
      border = const Color(0xff808D9E);
      popup = const Color(0xffFFFFFF).withOpacity(0.1);
      popupBorder = const Color(0xffFFFFFF).withOpacity(0.1);
      notificationTile = const Color(0xffFFFFFF).withOpacity(0.1);
    } else {
      darkText = const Color(0xFF252525);
      screenBG = const Color(0xffFFFFFF);
      primaryColor = const Color(0xff7e5ddc);
      white = Colors.white;
      black = const Color(0xFF000000);
      lightgrey = const Color(0xffE2E8F0);
      offwhite = const Color(0xffF9F9F9);
      notify = const Color(0xffE2E8F0);
      themeSwitch = const Color(0xFF000000);
      seetingText = const Color(0xff3A4750);
      darkgrey = const Color(0xff90A3BF);
      appleTile = const Color(0xFF000000);
      tileText = const Color(0xffFFFFFF);
      border = const Color(0xffE2E8F0);
      popup = const Color(0xffF9F9F9);
      popupBorder = const Color(0xffE2E8F0);
      notificationTile = const Color(0xffFFFFFF);
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarBrightness: Platform.isIOS
                ? (_themeMode == ThemeMode.dark
                    ? Brightness.dark
                    : Brightness.light)
                : (_themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark),
            statusBarColor: screenBG,
            statusBarIconBrightness: Platform.isIOS
                ? (_themeMode == ThemeMode.dark
                    ? Brightness.dark
                    : Brightness.light)
                : (_themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark),
            systemNavigationBarDividerColor: screenBG,
            systemNavigationBarColor: screenBG,
            systemNavigationBarIconBrightness: Platform.isIOS
                ? (_themeMode == ThemeMode.dark
                    ? Brightness.dark
                    : Brightness.light)
                : (_themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark),
          ),
        );
      },
    );
    notifyListeners();
  }

  static Color yellow = const Color(0xffEF9B0F);
  static Color green = const Color(0xff43A047);
  static Color pink = const Color(0xffFFC0CB);
  static Color teal = const Color(0xff008080);
  static Color maroon = const Color(0xff800000);
  static Color notificationTile = const Color(0xffFFFFFF);
  static Color popup = const Color(0xffF9F9F9);
  static Color popupBorder = const Color(0xffE2E8F0);
  static Color primaryColor = const Color(0xff7e5ddc);
  static const Color blue = Color(0xff00A3FF);
  static Color screenBG = const Color(0xffFFFFFF);
  static const Color secondaryColor = Color(0xff5a00d1);
  static Color white = const Color(0xffFFFFFF);
  static Color black = const Color(0xFF000000);
  static const Color red = Color(0xFFFF3131);
  static const Color cream = Color(0xffF08772);
  static const Color transparent = Color(0xff000000);
  static const Color primarySplashColor = Color(0x1A7E0FC6);
  static const Color grey = Color(0xff808D9E);
  static Color lightgrey = const Color(0xffE2E8F0);
  static Color darkgrey = const Color(0xff90A3BF);
  static Color offwhite = const Color(0xffF9F9F9);
  static const Color orange = Color(0xFFF7931A);
  static const Color lightOrange = Color(0xFFFF9900);
  static Color notify = const Color(0xffE2E8F0);
  static Color themeSwitch = const Color(0xFF000000);
  static Color seetingText = const Color(0xff3A4750);
  static Color appleTile = const Color(0xFF000000);
  static Color tileText = const Color(0xffFFFFFF);
  static Color border = const Color(0xffE2E8F0);
  static Color darkText = const Color(0xFF252D31);
  static const Color greyText = Color(0xffACADB9);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xff0EBE7E),
      Color(0xff6BC89C),
    ],
  );
}

class FontWeights {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
