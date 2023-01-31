import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/models/kvkk.dart';
import 'package:wizmir/models/login.dart';
import 'package:wizmir/models/user.dart';
import 'package:wizmir/otp.dart';
import 'package:wizmir/transitions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(
      {Key? key, this.includeMarkAsDoneButton = true, this.phonenumber})
      : super(key: key);
  final String? phonenumber;
  final bool includeMarkAsDoneButton;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brightness == Brightness.light ? Colors.white : null,
        title: Text(
          'register'.tr(),
          style: TextStyle(
              color: brightness == Brightness.light ? Colors.black : null),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(
            Icons.arrow_back_ios,
            color: brightness == Brightness.light ? Colors.black : null,
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
  const SlideAnimationWidget({Key? key, this.phonenumber}) : super(key: key);
  final String? phonenumber;

  @override
  State<SlideAnimationWidget> createState() => _SlideAnimationWidgetState();
}

enum Gender { erkek, kadin }

class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController cnt = TextEditingController();
  TextEditingController namecnt = TextEditingController();
  TextEditingController surnamecnt = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  String? phonenumber;
  TextEditingController passcnt = TextEditingController();
  Gender? _character = Gender.kadin;
  String cinsiyet = "female".tr();
  String age = "";
  bool checkvalue = false;
  String kvkk = "";
  List<String> list = List<String>.generate(
      80, (int index) => (DateTime.now().year - index).toString(),
      growable: true);
  @override
  void initState() {
    list.insert(0, "choose".tr());
    setState(() {
      age = list.first;
    });
    getkvkkdata();
    if (widget.phonenumber != null) {
      setState(() {
        phonenumber = widget.phonenumber;
      });
    }
    super.initState();
  }

  getkvkkdata() async {
    kvkk = await getkvkk();
  }

  void _doSomething() async {
    if (checkvalue) {
      if (age != "Choose" && age != "Seçiniz") {
        if (phonenumber != null && namecnt.text != "") {
          if (phonenumber!.length == 13) {
            if (passcnt.text.length > 5) {
              User user = User(
                telefon: phonenumber!,
                ad: namecnt.text,
                soyad: surnamecnt.text,
                sifre: passcnt.text,
                cinsiyet: cinsiyet,
                yas: age,
              );
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
    } else {
      Toast.show("pleasecheck".tr(),
          duration: Toast.lengthShort, gravity: Toast.bottom);
    }
    _btnController.reset();
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
                        color: brightness == Brightness.light
                            ? Colors.white
                            : null,
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
                        border: brightness == Brightness.dark
                            ? Border.all(color: Colors.white)
                            : null),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 0,
                        ),
                        Image.asset(
                          "assets/images/wizmirnetson.png",
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(color: Colors.grey)),
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
                            selectorTextStyle: TextStyle(
                                color: brightness == Brightness.light
                                    ? Colors.black
                                    : null),
                            initialValue: number,
                            textFieldController: cnt,
                            formatInput: false,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: namecnt,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              labelText: 'name'.tr(),
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: surnamecnt,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              labelText: 'surname'.tr(),
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
                              style: TextStyle(
                                  color: brightness == Brightness.light
                                      ? Colors.black
                                      : null),
                              onChanged: (String? value) {
                                setState(() {
                                  age = value!.toString();
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Checkbox(
                                value: checkvalue,
                                onChanged: (value) {
                                  setState(() {
                                    checkvalue = !checkvalue;
                                  });
                                }),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [Text(kvkk)],
                                      ),
                                      actions: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: Text("ok".tr())),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  "kvkk".tr(),
                                  style: const TextStyle(
                                      color: Color.fromARGB(249, 36, 36, 159)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RoundedLoadingButton(
                          borderRadius: 10,
                          width: double.infinity,
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
        ),
      ),
    );
  }
}
