import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? file;
  String uploadbtn = "choose_a_file".tr();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 30),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      await _controller
                          .takePicture()
                          .then((value) => Navigator.pop(context, value));
                      if (!mounted) return;
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.black54,
                    ),
                  ),
                )
                // FloatingActionButton(
                //   heroTag: "btn2",
                //   backgroundColor: const Color(0xFF0AC2A2),
                //   onPressed: () async {
                //     try {
                //       await _initializeControllerFuture;
                //       final image = await _controller.takePicture();
                //       if (!mounted) return;
                //       Navigator.pop(context,image.path);
                //     } catch (e) {}
                //   },
                //   child: const Icon(
                //     Icons.camera_alt,
                //   ),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
