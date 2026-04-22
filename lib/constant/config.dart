// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:neoncave_arena/constant/app_environment.dart';

class Config {
  static const agoraAppId = "03c0e7ea688a4191be2605ea71fa1e7b";
}

class AppConfig {
  static String get privacyPolicyUrl =>
      AppEnvironment.webBaseUrl + "/page/privacy-policy";
  static String get termsOfServiceUrl =>
      AppEnvironment.webBaseUrl + "/page/terms-conditions";
  static String get aboutUsUrl => AppEnvironment.webBaseUrl + "/about-us";
}
