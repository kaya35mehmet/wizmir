import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      required this.callbackislogin,
      required this.pc})
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

    var brightness = SchedulerBinding.instance.window.platformBrightness;
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
      color: brightness == Brightness.light
          ? Colors.transparent
          : const Color(0xFF424242),
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.55,
      panel: Column(
        children: [

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF424242),
              ),
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.4,
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
                        decoration: BoxDecoration(
                          color: brightness == Brightness.light
                              ? Colors.white
                              : null,
                          borderRadius: const BorderRadius.all(
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
                                style: TextStyle(
                                    color: brightness == Brightness.light
                                        ? Colors.black
                                        : null,
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
                  const Divider(),
                  Padding(
                          padding: const EdgeInsets.only(
                              left: 80.0, right: 80, bottom: 4),
                          child: Image.asset(
                            "assets/images/wizmirnetson.png",
                            width: MediaQuery.of(context).size.width * 0.4,
                          )
                          // SvgPicture.asset(
                          //   "assets/images/wizmirnet_icon2.svg",
                          //   fit: BoxFit.contain,
                          //   width: MediaQuery.of(context).size.width * 0.5,
                          // ),
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
                    selectorTextStyle: TextStyle(
                        color: brightness == Brightness.light
                            ? Colors.black
                            : null),
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
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        labelText: 'password'.tr(),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.pc.close();
                      widget.callbackislogin(phonenumber!, passcnt.text);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text("login".tr()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                              fullscreenDialog: true),
                        ),
                        child: Text(
                          "forgotpassword".tr(),
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      OpenContainer(
                        // openColor: brightness == Brightness.light ? Colors.white:Colors.black,
                        closedColor: brightness == Brightness.light ? Colors.white:const Color(0xFF424242),
                        transitionType: _transitionType,
                        openBuilder: (BuildContext context, VoidCallback _) {
                          return const RegisterPage(
                            includeMarkAsDoneButton: false,
                          );
                        },
                        closedElevation: 0.0,
                        closedBuilder:
                            (BuildContext context, VoidCallback openContainer) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("register".tr()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
