import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/models/locations.dart';
import 'package:wizmir/models/problems.dart';
import 'package:wizmir/models/reports.dart';

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
  String problem = "";
  // final List<String> list = [
  //   'Kayıt olamıyorum',
  //   'SMS gelmedi',
  //   'Giriş yapamıyorum'
  // ];

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

  getlist () async {
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          "reportaproblem".tr(),
          style: const TextStyle(color: Colors.black),
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<Object>(
          future: datalist,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Form(
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
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: list.map((item) => DropdownMenuItem<String>(
                                value: item.name,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
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
                    const SizedBox(height: 30),
                    !widget.islogin
                        ? InternationalPhoneNumberInput(
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
                            inputBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4)),
                          )
                        : const Center(),
                    !widget.islogin
                        ? const SizedBox(height: 30)
                        : const SizedBox(height: 0),
                    GestureDetector(
                      onTap: () async {
                        final XFile? result =
                            await _picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          file = result;
                        });
                        print(file);
                      },
                      child: file == null
                          ? DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: Container(
                                  height: MediaQuery.of(context).size.width * 0.8,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  color: Colors.black12,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "clicktouploadfile".tr(),
                                        style: const TextStyle(
                                            color: Colors.black26,
                                            fontWeight: FontWeight.bold),
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
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        sendreport(
                                phonenumber,
                                problem,
                                widget.locations != null
                                    ? widget.locations!.id
                                    : "",
                                File(file!.path))
                            .then((value) {
                          Toast.show("sent".tr(),
                              duration: Toast.lengthShort, gravity: Toast.bottom);
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text("send".tr()),
                    ),
                  ],
                ),
              ),
            );
            } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                     CircularProgressIndicator(),
                  ],
                );
            }
          }
        ),
      ),
    );
  }

  sendissue() {}
}
