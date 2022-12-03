import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/models/login.dart';
import 'package:wizmir/otp.dart';
import 'package:wizmir/transitions.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "Şifremi unuttum",
          style: TextStyle(color: Colors.black),
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
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: SlideAnimationWidget(),
      ),
    );
  }
}

class SlideAnimationWidget extends StatefulWidget {
  const SlideAnimationWidget({Key? key}) : super(key: key);

  @override
  State<SlideAnimationWidget> createState() => _SlideAnimationWidgetState();
}

class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController cnt = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  String? phonenumber;
  void _doSomething() async {
    Timer(
      const Duration(milliseconds: 500),
      () {
        sendsms(phonenumber!, "forgotpassword").then((value) {
          if (value == "333") {
            Navigator.push(context, ScaleTransitions( OTPPage(type: "1",username: phonenumber!,isadmin: false,)));
          } else {
            Toast.show("anerroroccurred_pleasetryagain".tr(),
                duration: Toast.lengthShort, gravity: Toast.bottom);
          }
        });
        _btnController.reset();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return AnimationLimiter(
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
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: w / 20),
                height: w,
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
                    InternationalPhoneNumberInput(
                      searchBoxDecoration: InputDecoration(
                          labelText:
                              "searchbycountrynameordialingcode".tr()),
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          phonenumber = number.phoneNumber;
                        });
                      },
                      onInputValidated: (bool value) {},
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      hintText: "phonenumber".tr(),
                      errorMessage: "wrongnumber".tr(),
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: cnt,
                      formatInput: false,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
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
    ));
  }
}
