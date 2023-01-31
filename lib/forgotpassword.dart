import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
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
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(
          color: brightness == Brightness.light ? Colors.black : null,
        ),
        centerTitle: true,
        title:  Text(
          "Şifremi unuttum",
          style: TextStyle(color: brightness == Brightness.light ? Colors.black : null),
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
    var brightness = SchedulerBinding.instance.window.platformBrightness;

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
                  color: brightness == Brightness.light ? Colors.white : null,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:  Colors.black.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                  border: brightness == Brightness.dark ? Border.all(color: Colors.white) : null,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset("assets/images/wizmirnetson.png",width: MediaQuery.of(context).size.width * 0.5,),
                    // SvgPicture.asset(
                    //   "assets/images/wizmirnet_icon2.svg",
                    //   width: MediaQuery.of(context).size.width * 0.5,
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left:10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        border:  Border.all(color: Colors.grey)
                      ),
                      child: InternationalPhoneNumberInput(
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
                        selectorTextStyle:  TextStyle(color: brightness == Brightness.light ? Colors.black : null),
                        initialValue: number,
                        textFieldController: cnt,
                        formatInput: false,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        // inputBorder: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundedLoadingButton(
                      width: double.infinity,
                      borderRadius: 10,
                      controller: _btnController,
                      onPressed: _doSomething,
                      child:  Text('send'.tr(),
                          style: TextStyle(color: brightness == Brightness.light ? Colors.white : null)),
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
