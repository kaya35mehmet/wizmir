import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/mappage.dart';
import 'package:wizmir/models/cities.dart';
import 'package:wizmir/models/job.dart';
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
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
  TextEditingController emailcnt = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  String? phonenumber;
  TextEditingController namecnt = TextEditingController();
  TextEditingController surnamecnt = TextEditingController();
  Gender? _character;
  String? cinsiyet;
  String? age = "choose".tr();
  late Future<int> data;
  City? city;
  District? district;
  String? districtid;
  Job? job;
  List<City> cities = [];
  List<District> districts = [];
  List<Job> jobs = [];

  @override
  void initState() {
    data = getdata();
    super.initState();
    getcities();
    getjobs();
  }

  getcities() async {
    var sehirler = await getcitiesfromdb();
    var sehir = sehirler.firstWhere((element) => element.id == "35");
    sehirler.remove(sehir);
    sehirler.insert(0, sehir);
    setState(() {
      cities = sehirler;
    });
  }

  getdistricts(id) async {
    var ilceler = await getdistrictfromdb(id);
    setState(() {
      districts = ilceler;
    });
     district = districtid != null
                  ? districts.firstWhere((element) => element.id == districtid)
                  : null;
  }

  getjobs() async {
    var meslekler = await getjobsfromdb();
    setState(() {
      jobs = meslekler;
    });
  }

  void _doSomething() async {
    Timer(
      const Duration(milliseconds: 500),
      () {
        updateprfil(phonenumber!, namecnt.text, surnamecnt.text, emailcnt.text,
                cinsiyet, age, city!.id, district!.id, job!.title)
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
      emailcnt.text = user.eposta!;
      age = user.yas == "0" ? "choose".tr() : user.yas;
      city = user.ilid != null
          ? cities.firstWhere((element) => element.id == user.ilid)
          : null;
      districtid = user.ilceid;
      job = user.meslek != null
          ? jobs.firstWhere((element) => element.title == user.meslek)
          : null;
      cinsiyet = user.cinsiyet == "male".tr() ? "male".tr() : "female".tr();
      _character = user.cinsiyet == "male".tr() ? Gender.erkek : Gender.kadin;
    });
    getdistricts(user.ilid);

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
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "age".tr(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
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
                                            color:
                                                brightness == Brightness.light
                                                    ? Colors.black
                                                    : null),
                                        onChanged: (String? value) {
                                          setState(() {
                                            age = value!.toString();
                                          });
                                        },
                                        items: list
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value.toString(),
                                            child: Text(value.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16)),
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
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
                                                  color: brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : null),
                                              onChanged: (City? value) {
                                                setState(() {
                                                  city = value!;
                                                });
                                                getdistricts(value!.id);
                                              },
                                              items: cities
                                                  .map<DropdownMenuItem<City>>(
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
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
                                            color:
                                                brightness == Brightness.light
                                                    ? Colors.black
                                                    : null),
                                        onChanged: (District? value) {
                                          setState(() {
                                            district = value!;
                                          });
                                        },
                                        items: districts.isNotEmpty
                                            ? districts.map<
                                                    DropdownMenuItem<District>>(
                                                (District value) {
                                                return DropdownMenuItem<
                                                    District>(
                                                  value: value,
                                                  child: Text(value.ilceadi,
                                                      style: const TextStyle(
                                                          fontSize: 14)),
                                                );
                                              }).toList()
                                            : [
                                                DropdownMenuItem<District>(
                                                  enabled: false,
                                                  value: District(
                                                      id: "", ilceadi: ""),
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
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
                                                  color: brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : null),
                                              onChanged: (Job? value) {
                                                setState(() {
                                                  job = value!;
                                                });
                                              },
                                              items: jobs
                                                  .map<DropdownMenuItem<Job>>(
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
                                                  value: Job(
                                                      id: "",
                                                      title: "choose".tr()),
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
                  children:  [
                    LogoandSpinner(
                      imageAssets: brightness == Brightness.light ? 'assets/images/saatkulesi.png' : 'assets/images/saatkulesi_dark1.png',
                      reverse: true,
                      arcColor: Colors.blue,
                      spinSpeed:const Duration(milliseconds: 500),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
