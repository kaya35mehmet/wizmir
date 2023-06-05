import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/camera.dart';
import 'package:wizmir/models/locations.dart';
import 'package:wizmir/models/problems.dart';
import 'package:wizmir/models/reports.dart';
import 'package:wizmir/transitions.dart';

class ReportDisasterView extends StatefulWidget {
  final bool isadmin;
  final bool islogin;
  final Locations? locations;
  const ReportDisasterView(
      {Key? key, required this.islogin, this.locations, required this.isadmin})
      : super(key: key);

  @override
  State<ReportDisasterView> createState() => _ReportDisasterViewState();
}

class _ReportDisasterViewState extends State<ReportDisasterView> {
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  final ImagePicker _picker = ImagePicker();
  String? phonenumber;
  TextEditingController cnt = TextEditingController();
  TextEditingController desccnt = TextEditingController();
  TextEditingController destroyed = TextEditingController();
  TextEditingController damaged = TextEditingController();
  TextEditingController injured = TextEditingController();
  TextEditingController death = TextEditingController();

  String problem = "";

  List<Problems> list = [];
  late Future<List<Problems>> datalist;
  XFile? file;
  String? selectedValue;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getlist();
    super.initState();
  }

  getlist() async {
    datalist = getdata();
    list = await datalist;
  }

  Future<List<Problems>> getdata() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
    var list = getproblems();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool mobilelayout = 600 < shortestSide;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: brightness == Brightness.light ? Colors.black : null,
        ),
        centerTitle: true,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
              left: mobilelayout ? 240 : 70.0, right: mobilelayout ? 240 : 70),
          child: SafeArea(
            child: Image.asset(
              brightness == Brightness.light
                  ? "assets/images/1.png"
                  : "assets/images/2.png",
            ),
          ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          heroTag: "btn33",
          backgroundColor:
              brightness == Brightness.light ? Colors.white : Colors.blue,
          child: Icon(
            Icons.camera_alt,
            size: 30,
            color: brightness == Brightness.light ? Colors.blue : Colors.white,
          ),
          onPressed: () async {
            WidgetsFlutterBinding.ensureInitialized();
            final cameras = await availableCameras();
            final firstCamera = cameras.first;
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              ScaleTransitions(
                CameraPage(
                  camera: firstCamera,
                ),
              ),
            ).then((value) {
              setState(() {
                file = value;
              });
            });
          },
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<Object>(
            future: datalist,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              TextField(
                                controller: destroyed,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: brightness == Brightness.light
                                            ? Colors.grey
                                            : Colors.white,
                                        width: 1.0),
                                  ),
                                  hintText: 'totaldestroyedbuilding'.tr(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: damaged,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: brightness == Brightness.light
                                            ? Colors.grey
                                            : Colors.white,
                                        width: 1.0),
                                  ),
                                  hintText: 'damagedbuildingtotal'.tr(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: injured,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: brightness == Brightness.light
                                            ? Colors.grey
                                            : Colors.white,
                                        width: 1.0),
                                  ),
                                  hintText: 'totalinjured'.tr(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: death,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: brightness == Brightness.light
                                            ? Colors.grey
                                            : Colors.white,
                                        width: 1.0),
                                  ),
                                  hintText: 'totaldeath'.tr(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: desccnt,
                                minLines: 4,
                                maxLines: 7,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: brightness == Brightness.light
                                            ? Colors.grey
                                            : Colors.white,
                                        width: 1.0),
                                  ),
                                  hintText: 'description'.tr(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              !widget.islogin
                                  ? InternationalPhoneNumberInput(
                                      searchBoxDecoration: InputDecoration(
                                          labelText:
                                              "searchbycountrynameordialingcode"
                                                  .tr()),
                                      onInputChanged: (PhoneNumber number) {
                                        setState(() {
                                          phonenumber = number.phoneNumber;
                                        });
                                      },
                                      onInputValidated: (bool value) {},
                                      selectorConfig: const SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.BOTTOM_SHEET,
                                      ),
                                      ignoreBlank: false,
                                      hintText: "phonenumber".tr(),
                                      errorMessage: "wrongnumber".tr(),
                                      autoValidateMode:
                                          AutovalidateMode.disabled,
                                      selectorTextStyle: TextStyle(
                                          color: brightness == Brightness.light
                                              ? Colors.black
                                              : null),
                                      initialValue: number,
                                      textFieldController: cnt,
                                      formatInput: false,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              signed: true, decimal: true),
                                      inputBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    )
                                  : const Center(),
                              !widget.islogin
                                  ? const SizedBox(height: 30)
                                  : const SizedBox(height: 0),
                              GestureDetector(
                                onTap: () async {
                                  final XFile? result = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  setState(() {
                                    file = result;
                                  });
                                },
                                child: file == null
                                    ? DottedBorder(
                                        color: Colors.grey,
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(4),
                                        padding: const EdgeInsets.all(2),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            color:
                                                brightness == Brightness.light
                                                    ? Colors.black12
                                                    : null,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "clicktouploadfile".tr(),
                                                  style: TextStyle(
                                                      color: brightness ==
                                                              Brightness.light
                                                          ? Colors.black26
                                                          : null,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Semantics(
                                        child: Image.file(
                                          File(file!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                             
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        senddisasterreport(
                                destroyed.text, damaged.text, injured.text, death.text, desccnt.text,
                                file != null ? File(file!.path) : null)
                            .then((value) {
                          Toast.show("sent".tr(),
                              duration: Toast.lengthShort,
                              gravity: Toast.bottom);
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text("send".tr()),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }


}
