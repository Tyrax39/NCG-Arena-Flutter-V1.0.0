import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/routes/app_routes.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/localization/keys/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WithdrawRequestBottomSheet extends StatelessWidget {
  const WithdrawRequestBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.screenBG,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 240,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.h(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  alignment: TextAlign.center,
                  title: LocaleKeys.selectPaymentMethod.tr(),
                  size: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/close.png',
                    height: 13,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
            Gap.h(20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.paypalWithdraw);
              },
              child: Container(
                height: 60,
                width: AppConfig(context).width,
                color: AppColor.screenBG,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/paypal.png',
                      height: 90,
                    ),
                    Gap.w(40),
                    CustomText(
                      alignment: TextAlign.center,
                      title: 'Paypal',
                      size: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black,
                    ),
                  ],
                ),
              ),
            ),
            Gap.h(10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.bankWithdraw);
              },
              child: Container(
                height: 60,
                width: AppConfig(context).width,
                color: AppColor.screenBG,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/bank-transfer.png',
                      height: 90,
                    ),
                    Gap.w(40),
                    CustomText(
                      alignment: TextAlign.center,
                      title: 'Bank',
                      size: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
