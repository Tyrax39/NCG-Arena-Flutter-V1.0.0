import 'package:neoncave_arena/common/app_text_view.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';

class PrimaryAppBar extends StatelessWidget {
  final String title;
  final bool isBackIcon;

  const PrimaryAppBar({
    super.key,
    this.title = "",
    this.isBackIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          if (isBackIcon)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                iconSize: 44,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColor.black,
                  size: 24,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: CustomText(
                txtOverFlow: TextOverflow.visible,
                title: title,
                size: 20,
                color: AppColor.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
