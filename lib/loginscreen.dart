// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:toast/toast.dart';
// import 'package:wizmir/forgotpassword.dart';
// import 'package:wizmir/models/login.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen(
//       {Key? key, required this.callbackislogin})
//       : super(key: key);
//   final Function callbackislogin;
//   @override
//   State<LoginScreen> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<LoginScreen> {
//   String initialCountry = 'TR';
//   PhoneNumber number = PhoneNumber(isoCode: 'TR');
//   final PanelController _pc = PanelController();
//   String? phonenumber;
//   Widget arrow = const Icon(Icons.arrow_upward);
//   bool? islogin;
//   bool? floatingActionButtonvisible;
//   TextEditingController controller = TextEditingController();
//   TextEditingController usercnt = TextEditingController();
//   TextEditingController passcnt = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
//       height: MediaQuery.of(context).size.height * 0.4,
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 40,
//           ),
//           InternationalPhoneNumberInput(
//             searchBoxDecoration: const InputDecoration(
//                 labelText: "Ülke adına veya arama koduna göre arama yapın"),
//             onInputChanged: (PhoneNumber number) {
//               setState(() {
//                 phonenumber = number.phoneNumber;
//               });
//             },
//             onInputValidated: (bool value) {},
//             selectorConfig: const SelectorConfig(
//               selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//             ),
//             ignoreBlank: false,
//             hintText: "Telefon numarası",
//             errorMessage: "Hatalı numara!",
//             autoValidateMode: AutovalidateMode.disabled,
//             selectorTextStyle: const TextStyle(color: Colors.black),
//             initialValue: number,
//             textFieldController: controller,
//             formatInput: false,
//             keyboardType: const TextInputType.numberWithOptions(
//                 signed: true, decimal: true),
//             inputBorder: const OutlineInputBorder(),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextField(
//             controller: passcnt,
//             keyboardType: TextInputType.text,
//             obscureText: true,
//             decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.all(8),
//                 labelText: 'Şifre',
//                 border: OutlineInputBorder()),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               login(phonenumber!, passcnt.text).then((value) {
//                 if (value == "0") {
//                   Toast.show("Yanlış kullanıcı adı yada şifre!",
//                       duration: Toast.lengthShort, gravity: Toast.bottom);
//                 } else {
//                   _pc.close();
//                   Toast.show("Giriş başarılı!",
//                       duration: Toast.lengthShort, gravity: Toast.bottom);
//                   widget.callbackislogin(true);
//                   setState(() {
//                     islogin = true;
//                     passcnt.text = "";
//                   });
//                 }
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size.fromHeight(50),
//               // primary: const Color(0xFFf04136),
//             ),
//             child: const Text("Giriş yap"),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ForgotPasswordPage(),
//                       fullscreenDialog: true),
//                 ),
//                 child: const Text(
//                   "Şifremi unuttum",
//                   style: TextStyle(
//                       color: Colors.grey, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
