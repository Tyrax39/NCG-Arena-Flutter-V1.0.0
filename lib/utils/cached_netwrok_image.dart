import 'package:neoncave_arena/Theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget cacheImageView({
  required String image,
  BoxFit boxfit = BoxFit.cover,
  BoxFit boxfitErrorWidget = BoxFit.cover,
  double circlularPadding = 10,
  double errorIconSize = 10,
  bool isEasyLoader = false,
  bool isProfilePlaceholder = false,
  bool isVendorPlaceholder = false,
  Color imageColor = Colors.transparent,
  double? height,
  double? width,
}) {
  // return CachedNetworkImage(
  return CachedNetworkImage(
    imageUrl: image,
    fit: boxfit,
    height: height,
    width: width,
    progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
      padding: EdgeInsets.all(circlularPadding),
      child: SizedBox.expand(
        child: Center(
                        child: CupertinoActivityIndicator(
                      color: AppColor.primaryColor,
                      radius: 12,
                    ))
      ),
    ),
    errorWidget: (context, url, error) => isVendorPlaceholder
        ? Image(
            image: const AssetImage(
              'assets/images/profilePlaceholder.jpg',
            ),
            fit: boxfitErrorWidget,
          )
        : isProfilePlaceholder
            ? Image(
                image: const AssetImage(
                  'assets/images/profilePlaceholder.jpg',
                ),
                fit: boxfitErrorWidget,
              )
            : Image(
                image: const AssetImage(
                  'assets/images/profilePlaceholder.jpg',
                ),
                fit: boxfitErrorWidget,
              ),
  );
}
