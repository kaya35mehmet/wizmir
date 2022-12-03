import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/mappage.dart';
import 'package:wizmir/models/login.dart';
import 'package:wizmir/transitions.dart';

class NewPasswordPage extends StatefulWidget {
  final String phonenumber;
  final bool isadmin;
  const NewPasswordPage({Key? key, required this.phonenumber, required this.isadmin}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title:  Text(
          "newpassword".tr(),
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
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: SlideAnimationWidget(phonenumber: widget.phonenumber,isadmin: widget.isadmin,),
      ),
    );
  }
}

class SlideAnimationWidget extends StatefulWidget {
  const SlideAnimationWidget({Key? key, required this.phonenumber, required this.isadmin,}) : super(key: key);
final String phonenumber;
final bool isadmin;
  @override
  State<SlideAnimationWidget> createState() => _SlideAnimationWidgetState();
}

class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController newpasscnt = TextEditingController();
  TextEditingController renewpasscnt = TextEditingController();
  TextEditingController cnt = TextEditingController();

  // String? phonenumber;

  @override
  void initState() {
    // getnumber();
    super.initState();
  }

  // getnumber() async {
  //   var storage = const FlutterSecureStorage();
  //   storage.read(key: "number").then((value) => setState(
  //         () => phonenumber = value,
  //       ));
  // }

  void _doSomething() async {
   
    Timer(
      const Duration(milliseconds: 500),
      () {
        if (newpasscnt.text == renewpasscnt.text) {
          
          newpassword(widget.phonenumber, newpasscnt.text).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                ScaleTransitions( MapPage(
                  title: "WizmirNET",
                  guid: "0",
                  isadmin: widget.isadmin,
                )),ModalRoute.withName('/'));
                 Toast.show("theoperationissuccessful_pleaselogin".tr(),
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
                    color: Colors.white,
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
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                       Text(
                        "phonenumber".tr(),
                        style:const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.phonenumber,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                            border:const OutlineInputBorder(),
                            label: Text("reenteryournewpassword".tr())),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedLoadingButton(
                        controller: _btnController,
                        onPressed: _doSomething,
                        child:  Text('send'.tr(),
                            style:const TextStyle(color: Colors.white)),
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
