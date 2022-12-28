import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/models/login.dart';
import 'package:wizmir/models/user.dart';
import 'package:wizmir/newpassword.dart';
import 'package:wizmir/transitions.dart';

final inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade400),
);

final inputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
  border: inputBorder,
  focusedBorder: inputBorder,
  enabledBorder: inputBorder,
);

String otpcode1 = '';
String otpcode2 = '';
String otpcode3 = '';
String otpcode4 = '';
String otpcode5 = '';
String otpcode6 = '';

class OTPPage extends StatefulWidget {
  const OTPPage(
      {Key? key,
      required this.type,
      required this.username,
      this.user,
      required this.isadmin})
      : super(key: key);
  final String type;
  final String username;
  final User? user;
  final bool isadmin;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (_start == 0) {
        setState(() {
          _timer!.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _doSomething() async {
    Timer(
      const Duration(milliseconds: 500),
      () {
        String otpcode =
            otpcode1 + otpcode2 + otpcode3 + otpcode4 + otpcode5 + otpcode6;
        if (widget.type == "1") {
          forgotpassword(widget.username, otpcode).then((value) {
            if (value == "333") {
              Navigator.pushAndRemoveUntil(
                  context,
                  ScaleTransitions(NewPasswordPage(
                    phonenumber: widget.username,
                    isadmin: widget.isadmin,
                  )),
                  ModalRoute.withName('/'));
              Toast.show("transactionsuccessful_setyournewpassword".tr(),
                  duration: Toast.lengthShort, gravity: Toast.bottom);
            } else {
              Toast.show("anerroroccurred_pleasetryagain".tr(),
                  duration: Toast.lengthShort, gravity: Toast.bottom);
            }
          });
        }
        if (widget.type == "2") {
          register(widget.user!, otpcode).then((value) {
            if (value == "333") {
              Navigator.pushAndRemoveUntil(
                  context,
                  ScaleTransitions(NewPasswordPage(
                    phonenumber: widget.username,
                    isadmin: widget.isadmin,
                  )),
                  ModalRoute.withName('/'));
              Toast.show("transactionsuccessful_pleaselogin".tr(),
                  duration: Toast.lengthShort, gravity: Toast.bottom);
            } else {
              Toast.show("anerroroccurred_pleasetryagain".tr(),
                  duration: Toast.lengthShort, gravity: Toast.bottom);
            }
          });
        }
      },
    );
    _btnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: brightness == Brightness.light ? Colors.white : null,
      appBar: AppBar(
        backgroundColor: brightness == Brightness.light ? Colors.white : null,
        elevation: 0,
        iconTheme: IconThemeData(
            color: brightness == Brightness.light ? Colors.black : null),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            SvgPicture.asset("assets/images/wizmirnet_icon2.svg",
                width: MediaQuery.of(context).size.width * 0.5),
            const SizedBox(height: 40.0),
            Text(
              "pleaseenterthe6digitcode".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            const OTPFields(),
            const SizedBox(height: 20.0),
            _start > 0
                ? Text(
                    "$_start ${'secondsleft'.tr()}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  )
                : const Center(),
            const SizedBox(height: 10.0),
            _start == 0
                ? TextButton(
                    child: Text(
                      "sendagain".tr(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {},
                  )
                : const Center(),
            const SizedBox(height: 30.0),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: _doSomething,
              child: Text('send'.tr(),
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPFields extends StatefulWidget {
  const OTPFields({
    Key? key,
  }) : super(key: key);

  @override
  State<OTPFields> createState() => _OTPFieldsState();
}

class _OTPFieldsState extends State<OTPFields> {
  FocusNode? pin2FN;
  FocusNode? pin3FN;
  FocusNode? pin4FN;
  FocusNode? pin5FN;
  FocusNode? pin6FN;
  final pinStyle = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    pin2FN = FocusNode();
    pin3FN = FocusNode();
    pin4FN = FocusNode();
    pin5FN = FocusNode();
    pin6FN = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FN?.dispose();
    pin3FN?.dispose();
    pin4FN?.dispose();
    pin5FN?.dispose();
    pin6FN?.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 50,
                child: TextFormField(
                  autofocus: true,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FN);
                    otpcode1 = value;
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  focusNode: pin2FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    nextField(value, pin3FN);
                    otpcode2 = value;
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  focusNode: pin3FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    nextField(value, pin4FN);
                    otpcode3 = value;
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  focusNode: pin4FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(value, pin5FN);
                      otpcode4 = value;
                    }
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  focusNode: pin5FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(value, pin6FN);
                      otpcode5 = value;
                    }
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  focusNode: pin6FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin6FN!.unfocus();
                      otpcode6 = value;
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
