import 'package:neoncave_arena/theme/colors.dart';
import 'package:neoncave_arena/backend/server_response.dart';
import 'package:neoncave_arena/constant/app_config.dart';
import 'package:neoncave_arena/screens/main/view_model/main_screen_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarosalSlider extends StatelessWidget {
  final List<BannersModel> bannerData;
  const CarosalSlider({
    super.key,
    required this.bannerData,
  });

  @override
  Widget build(BuildContext context) {
    return bannerData.isNotEmpty
        ? Consumer<MainScreenProvider>(builder: (context, homeVM, child) {
            return Column(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {},
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 1,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  itemCount: bannerData.length,
                  itemBuilder: (context, index, realIndex) {
                    var banner = bannerData[index];
                    return Container(
                      width: AppConfig(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: banner.image!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  placeholder: (context, url) => Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColor.primaryColor,
                                      radius: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          })
        : SizedBox(
            child: Container(
              height: 170,
              child: CupertinoActivityIndicator(
                color: AppColor.primaryColor,
                radius: 12,
              ),
            ),
          );
  }
}
