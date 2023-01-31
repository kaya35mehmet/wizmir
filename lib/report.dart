import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/camera.dart';
import 'package:wizmir/models/locations.dart';
import 'package:wizmir/models/problems.dart';
import 'package:wizmir/models/reports.dart';
import 'package:wizmir/transitions.dart';

class ReportView extends StatefulWidget {
  final bool islogin;
  final Locations? locations;
  const ReportView({Key? key, required this.islogin, this.locations})
      : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  final ImagePicker _picker = ImagePicker();
  String? phonenumber;
  TextEditingController cnt = TextEditingController();
  TextEditingController desccnt = TextEditingController();
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
              left: mobilelayout ? 240 : 70.0,
              right: mobilelayout ? 240 : 70),
            child: SafeArea(
              child: Image.asset(
                brightness == Brightness.light ? "assets/images/1.png" : "assets/images/2.png",
                fit: BoxFit.cover,
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
              if (snapshot.data != null) {
                var lang = context.locale.toString();
                var items = list
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: lang == "en_US" ? item.sorunTuruIng : item.name,
                        child: Text(
                          lang == "en_US" ? item.sorunTuruIng : item.name,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList();
                items.insert(
                  0,
                  DropdownMenuItem<String>(
                    value: "öneri",
                    child: Text(
                      "suggestion".tr(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
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
                                DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  isExpanded: true,
                                  hint: Text(
                                    'whatsproblem'.tr(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: brightness == Brightness.light
                                        ? Colors.black45
                                        : null,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 60,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  items: items,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'choose'.tr();
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      problem = value.toString();
                                    });
                                  },
                                  onSaved: (value) {
                                    selectedValue = value.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                problem == "Other" || problem == "Diğer" || problem == "öneri"
                                    ? TextField(
                                        controller: desccnt,
                                        minLines: 4,
                                        maxLines: 7,
                                        decoration: InputDecoration(
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: brightness ==
                                                        Brightness.light
                                                    ? Colors.grey
                                                    : Colors.white,
                                                width: 1.0),
                                          ),
                                          hintText: 'description'.tr(),
                                        ),
                                      )
                                    : const Center(),
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
                                          selectorType: PhoneInputSelectorType
                                              .BOTTOM_SHEET,
                                        ),
                                        ignoreBlank: false,
                                        hintText: "phonenumber".tr(),
                                        errorMessage: "wrongnumber".tr(),
                                        autoValidateMode:
                                            AutovalidateMode.disabled,
                                        selectorTextStyle: TextStyle(
                                            color:
                                                brightness == Brightness.light
                                                    ? Colors.black
                                                    : null),
                                        initialValue: number,
                                        textFieldController: cnt,
                                        formatInput: false,
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
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
                                    final XFile? result = await _picker
                                        .pickImage(source: ImageSource.gallery);
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
                                            borderRadius:
                                                const BorderRadius.all(
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
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          sendreport(
                                  phonenumber,
                                  problem,
                                  desccnt.text,
                                  widget.locations != null
                                      ? widget.locations!.id
                                      : "",
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
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LogoandSpinner(
                  imageAssets: 'assets/images/saatkulesi.png',
                  reverse: true,
                  arcColor: Colors.blue,
                  spinSpeed: Duration(milliseconds: 500),
                )
                  ],
                );
              }
            }),
      ),
    );
  }

  sendissue() {
    //  ElevatedButton(
    //                       onPressed: () {
    //                         sendreport(
    //                                 phonenumber,
    //                                 problem,
    //                                 widget.locations != null
    //                                     ? widget.locations!.id
    //                                     : "",
    //                                 File(file!.path))
    //                             .then((value) {
    //                           Toast.show("sent".tr(),
    //                               duration: Toast.lengthShort,
    //                               gravity: Toast.bottom);
    //                           Navigator.pop(context);
    //                         });
    //                       },
    //                       style: ElevatedButton.styleFrom(
    //                         minimumSize: const Size.fromHeight(50),
    //                       ),
    //                       child: Text("send".tr()),
    //                     ),
  }
}
