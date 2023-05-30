// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:toast/toast.dart';
// import 'package:wizmir/models/user.dart';

// class ProfileComplete extends StatefulWidget {
//   const ProfileComplete(
//       {Key? key, this.includeMarkAsDoneButton = true, required this.username})
//       : super(key: key);

//   final bool includeMarkAsDoneButton;
//   final String username;

//   @override
//   State<ProfileComplete> createState() => _ProfileCompleteState();
// }

// class _ProfileCompleteState extends State<ProfileComplete> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SlideAnimationWidget(
//           username: widget.username,
//         ),
//       ),
//     );
//   }
// }

// class SlideAnimationWidget extends StatefulWidget {
//   final String username;
//   const SlideAnimationWidget({Key? key, required this.username})
//       : super(key: key);

//   @override
//   State<SlideAnimationWidget> createState() => _SlideAnimationWidgetState();
// }

// enum Gender { erkek, kadin }

// List<String> list = List<String>.generate(
//     80, (int index) => (DateTime.now().year - index).toString(),
//     growable: true);

// class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
//   final RoundedLoadingButtonController _btnController =
//       RoundedLoadingButtonController();

//   Gender? _character = Gender.kadin;
//   String cinsiyet = "female".tr();
//   String age = "";

//   @override
//   void initState() {
//     list.insert(0, "choose".tr());
//     setState(() {
//       age = list.first;
//     });
//     super.initState();
//   }

//   void _doSomething() async {
//     if (age != "Choose" && age != "Seçiniz") {
//       profilecomplete(widget.username, cinsiyet, age).then((value) {
//          Toast.show("succesful".tr(),
//             duration: Toast.lengthShort, gravity: Toast.bottom);
//         Navigator.pop(context);
//       });
//     }
//     _btnController.reset();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return WillPopScope(
//       onWillPop: () async {
//         Toast.show("pleasecompleteporfile".tr(),
//             duration: Toast.lengthShort, gravity: Toast.bottom);
//         return false;
//       },
//       child: SingleChildScrollView(
//         child: AnimationLimiter(
//             child: AnimationConfiguration.staggeredList(
//           position: 2,
//           delay: const Duration(milliseconds: 100),
//           child: SlideAnimation(
//             duration: const Duration(milliseconds: 2500),
//             curve: Curves.fastLinearToSlowEaseIn,
//             horizontalOffset: 30,
//             verticalOffset: 900.0,
//             child: FlipAnimation(
//               duration: const Duration(milliseconds: 3000),
//               curve: Curves.fastLinearToSlowEaseIn,
//               flipAxis: FlipAxis.y,
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 80,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     margin: EdgeInsets.only(bottom: w / 20),
//                     // height: _w,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(20),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 40,
//                           spreadRadius: 10,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Image.asset("assets/images/wizmirnetson.png",width: MediaQuery.of(context).size.width * 0.5,),
//                         // SvgPicture.asset(
//                         //   "assets/images/wizmirnet_icon2.svg",
//                         //   width: MediaQuery.of(context).size.width * 0.5,
//                         // ),
//                         const SizedBox(
//                           height: 40,
//                         ),
//                         Text(
//                           "pleasecompleteporfile".tr().toUpperCase(),
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               letterSpacing: 0.0),
//                         ),
//                         const SizedBox(
//                           height: 40,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Text(
//                               "age".tr(),
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16),
//                             ),
//                             const SizedBox(
//                               width: 4,
//                             ),
//                             DropdownButton<String>(
//                               value: age,
//                               elevation: 0,
//                               style: const TextStyle(color: Colors.black),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   age = value!.toString();
//                                 });
//                               },
//                               items: list.map<DropdownMenuItem<String>>(
//                                   (String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value.toString(),
//                                   child: Text(value.toString(),
//                                       style: const TextStyle(fontSize: 16)),
//                                 );
//                               }).toList(),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: ListTile(
//                                 title: Text('female'.tr()),
//                                 leading: Radio<Gender>(
//                                   value: Gender.kadin,
//                                   groupValue: _character,
//                                   onChanged: (Gender? value) {
//                                     setState(() {
//                                       _character = value;
//                                       cinsiyet = "female".tr();
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 1,
//                               child: ListTile(
//                                 title: Text('male'.tr()),
//                                 leading: Radio<Gender>(
//                                   value: Gender.erkek,
//                                   groupValue: _character,
//                                   onChanged: (Gender? value) {
//                                     setState(() {
//                                       _character = value;
//                                       cinsiyet = "male".tr();
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         RoundedLoadingButton(
//                           controller: _btnController,
//                           onPressed: _doSomething,
//                           child: Text('save'.tr(),
//                               style: const TextStyle(color: Colors.white)),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )),
//       ),
//     );
//   }
// }
