import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);



  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      
      videoPlayerController:
          VideoPlayerController.asset("assets/video.mp4"),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title:  Text(
            "userguide".tr(),
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlickVideoPlayer(
          flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.fitHeight,
                controls: FlickPortraitControls(
                  progressBarSettings:
                      FlickProgressBarSettings(playedColor: Colors.green),
                ),
              ),
          flickManager: flickManager
        ),
      ),
    );
  }
}