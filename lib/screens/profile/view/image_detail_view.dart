import 'package:neoncave_arena/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget {
  final String imageUrl;
  final String name;
  ImageScreen({required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.black,
              size: 18,
            )),
        centerTitle: true,
        title: Text(
          name,
          style: TextStyle(
            color: AppColor.black,
          ),
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
    );
  }
}
