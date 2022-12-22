import 'package:flutter/material.dart';

class AnimeWidget extends StatefulWidget {
  const AnimeWidget({Key? key}) : super(key: key);

  @override
  State<AnimeWidget> createState() => _TestAnim3WidgetState();
}

class _TestAnim3WidgetState extends State<AnimeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          AnimatedBuilder(
            animation: controller,
            builder: (context, widget) {
              return ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      colors: const [
                        Color.fromARGB(31, 197, 196, 196),
                        Color.fromARGB(255, 136, 193, 240),
                        Color.fromARGB(31, 189, 188, 188)
                      ],
                      stops: [
                        controller.value - 0.3,
                        controller.value,
                        controller.value + 0.3
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.srcIn,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        const SizedBox(height: 100,),
                         Row(
                          children: [
                            Container(
                              height: 2,
                              width: 100,
                              color: Colors.black,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 4,
                              width: 200,
                              color: Colors.black,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                         Row(
                          children: [
                            Container(
                              height: 2,
                              width: 120,
                              color: Colors.black,
                            ),
                            Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 4,
                              width: 270,
                              color: Colors.black,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                         Row(
                          children: [
                            Container(
                              height: 2,
                              width: 100,
                              color: Colors.black,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 4,
                              width: 200,
                              color: Colors.black,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                         const SizedBox(height: 250,),
                         Row(
                          children: [
                            Container(
                              height: 2,
                              width: 100,
                              color: Colors.black,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 3,
                              width: 180,
                              color: Colors.black,
                            ),
                            Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                         Row(
                          children: [
                            Container(
                              height: 2,
                              width: 120,
                              color: Colors.black,
                            ),
                            Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 4,
                              width: 270,
                              color: Colors.black,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                         Row(
                          children: [
                            Container(
                              height: 2,
                              width: 200,
                              color: Colors.black,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 4,
                              width: 240,
                              color: Colors.black,
                            ),
                            Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(24)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}