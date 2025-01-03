import 'dart:async';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/mappage.dart';
import 'package:wizmir/models/cities.dart';
import 'package:wizmir/models/job.dart';
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
        elevation: 0,
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
  TextEditingController emailcnt = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  String? phonenumber;
  TextEditingController passcnt = TextEditingController();
  Gender? _character;
  String? cinsiyet = "";
  String age = "";
  bool checkvalue = false;
  String kvkk = "";
  City? city;
  District? district;
  Job? job;
  List<City> cities = [];
  List<District> districts = [];
  List<Job> jobs = [];
  List<String> list = List<String>.generate(
      80, (int index) => (DateTime.now().year - index).toString(),
      growable: true);
  @override
  void initState() {
    list.insert(0, "choose".tr());
    setState(() {
      age = list.first;
    });
    getcities();
    getjobs();
    getkvkkdata();
    if (widget.phonenumber != null) {
      setState(() {
        phonenumber = widget.phonenumber;
      });
    }
    super.initState();
  }

  getcities() async {
    var sehirler = await getcitiesfromdb();
    var sehir = sehirler.firstWhere((element) => element.id == "35");
    sehirler.remove(sehir);
    sehirler.insert(0, sehir);
    // sehirler.insert(0, City(id: "0", sehiradi: "choose".tr()));
    setState(() {
      cities = sehirler;
    });
  }

  getdistricts(id) async {
    var ilceler = await getdistrictfromdb(id);
    //  ilceler.insert(0, District(id: "0", ilceadi: "choose".tr()));
    setState(() {
      districts = ilceler;
    });
  }

  getjobs() async {
    var meslekler = await getjobsfromdb();
    setState(() {
      jobs = meslekler;
    });
  }

  getkvkkdata() async {
    kvkk = await getkvkk();
  }

  void _doSomething() async {
    if (checkvalue) {
      if (phonenumber != null &&
          namecnt.text != "" &&
          district != null &&
          job != null) {
        if (phonenumber!.length == 13) {
          if (passcnt.text.length > 5) {
            User user = User(
                telefon: phonenumber!,
                ad: namecnt.text,
                soyad: surnamecnt.text,
                sifre: passcnt.text,
                cinsiyet: cinsiyet!,
                yas: age,
                ilceid: district!.id,
                meslek: job!.id,
                eposta: emailcnt.text);
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
                              if (number.phoneNumber!.length >= 13) {
                                phonecontrol(number.phoneNumber!)
                                    .then((value) async {
                                  if (value == "0") {
                                    setState(() {
                                      phonenumber = number.phoneNumber;
                                    });
                                  } else {
                                    ArtDialogResponse response =
                                        await ArtSweetAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                                // denyButtonText: "Cancel",
                                                // title: "Are you sure?",
                                                confirmButtonColor:
                                                    Colors.lightBlue,
                                                text:
                                                    "haveaccount"
                                                        .tr(),
                                                confirmButtonText: "ok".tr(),
                                                type:
                                                    ArtSweetAlertType.warning));
                                    if (response.isTapConfirmButton) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                      // Toast.show(
                                      //     "theoperationissuccessful_pleaselogin"
                                      //         .tr(),
                                      //     duration: Toast.lengthShort,
                                      //     gravity: Toast.bottom);
                                      return;
                                    }
                                  }
                                });
                              }
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
                          controller: emailcnt,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "email".tr(),
                              contentPadding: const EdgeInsets.all(8),
                              labelText: 'email'.tr(),
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
                            Expanded(
                              flex: 2,
                              child: Text(
                                "age".tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownButton<String>(
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
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "city".tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 2,
                              child: cities.isNotEmpty
                                  ? DropdownButton<City>(
                                      value: city,
                                      elevation: 0,
                                      style: TextStyle(
                                          color: brightness == Brightness.light
                                              ? Colors.black
                                              : null),
                                      onChanged: (City? value) {
                                        setState(() {
                                          city = value!;
                                        });
                                        getdistricts(value!.id);
                                      },
                                      items: cities.map<DropdownMenuItem<City>>(
                                          (City value) {
                                        return DropdownMenuItem<City>(
                                          value: value,
                                          child: Text(value.sehiradi,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        );
                                      }).toList(),
                                    )
                                  : Center(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "district".tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownButton<District>(
                                value: district,
                                elevation: 0,
                                style: TextStyle(
                                    color: brightness == Brightness.light
                                        ? Colors.black
                                        : null),
                                onChanged: (District? value) {
                                  setState(() {
                                    district = value!;
                                  });
                                },
                                items: districts.isNotEmpty
                                    ? districts.map<DropdownMenuItem<District>>(
                                        (District value) {
                                        return DropdownMenuItem<District>(
                                          value: value,
                                          child: Text(value.ilceadi,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        );
                                      }).toList()
                                    : [
                                        DropdownMenuItem<District>(
                                          enabled: false,
                                          value: District(id: "", ilceadi: ""),
                                          child: Text("".tr(),
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        )
                                      ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "job".tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 2,
                              child: jobs.isNotEmpty
                                  ? DropdownButton<Job>(
                                      value: job,
                                      elevation: 0,
                                      style: TextStyle(
                                          color: brightness == Brightness.light
                                              ? Colors.black
                                              : null),
                                      onChanged: (Job? value) {
                                        setState(() {
                                          job = value!;
                                        });
                                      },
                                      items: jobs.map<DropdownMenuItem<Job>>(
                                          (Job value) {
                                        return DropdownMenuItem<Job>(
                                          value: value,
                                          child: Text(value.title,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        );
                                      }).toList(),
                                    )
                                  : DropdownButton<Job>(
                                      elevation: 0,
                                      onChanged: (Job? value) {},
                                      items: [
                                        DropdownMenuItem<Job>(
                                          value:
                                              Job(id: "", title: "choose".tr()),
                                          child: Text("choose".tr(),
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        )
                                      ],
                                    ),
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
