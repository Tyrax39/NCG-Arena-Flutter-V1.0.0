// ignore_for_file: sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/onboarding/model/onboarding_model.dart';

class Screen extends StatelessWidget {
  final int index;
  const Screen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: AppConfig(context).height,
          width: AppConfig(context).width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                onBoardingScreenModel[index].image,
              ),
            ),
          ),
        ),
        Container(
          height: AppConfig(context).height,
          width: AppConfig(context).width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/shadow.png',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                alignment: TextAlign.center,
                title: onBoardingScreenModel[index].title,
                size: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              Gap.h(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomText(
                  txtOverFlow: TextOverflow.visible,
                  softWrap: true,
                  alignment: TextAlign.center,
                  title: onBoardingScreenModel[index].detail,
                  size: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Gap.h(120),
            ],
          ),
        ),
      ],
    );
  }
}
