import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/mappage.dart';
import 'package:wizmir/models/login.dart';
import 'package:wizmir/transitions.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key, required this.isadmin}) : super(key: key);
  final bool isadmin;
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(
          color:brightness == Brightness.light ? Colors.black : null,
        ),
        centerTitle: true,
        title:  Text(
          "changepassword".tr(),
          style:  TextStyle(color:brightness == Brightness.light ? Colors.black : null ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: brightness == Brightness.light ? Colors.white : null,
      ),
      body:  Padding(
        padding:const EdgeInsets.all(20.0),
        child: SlideAnimationWidget(isadmin: widget.isadmin,),
      ),
    );
  }
}

class SlideAnimationWidget extends StatefulWidget {
  const SlideAnimationWidget({Key? key, required this.isadmin}) : super(key: key);
  final bool isadmin;
  @override
  State<SlideAnimationWidget> createState() => _SlideAnimationWidgetState();
}

class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController newpasscnt = TextEditingController();
  TextEditingController passcnt = TextEditingController();
  TextEditingController renewpasscnt = TextEditingController();
  TextEditingController cnt = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  String? phonenumber;

  @override
  void initState() {
    getnumber();
    super.initState();
  }

  getnumber() async {
    var storage = const FlutterSecureStorage();
    storage.read(key: "number").then((value) => setState(
          () => phonenumber = value,
        ));
  }

  void _doSomething() async {
    Timer(
      const Duration(milliseconds: 500),
      () {
        if (newpasscnt.text == renewpasscnt.text) {
          changepassword(phonenumber!, passcnt.text, newpasscnt.text)
              .then((value) {
            Navigator.push(
                context,
                ScaleTransitions( MapPage(
                  title: "Wizmirnet",
                  isadmin: widget.isadmin,
                )));
            Toast.show("succesful".tr(),
                duration: Toast.lengthShort, gravity: Toast.bottom);
          });
        } else {
          Toast.show("passwordsdonotmatch_pleasetryagain".tr(),
              duration: Toast.lengthShort, gravity: Toast.bottom);
        }
        _btnController.reset();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return SingleChildScrollView(
      child: AnimationLimiter(
          child: AnimationConfiguration.staggeredList(
        position: 2,
        delay: const Duration(milliseconds: 100),
        child: SlideAnimation(
          duration: const Duration(milliseconds: 2500),
          curve: Curves.fastLinearToSlowEaseIn,
          horizontalOffset: 30,
          verticalOffset: 300.0,
          child: FlipAnimation(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.fastLinearToSlowEaseIn,
            flipAxis: FlipAxis.y,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: w / 20),
                  // height: _w,
                  decoration: BoxDecoration(
                    color:brightness == Brightness.light ? Colors.white : null,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                    border: brightness == Brightness.dark ? Border.all(color: Colors.white): null
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SvgPicture.asset(
                        "assets/images/wizmirnet_icon2.svg",
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                       Text(
                        "phonenumber".tr(),
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        phonenumber!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: passcnt,
                        obscureText: true,
                        decoration:  InputDecoration(
                            border:const OutlineInputBorder(),
                            label: Text("enteryourcurrentpassword".tr())),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: newpasscnt,
                        obscureText: true,
                        decoration:  InputDecoration(
                            border:const OutlineInputBorder(),
                            label: Text("enteryournewpassword".tr())),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: renewpasscnt,
                        obscureText: true,
                        decoration:  InputDecoration(
                            border: const OutlineInputBorder(),
                            label: Text("reenteryournewpassword".tr())),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedLoadingButton(
                        controller: _btnController,
                        onPressed: _doSomething,
                        child:  Text('send'.tr(),
                            style:  TextStyle(color:brightness == Brightness.light ? Colors.white : null)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
