import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/scheduler.dart';
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

    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return Scaffold(
      appBar: AppBar(
          iconTheme:  IconThemeData(
            color: brightness == Brightness.light ? Colors.black : null,
          ),
          centerTitle: true,
          title:  Text(
            "userguide".tr(),
            style:  TextStyle(color:brightness == Brightness.light ? Colors.black : null),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: brightness == Brightness.light ? Colors.white:null,
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