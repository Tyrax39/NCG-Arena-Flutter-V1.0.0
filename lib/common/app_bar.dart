import 'package:neoncave_arena/theme/colors.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // Added actions property

  const CommonAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          color: AppColor.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      actions: actions, // Integrated actions property here
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: AppColor.black,
          height: 0.2,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      backgroundColor: AppColor.screenBG,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
