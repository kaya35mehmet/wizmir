import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:wizmir/mappage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.guid, required this.isadmin})
      : super(key: key);
  final String? guid;
  final bool isadmin;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        Navigator.pushReplacement(
            context,
            PageTransition(MapPage(
              title: 'WizmirNET',
              guid: widget.guid,
              isadmin: widget.isadmin,
            )));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
            opacity: 0.5
          ),
        ),
        child: Stack(
          children: [
            // Opacity(
            //     opacity: 0.3,
            //     child: Image.asset(
            //       "assets/images/background.jpg",
            //       height: MediaQuery.of(context).size.height,
            //     )),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/images/wizmirnet_icon2.svg",
                width: 200,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 38.0),
                child: SvgPicture.asset(
                  "assets/images/ibblogo_tuncbey.svg",
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
            );
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 0,
                child: page,
              ),
            );
          },
        );
}
