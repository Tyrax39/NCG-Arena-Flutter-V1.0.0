import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';

class OnBoardingScreenModel {
  final String image;
  final String title;
  final String detail;
  OnBoardingScreenModel({
    required this.image,
    required this.title,
    required this.detail,
  });
}

List<OnBoardingScreenModel> onBoardingScreenModel = [
  OnBoardingScreenModel(
      image: 'assets/images/one.jfif',
      title: LocaleKeys.welcomeToNeoncaveArena.tr(),
      detail: LocaleKeys.welcomeText.tr()),
  OnBoardingScreenModel(
    image: 'assets/images/two.jfif',
    title: LocaleKeys.tailoredForYou.tr(),
    detail:
        LocaleKeys.everyJourneyIsUniqueText.tr(),
  ),
  OnBoardingScreenModel(
      image: 'assets/images/three.jfif',
      title: LocaleKeys.trackProgressSucceed.tr(),
      detail:
          LocaleKeys.monitorYourGrowth.tr()),
];
