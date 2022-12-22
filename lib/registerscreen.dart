import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/models/login.dart';
import 'package:wizmir/models/user.dart';
import 'package:wizmir/otp.dart';
import 'package:wizmir/transitions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, this.includeMarkAsDoneButton = true})
      : super(key: key);

  final bool includeMarkAsDoneButton;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text(
          'register'.tr(),
          style:const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          if (widget.includeMarkAsDoneButton)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () => Navigator.pop(context, true),
              tooltip: 'Mark as done',
            )
        ],
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

enum Gender { erkek, kadin }

List<String> list = List<String>.generate(
    83, (int index) => (index + 18).toString(),
    growable: true);

class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController cnt = TextEditingController();
  TextEditingController namecnt = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  String? phonenumber;
  TextEditingController passcnt = TextEditingController();
  Gender? _character = Gender.kadin;
  String cinsiyet = "female".tr();
  String age = "";

  @override
  void initState() {
    list.insert(0, "choose".tr());
    setState(() {
      age = list.first;
    });
    super.initState();
  }

  void _doSomething() async {
    if (age != "Choose" && age != "Seçiniz") {
      if (phonenumber != null && namecnt.text != "") {
        if (phonenumber!.length == 13) {
          if (passcnt.text.length > 5) {
            User user = User(
                telefon: phonenumber!,
                adsoyad: namecnt.text,
                sifre: passcnt.text,
                cinsiyet: cinsiyet,
                yas: age);
            Timer(
              const Duration(milliseconds: 500),
              () {
                sendsms(phonenumber!, "register").then((value) {
                  if (value == "333") {
                    Navigator.push(
                      context,
                      ScaleTransitions(
                        OTPPage(
                          type: "2",
                          username: phonenumber!,
                          user: user,
                          isadmin: false,
                        ),
                      ),
                    );
                  } else {
                    Toast.show("anerroroccurred_pleasetryagain".tr(),
                        duration: Toast.lengthShort, gravity: Toast.bottom);
                  }
                });
              },
            );
          } else {
            Toast.show("yourpasswordmustbeatleast6digits".tr(),
                duration: Toast.lengthShort, gravity: Toast.bottom);
          }
        } else {
          Toast.show("phonenumbermustbe10digits".tr(),
              duration: Toast.lengthShort, gravity: Toast.bottom);
        }
      } else {
        Toast.show("donotleavethefieldsblank".tr(),
            duration: Toast.lengthShort, gravity: Toast.bottom);
      }
    } else {
       Toast.show("chooseyourage".tr(),
            duration: Toast.lengthShort, gravity: Toast.bottom);
    }
    _btnController.reset();
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
          verticalOffset: 900.0,
          child: FlipAnimation(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.fastLinearToSlowEaseIn,
            flipAxis: FlipAxis.y,
            child: Column(
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
                        height: 40,
                      ),
                      InternationalPhoneNumberInput(
                        searchBoxDecoration: InputDecoration(
                            labelText: "searchbycountrynameordialingcode".tr()),
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
                        height: 20,
                      ),
                      TextField(
                        controller: namecnt,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            labelText: 'namesurname'.tr(),
                            border: const OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: passcnt,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            labelText: 'password'.tr(),
                            border: const OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "age".tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          DropdownButton<String>(
                            value: age,
                            elevation: 0,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? value) {
                              setState(() {
                                age = value!.toString();
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString(),
                                    style: const TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: Text('female'.tr()),
                              leading: Radio<Gender>(
                                value: Gender.kadin,
                                groupValue: _character,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    _character = value;
                                    cinsiyet = "female".tr();
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: Text('male'.tr()),
                              leading: Radio<Gender>(
                                value: Gender.erkek,
                                groupValue: _character,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    _character = value;
                                    cinsiyet = "male".tr();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedLoadingButton(
                        controller: _btnController,
                        onPressed: _doSomething,
                        child: Text('register'.tr(),
                            style: const TextStyle(color: Colors.white)),
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
