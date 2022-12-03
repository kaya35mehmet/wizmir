import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wizmir/forgotpassword.dart';
import 'package:wizmir/functions.dart';
import 'package:wizmir/registerscreen.dart';

class LoginPanelPage extends StatefulWidget {
  const LoginPanelPage(
      {Key? key,
      required this.islogin,
      required this.callback,
      required this.callbackislogin, required this.pc})
      : super(key: key);
  final bool islogin;
  final Function callback;
  final Function callbackislogin;
  final PanelController pc;
  @override
  State<LoginPanelPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPanelPage> {
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  // final PanelController _pc = PanelController();
  String? phonenumber;
  Widget arrow = const Icon(Icons.arrow_upward);
  bool? islogin;
  bool? floatingActionButtonvisible;
  TextEditingController controller = TextEditingController();
  TextEditingController usercnt = TextEditingController();
  TextEditingController passcnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    islogin = widget.islogin;
    return SlidingUpPanel(
      onPanelOpened: () {
        setState(() {
          arrow = const Icon(
            Icons.arrow_downward,
          );
          widget.callback(false);
        });
      },
      onPanelClosed: () {
        setState(() {
          arrow = const Icon(
            Icons.arrow_upward,
          );
          widget.callback(true);
        });
      },
      boxShadow: const [
        CustomBoxShadow(
            color: Colors.transparent,
            offset: Offset(10.0, 10.0),
            blurRadius: 0.0,
            blurStyle: BlurStyle.outer)
      ],
      controller: widget.pc,
      backdropColor: Colors.transparent,
      color: Colors.transparent,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.5,
      panel: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (widget.pc.isPanelOpen) {
                          setState(() {
                            widget.callback(true);
                          });
                          widget.pc.close();
                        } else {
                          setState(() {
                            widget.callback(false);
                          });
                          widget.pc.open();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text(
                                "login".tr(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto'),
                              ),
                              arrow,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InternationalPhoneNumberInput(
                    searchBoxDecoration: const InputDecoration(
                        labelText:
                            "Ülke adına veya arama koduna göre arama yapın"),
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
                    textFieldController: controller,
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: const OutlineInputBorder(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passcnt,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        labelText: 'Şifre',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                       widget.pc.close();
                      //  setState(() {
                      //       islogin = true;
                      //       passcnt.text = "";
                      //     });
                           widget.callbackislogin(phonenumber!, passcnt.text);
                      // login(phonenumber!, passcnt.text).then((value) {
                      //   if (value == "0") {
                      //     Toast.show("Yanlış kullanıcı adı yada şifre!",
                      //         duration: Toast.lengthShort,
                      //         gravity: Toast.bottom);
                      //   } else {
                      //     _pc.close();
                      //     Toast.show("Giriş başarılı!",
                      //         duration: Toast.lengthShort,
                      //         gravity: Toast.bottom);
                      //     widget.callbackislogin(true);
                      //     setState(() {
                      //       islogin = true;
                      //       passcnt.text = "";
                      //     });
                      //   }
                      // });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      // primary: const Color(0xFFf04136),
                    ),
                    child:  Text("login".tr()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                              fullscreenDialog: true),
                        ),
                        child:  Text(
                          "forgotpassword".tr(),
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OpenContainer(
                    transitionType: _transitionType,
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return const RegisterPage(
                        includeMarkAsDoneButton: false,
                      );
                    },
                    closedElevation: 6.0,
                    // closedShape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(_fabDimension / 2),
                    //   ),
                    // ),
                    // closedColor: Theme.of(context).colorScheme.secondary,
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("register".tr()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
