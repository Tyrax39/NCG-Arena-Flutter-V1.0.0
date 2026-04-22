import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/theme/colors.dart';

class AccountTile extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color iconBgColor;

  const AccountTile({
    super.key,
    required this.text,
    required this.image,
    this.onTap,
    this.iconColor = Colors.transparent,
    this.iconBgColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColor.screenBG,
        height: 30,
        width: AppConfig(context).width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: iconBgColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Image.asset(
                  image,
                  scale: 5,
                  color: iconColor,
                ),
              ),
            ),
            Gap.w(20),
            CustomText(
              title: text,
              size: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.black,
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: AppColor.black,
            )
          ],
        ),
      ),
    );
  }
}
