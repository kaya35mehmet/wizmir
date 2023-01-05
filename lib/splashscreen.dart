import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wizmir/mappage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {Key? key, this.guid, required this.isadmin, required this.brightness})
      : super(key: key);
  final String? guid;
  final bool isadmin;
  final Brightness brightness;

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
                !showanim
                    ? Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 38.0),
                          child: Image.asset("assets/images/wizmirnetson.png",width: 200,)
                          // SvgPicture.asset(
                          //   "assets/images/wizmirnet_icon2.svg",
                          //   width: 200,
                          // ),
                        ),
                      )
                    : const Center(),
                !showanim
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 38.0),
                          child: widget.brightness == Brightness.light
                              ? SvgPicture.asset(
                                  "assets/images/tuncbey_light.svg",
                                  width: 200,
                                )
                              : Image.asset(
                                  "assets/images/tuncsoyer.png",
                                  width: 200,
                                ),
                        ),
                      )
                    : const Center(),
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
