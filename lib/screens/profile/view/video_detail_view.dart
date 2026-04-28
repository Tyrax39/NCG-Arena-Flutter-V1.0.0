import 'dart:developer';

import 'package:neoncave_arena/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetail extends StatefulWidget {
  final String videoUrl;
  final String name;
  const VideoDetail({super.key, required this.videoUrl, required this.name});

  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  VideoPlayerController? _controller;
  bool isInitialized = false;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    log(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          isInitialized = true;
        });
      });
  }

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
          widget.name,
          style: TextStyle(
            color: AppColor.black,
          ),
        ),
      ),
      body: Center(
        child: isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  if (!isPlaying)
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 64.0,
                    ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                          isPlaying = false;
                        } else {
                          _controller!.play();
                          isPlaying = true;
                        }
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
