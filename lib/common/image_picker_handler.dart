// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerHnadler {
  static Future showVideoPicker(
      {required BuildContext context, required Function onGetImage}) {
    return showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              vidFromCamera()
                                  .then((value) => onGetImage(value));
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text("Record Video",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 1,
                            thickness: 1,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              vidFromGallery()
                                  .then((value) => onGetImage(value));
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text("Gallery Video",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("cancel");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future showImagePicker(
      {required BuildContext context, required Function onGetImage}) {
    return showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              imgFromCamera()
                                  .then((value) => onGetImage(value));
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text("Take photo",
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 1,
                            thickness: 1,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              imgFromGallery()
                                  .then((value) => onGetImage(value));
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text("Gallery Photo",
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("cancel");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future<dynamic> imgFromCamera() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Reduce quality to prevent memory issues
        maxWidth: 1920, // Limit image size
        maxHeight: 1080, // Limit image size
      );

      return image;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  static Future<dynamic> vidFromCamera() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5), // Limit video duration
      );

      return image;
    } catch (e) {
      print('Error picking video from camera: $e');
      return null;
    }
  }

  static Future<dynamic> vidFromGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10), // Limit video duration
      );

      return image;
    } catch (e) {
      print('Error picking video from gallery: $e');
      return null;
    }
  }

  static Future<dynamic> imgFromGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Reduce quality to prevent memory issues
        maxWidth: 1920, // Limit image size
        maxHeight: 1080, // Limit image size
      );

      return image;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }
}
