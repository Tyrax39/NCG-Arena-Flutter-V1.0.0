
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageModel {
  final String code;
  final String name;

  LanguageModel({
    required this.code,
    required this.name,
  });
}

List<LanguageModel> languageList = [
  LanguageModel(
    code: 'en',
    name: LocaleKeys.english.tr(),
  ),
  LanguageModel(
    code: 'ar',
    name: LocaleKeys.arabic.tr(),
  ),
  LanguageModel(
    code: 'hi',
    name: LocaleKeys.hindi.tr(),
  ),
  LanguageModel(
    code: 'fr',
    name: LocaleKeys.french.tr(),
  ),
  LanguageModel(
    code: 'es',
    name: LocaleKeys.spanish.tr(),
  ),
  LanguageModel(
    code: 'zh',
    name: LocaleKeys.chinese.tr(),
  ),

  // Add more riders here
];
