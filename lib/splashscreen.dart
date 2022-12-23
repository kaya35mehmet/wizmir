import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:wizmir/animatesplash.dart';
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
  bool showFirst = true;
  bool showanim = true;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      print("timer: ${timer.tick}");
      setState(() {
        if (timer.tick == 2) {
          showanim = false;
        }
        if (timer.tick == 3) {
          showFirst = false;
        }
        if (timer.tick == 5) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              MapPage(
                title: 'WizmirNET',
                guid: widget.guid,
                isadmin: widget.isadmin,
              ),
            ),
          );
        }
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
      body: showanim
          ? Image.asset(
              "assets/images/splash.gif",
              fit: BoxFit.cover,
              height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
            )
          : Stack(
              children: [
                // Opacity(opacity: 0.3,
                // child: SvgPicture.asset("assets/background.svg", fit: BoxFit.cover,)),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 500),
                    firstCurve: Curves.easeInOut,
                    secondCurve: Curves.easeInOut,
                    crossFadeState: showFirst
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: SvgPicture.asset(
                      "assets/images/wizmirnet_icon2.svg",
                      width: 200,
                    ),
                    secondChild: SvgPicture.asset(
                      "assets/images/ibblogo_tuncbey.svg",
                      width: 200,
                    ),
                  ),
                ),
                // showanim ?  Align(
                //     alignment: Alignment.center,
                //     child: Padding(
                //       padding: const EdgeInsets.only(bottom: 38.0),
                //       child: Image.asset(
                //         "assets/images/izmir.png",
                //         width: 200,
                //       ),
                //     ),
                //   ):const Center(),
              ],
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
