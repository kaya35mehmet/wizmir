import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/mappage.dart';
import 'package:wizmir/models/user.dart';
import 'package:wizmir/transitions.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key, required this.isadmin}) : super(key: key);
  final bool isadmin;
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: brightness == Brightness.light ? Colors.black : null,
        ),
        centerTitle: true,
        title: Text(
          "updateprofile".tr(),
          style: TextStyle(
              color: brightness == Brightness.light ? Colors.black : null),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SlideAnimationWidget(
          isadmin: widget.isadmin,
        ),
      ),
    );
  }
}

class SlideAnimationWidget extends StatefulWidget {
  const SlideAnimationWidget({Key? key, required this.isadmin})
      : super(key: key);
  final bool isadmin;
  @override
  State<SlideAnimationWidget> createState() => _SlideAnimationWidgetState();
}

enum Gender { erkek, kadin }

List<String> list = List<String>.generate(
    80, (int index) => (DateTime.now().year - index).toString(),
    growable: true);

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
  TextEditingController namecnt = TextEditingController();
  TextEditingController surnamecnt = TextEditingController();
  Gender? _character;
  String? cinsiyet;
  String? age = "choose".tr();
  late Future<int> data;

  @override
  void initState() {
    data = getdata();
    // list.insert(0, "choose".tr());
    setState(() {
      age = list.first;
    });
    super.initState();
  }

  void _doSomething() async {
    Timer(
      const Duration(milliseconds: 500),
      () {
        updateprfil(phonenumber!, namecnt.text, surnamecnt.text, cinsiyet, age)
            .then((value) {
          Navigator.push(
              context,
              ScaleTransitions(MapPage(
                title: "Wizmirnet",
                isadmin: widget.isadmin,
              )));
          Toast.show("succesful".tr(),
              duration: Toast.lengthShort, gravity: Toast.bottom);
          _btnController.reset();
        });
      },
    );
  }

  Future<int> getdata() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 4000));
    User user = await getuserbyusername();
      setState(() {
        phonenumber = user.telefon;
        cnt.text = user.telefon.substring(2, user.telefon.length);
        namecnt.text = user.ad;
        surnamecnt.text = user.soyad;
        age = user.yas == "0" ? "choose".tr() : user.yas;
        cinsiyet = user.cinsiyet == "male".tr() ? "male".tr() : "female".tr();
        _character = user.cinsiyet ==  "male".tr() ? Gender.erkek : Gender.kadin;
      });
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return SingleChildScrollView(
      child: FutureBuilder<int>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
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
                                  height: 20,
                                ),
                                Image.asset(
                                  "assets/images/wizmirnetson.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
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
                                Row(
                                  children: [
                                    Text(
                                      "age".tr(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
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
                                              style: const TextStyle(
                                                  fontSize: 16)),
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
                                  child: Text('save'.tr(),
                                      style:
                                          const TextStyle(color: Colors.white)),
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
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
          }),
    );
  }
}
