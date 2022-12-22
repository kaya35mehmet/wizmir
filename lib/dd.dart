import 'package:flutter/material.dart';



class WifiPage extends StatefulWidget {
  const WifiPage({Key? key}) : super(key: key);

  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;

  @override
  void initState() {
    super.initState();

    firstController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    firstAnimation = Tween<double>(begin: .37, end: .3).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    secondAnimation = Tween<double>(begin: .5, end: .41).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    thirdAnimation = Tween<double>(begin: .63, end: .52).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fourthAnimation = Tween<double>(begin: .76, end: .63).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    firstController.forward();
    secondController.forward();
    thirdController.forward();
    fourthController.forward();
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: CustomPaint(
          painter: DrawPath(
            firstAnimation.value,
            secondAnimation.value,
            thirdAnimation.value,
            fourthAnimation.value,
          ),
          child: const SizedBox(
            height: 100,
            width: 80,
          ),
        ),
      
    );
  }
}

class DrawPath extends CustomPainter {
  final double height1;
  final double height2;
  final double height3;
  final double height4;

  DrawPath(
      this.height1,
      this.height2,
      this.height3,
      this.height4,
      );

  @override
  void paint(Canvas canvas, Size size) {
    Color designColor = const Color(0xffEAEEF0);

    Paint firstPaint = Paint()
      ..color = designColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    Paint secondPaint = Paint()
      ..color = designColor
      ..style = PaintingStyle.fill;

    Path firstPath = Path();
    firstPath.moveTo(0, size.height * height1);
    firstPath.arcToPoint(
      Offset(size.width, size.height * height1),
      radius: const Radius.circular(100),
    );

    canvas.drawPath(firstPath, firstPaint);

    Path secondPath = Path();
    secondPath.moveTo(size.width * .16, size.height * height2);
    secondPath.arcToPoint(
      Offset(size.width * .84, size.height * height2),
      radius: const Radius.circular(60),
    );

    canvas.drawPath(secondPath, firstPaint);

    Path thirdPath = Path();
    thirdPath.moveTo(size.width * .33, size.height * height3);
    thirdPath.arcToPoint(
      Offset(size.width * .67, size.height * height3),
      radius: const Radius.circular(27),
    );

    canvas.drawPath(thirdPath, firstPaint);

    canvas.drawCircle(
        Offset(size.width * .5, size.height * height4),4, secondPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}