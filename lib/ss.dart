import 'dart:async';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:wizmir/mappage.dart';

class SecondClass extends StatefulWidget {
  const SecondClass(
      {Key? key, this.guid, required this.isadmin, required this.brightness})
      : super(key: key);
  final String? guid;
  final bool isadmin;
  final Brightness brightness;
  @override
  State<SecondClass> createState() => _SecondClassState();
}

class _SecondClassState extends State<SecondClass>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 4000),
    vsync: this,
  )..repeat(reverse: false);
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(milliseconds: 4000),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 1.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  late final Animation<Offset> _offsetAnimation2 = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(2.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller2,
    curve: Curves.elasticIn,
  ));

  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  double _opacity = 0;
  bool _value = true;

  @override
  void initState() {
    super.initState();

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Navigator.of(context).pushReplacement(
              ThisIsFadeRoute(
                route: MapPage(
                  title: 'WizmirNET',
                  guid: widget.guid,
                  isadmin: widget.isadmin,
                ),
                page: null,
              ),
            );
            // Timer(
            //   const Duration(milliseconds: 300),
            //   () {
            //     scaleController.reset();
            //   },
            // );
          }
        },
      );

    scaleAnimation =
        Tween<double>(begin: 0.0, end: 40).animate(scaleController);

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _value = false;
      });
    });
    Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        scaleController.forward();
      });
    });
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF20569c),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  foregroundDecoration:
                      const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
            AnimatedOpacity(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 4),
              opacity: _opacity,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Image.asset(
                      "assets/images/tuncsoyer.png",
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                  )),
            ),
            Center(
              child: AnimatedOpacity(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 5),
                opacity: _opacity,
                child: AnimatedContainer(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(seconds: 2),
                  height: _value ? 250 : 250,
                  width: _value ? 250 : 250,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF20569c),
                        blurRadius: 100,
                        spreadRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.5),
                              shape: BoxShape.circle),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.wifi,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                              ),
                              AnimatedBuilder(
                                animation: scaleAnimation,
                                builder: (c, child) => Transform.scale(
                                  scale: scaleAnimation.value,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF20569c),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SlideTransition(
                          position: _offsetAnimation2,
                          child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              "ÜCRETSİZ VE ENGELSİZ İNTERNET",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 3),
              opacity: _opacity,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/wizmirnetson.png",
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget? page;
  final Widget route;

  ThisIsFadeRoute({required this.page, required this.route})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: route,
          ),
        );
}
