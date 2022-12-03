// import 'package:flutter/material.dart';

// class MyCustomTransitions extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, ScaleTransition1(SecondPage())),
//               child: Text('TAP TO VIEW SCALE ANIMATION 1')),
//           ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, ScaleTransition2(SecondPage())),
//               child: Text('TAP TO VIEW SCALE ANIMATION 2')),
//           ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, ScaleTransition3(SecondPage())),
//               child: Text('TAP TO VIEW SCALE ANIMATION 3')),
//           ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, ScaleTransition4(SecondPage())),
//               child: Text('TAP TO VIEW SCALE ANIMATION 4')),
//           ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, ScaleTransition5(SecondPage())),
//               child: Text('TAP TO VIEW SCALE ANIMATION 5')),
//           ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, ScaleTransition6(SecondPage())),
//               child: Text('TAP TO VIEW SCALE ANIMATION 6')),
//           ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, ScaleTransition7(SecondPage())),
//               child: Text('TAP TO VIEW SCALE ANIMATION 7')),
//         ],
//       ),
//     );
//   }
// }


// class ScaleTransition1 extends PageRouteBuilder {
//   final Widget page;

//   ScaleTransition1(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 1000),
//     reverseTransitionDuration: Duration(milliseconds: 200),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//           curve: Curves.fastLinearToSlowEaseIn,
//           parent: animation,
//           reverseCurve: Curves.fastOutSlowIn);
//       return ScaleTransition(
//         alignment: Alignment.bottomCenter,
//         scale: animation,
//         child: child,
//       );
//     },
//   );
// }

// class ScaleTransition2 extends PageRouteBuilder {
//   final Widget page;

//   ScaleTransition2(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 1000),
//     reverseTransitionDuration: Duration(milliseconds: 200),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//           curve: Curves.fastLinearToSlowEaseIn,
//           parent: animation,
//           reverseCurve: Curves.fastOutSlowIn);
//       return ScaleTransition(
//         alignment: Alignment.topCenter,
//         scale: animation,
//         child: child,
//       );
//     },
//   );
// }

// class ScaleTransition3 extends PageRouteBuilder {
//   final Widget page;

//   ScaleTransition3(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 1000),
//     reverseTransitionDuration: Duration(milliseconds: 200),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//           curve: Curves.fastLinearToSlowEaseIn,
//           parent: animation,
//           reverseCurve: Curves.fastOutSlowIn);
//       return ScaleTransition(
//         alignment: Alignment.bottomLeft,
//         scale: animation,
//         child: child,
//       );
//     },
//   );
// }

// class ScaleTransition4 extends PageRouteBuilder {
//   final Widget page;

//   ScaleTransition4(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 1000),
//     reverseTransitionDuration: Duration(milliseconds: 200),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//           curve: Curves.fastLinearToSlowEaseIn,
//           parent: animation,
//           reverseCurve: Curves.fastOutSlowIn);
//       return ScaleTransition(
//         alignment: Alignment.bottomRight,
//         scale: animation,
//         child: child,
//       );
//     },
//   );
// }

// class ScaleTransition5 extends PageRouteBuilder {
//   final Widget page;

//   ScaleTransition5(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 1000),
//     reverseTransitionDuration: Duration(milliseconds: 200),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//           curve: Curves.fastLinearToSlowEaseIn,
//           parent: animation,
//           reverseCurve: Curves.fastOutSlowIn);
//       return ScaleTransition(
//         alignment: Alignment.center,
//         scale: animation,
//         child: child,
//       );
//     },
//   );
// }

// class ScaleTransition6 extends PageRouteBuilder {
//   final Widget page;

//   ScaleTransition6(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 1000),
//     reverseTransitionDuration: Duration(milliseconds: 200),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//           curve: Curves.fastLinearToSlowEaseIn,
//           parent: animation,
//           reverseCurve: Curves.fastOutSlowIn);
//       return ScaleTransition(
//         alignment: Alignment.centerRight,
//         scale: animation,
//         child: child,
//       );
//     },
//   );
// }

// class ScaleTransition7 extends PageRouteBuilder {
//   final Widget page;

//   ScaleTransition7(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 1000),
//     reverseTransitionDuration: Duration(milliseconds: 200),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//           curve: Curves.fastLinearToSlowEaseIn,
//           parent: animation,
//           reverseCurve: Curves.fastOutSlowIn);
//       return ScaleTransition(
//         alignment: Alignment.centerLeft,
//         scale: animation,
//         child: child,
//       );
//     },
//   );
// }

// class SecondPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         brightness: Brightness.dark,
//         centerTitle: true,
//         title: Text('Scale Transition'),
//       ),
//     );
//   }
// }

//  // showSlideupModal(lat, lng) {
//   //   return SlidingUpPanel(
//   //     onPanelOpened: () {
//   //       setState(() {
//   //         arrow = const Icon(
//   //           Icons.arrow_downward,
//   //         );
//   //         floatingActionButtonvisible = false;
//   //       });
//   //     },
//   //     onPanelClosed: () {
//   //       setState(() {
//   //         arrow = const Icon(
//   //           Icons.arrow_upward,
//   //         );
//   //         floatingActionButtonvisible = true;
//   //       });
//   //     },
//   //     boxShadow: const [
//   //       CustomBoxShadow(
//   //           color: Colors.transparent,
//   //           offset: Offset(10.0, 10.0),
//   //           blurRadius: 0.0,
//   //           blurStyle: BlurStyle.outer)
//   //     ],
//   //     controller: _pc,
//   //     backdropColor: Colors.transparent,
//   //     color: Colors.transparent,
//   //     minHeight: islogin! ? 0 : 50,
//   //     maxHeight: MediaQuery.of(context).size.height * 0.45,
//   //     panel: Column(
//   //       children: [
//   //         Container(
//   //           color: Colors.transparent,
//   //           width: MediaQuery.of(context).size.width,
            
//   //           child: Stack(
//   //             children: [
                
//   //               !islogin!
//   //                   ? Center(
//   //                       child: GestureDetector(
//   //                         onTap: () {
//   //                           if (_pc.isPanelOpen) {
//   //                             setState(() {
//   //                               floatingActionButtonvisible = true;
//   //                             });
//   //                             _pc.close();
//   //                           } else {
//   //                             setState(() {
//   //                               floatingActionButtonvisible = false;
//   //                             });
//   //                             _pc.open();
//   //                           }
//   //                         },
//   //                         child: Container(
//   //                           width: MediaQuery.of(context).size.width * 0.4,
//   //                           decoration: BoxDecoration(
//   //                             border: Border.all(
//   //                               color: Colors.black,
//   //                               width: 1,
//   //                             ),
//   //                             color: Colors.white,
//   //                             borderRadius: const BorderRadius.all(
//   //                               Radius.circular(10),
//   //                             ),
//   //                           ),
//   //                           padding: const EdgeInsets.all(10.0),
//   //                           child: Center(
//   //                             child: Row(
//   //                               mainAxisAlignment: MainAxisAlignment.center,
//   //                               children: [
//   //                                 const Text(
//   //                                   "Giriş yap",
//   //                                   style: TextStyle(
//   //                                       color: Colors.black,
//   //                                       fontSize: 16,
//   //                                       fontWeight: FontWeight.bold,
//   //                                       fontFamily: 'Roboto'),
//   //                                 ),
//   //                                 arrow,
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     )
//   //                   : Center(),
//   //             ],
//   //           ),
//   //         ),
//   //         Expanded(
//   //           child: Container(
//   //             decoration: BoxDecoration(
//   //                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
//   //             padding: const EdgeInsets.all(20),
//   //             margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
//   //             height: MediaQuery.of(context).size.height * 0.4,
//   //             child: Column(
//   //               children: [
//   //                 const SizedBox(
//   //                   height: 40,
//   //                 ),
//   //                 InternationalPhoneNumberInput(
//   //                   searchBoxDecoration: const InputDecoration(
//   //                       labelText:
//   //                           "Ülke adına veya arama koduna göre arama yapın"),
//   //                   onInputChanged: (PhoneNumber number) {
//   //                     setState(() {
//   //                       phonenumber = number.phoneNumber;
//   //                     });
//   //                   },
//   //                   onInputValidated: (bool value) {},
//   //                   selectorConfig: const SelectorConfig(
//   //                     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//   //                   ),
//   //                   ignoreBlank: false,
//   //                   hintText: "Telefon numarası",
//   //                   errorMessage: "Hatalı numara!",
//   //                   autoValidateMode: AutovalidateMode.disabled,
//   //                   selectorTextStyle: const TextStyle(color: Colors.black),
//   //                   initialValue: number,
//   //                   textFieldController: controller,
//   //                   formatInput: false,
//   //                   keyboardType: const TextInputType.numberWithOptions(
//   //                       signed: true, decimal: true),
//   //                   inputBorder: const OutlineInputBorder(),
//   //                 ),
//   //                 const SizedBox(
//   //                   height: 10,
//   //                 ),
//   //                 TextField(
//   //                   controller: passcnt,
//   //                   keyboardType: TextInputType.text,
//   //                   obscureText: true,
//   //                   decoration: const InputDecoration(
//   //                     contentPadding: EdgeInsets.only(bottom: 8),
//   //                     labelText: 'Şifre',
//   //                     border: OutlineInputBorder()
//   //                   ),
//   //                 ),
//   //                 const SizedBox(
//   //                   height: 20,
//   //                 ),
//   //                 ElevatedButton(
//   //                   onPressed: () {
//   //                     login(phonenumber!, passcnt.text).then((value) {
//   //                       if (value == "0") {
//   //                         Toast.show("Yanlış kullanıcı adı yada şifre!",
//   //                             duration: Toast.lengthShort,
//   //                             gravity: Toast.bottom);
//   //                       } else {
//   //                         _pc.close();
//   //                         Toast.show("Giriş başarılı!",
//   //                             duration: Toast.lengthShort,
//   //                             gravity: Toast.bottom);
//   //                         setState(() {
//   //                           islogin = true;

//   //                           passcnt.text = "";
//   //                         });
//   //                       }
//   //                     });
//   //                   },
//   //                   style: ElevatedButton.styleFrom(
//   //                     minimumSize: const Size.fromHeight(50),
//   //                     primary: const Color(0xFFf04136)
//   //                   ),
//   //                   child: const Text("Giriş yap"),
//   //                 ),
//   //                 const SizedBox(
//   //                   height: 20,
//   //                 ),
//   //                 Row(
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   children: [
//   //                     GestureDetector(
//   //                       onTap: () {
                          
//   //                       },
//   //                       child: const Text(
//   //                         "Şifremi değiştir",
//   //                         style: TextStyle(
//   //                             color: Colors.grey, fontWeight: FontWeight.bold),
//   //                       ),
//   //                     ),
//   //                     GestureDetector(
//   //                       onTap: () => Navigator.push(
//   //                         context,
//   //                         MaterialPageRoute(
//   //                             builder: (context) => const ForgotPasswordPage(),
//   //                             fullscreenDialog: true),
//   //                       ),
//   //                       child: const Text(
//   //                         "Şifremi unuttum",
//   //                         style: TextStyle(
//   //                             color: Colors.grey, fontWeight: FontWeight.bold),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 )
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }


//   // void _startListeningToScannedResults() async {
//   //   final can =
//   //       await WiFiScan.instance.canGetScannedResults(askPermissions: true);
//   //   switch (can) {
//   //     case CanGetScannedResults.yes:
//   //       subscription =
//   //           WiFiScan.instance.onScannedResultsAvailable.listen((results) {
//   //         setState(() => accessPoints = results
//   //             // .where((element) => element.ssid.contains("Wizmir"))
//   //             .toList());
//   //         if (accessPoints.isNotEmpty) {
//   //           showModalBottomSheet<void>(
//   //             context: context,
//   //             builder: (BuildContext context) {
//   //               return SingleChildScrollView(
//   //                   child: Column(
//   //                 children: [
//   //                   Padding(
//   //                     padding: const EdgeInsets.all(18.0),
//   //                     child: Row(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         const Text(
//   //                           "Kullanılabilir WizmirNet noktaları",
//   //                           style: TextStyle(
//   //                               fontSize: 16, fontWeight: FontWeight.w500),
//   //                         ),
//   //                         IconButton(
//   //                             onPressed: () => Navigator.pop(context),
//   //                             icon: const Icon(Icons.close))
//   //                       ],
//   //                     ),
//   //                   ),
//   //                   ListView.builder(
//   //                       shrinkWrap: true,
//   //                       itemCount: accessPoints.length,
//   //                       itemBuilder: (context, index) {
//   //                         return ListTile(
//   //                             title: Text(accessPoints[index].ssid));
//   //                       }),
//   //                 ],
//   //               ));
//   //             },
//   //           );
//   //         }
//   //       });
//   //       break;
//   //     case CanGetScannedResults.notSupported:
//   //       break;
//   //     case CanGetScannedResults.noLocationPermissionRequired:
//   //       break;
//   //     case CanGetScannedResults.noLocationPermissionDenied:
//   //       break;
//   //     case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
//   //       break;
//   //     case CanGetScannedResults.noLocationServiceDisabled:
//   //       break;
//   //   }
//   // }


//   // floatingActionButton: Visibility(
//       //   visible: floatingActionButtonvisible,
//       //   child: FloatingActionButton(
//       //     // backgroundColor: const Color(0xFFf04136),
//       //     onPressed: () async {
//       //       setState(() {
//       //         icon = const CircularProgressIndicator();
//       //       });
//       //       final GoogleMapController controller = await _controller.future;
//       //       getData().then((value) {
//       //         CameraPosition nepPos = CameraPosition(
//       //           target: LatLng(latLng!.latitude, latLng!.longitude),
//       //           zoom: 14,
//       //         );
//       //         controller.animateCamera(CameraUpdate.newCameraPosition(nepPos));
//       //         setState(() {
//       //           icon = const Icon(Icons.location_on);
//       //         });
//       //       });
//       //     },
//       //     child: const Icon(Icons.location_on),
//       //   ),
//       // ),

// showmodalmaps(lat, lng, name) async {
//      
//     var google = await maplauncher.MapLauncher.isMapAvailable(
//         maplauncher.MapType.google);
//     var apple =
//         await maplauncher.MapLauncher.isMapAvailable(maplauncher.MapType.apple);
//     var yandex = await maplauncher.MapLauncher.isMapAvailable(
//         maplauncher.MapType.yandexMaps);
//     var yandexnavi = await maplauncher.MapLauncher.isMapAvailable(
//         maplauncher.MapType.yandexNavi);
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const SizedBox(
//                 height: 30,
//               ),
//               const Text(
//                 "Uygulama seçin",
//                 style:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//               apple!
//                   ? ListTile(
//                       leading: SvgPicture.asset(
//                         "assets/mapappsicons/apple.svg",
//                         height: 30,
//                       ),
//                       title: const Text('Apple Haritalar'),
//                       onTap: () async {
//                         await maplauncher.MapLauncher.showMarker(
//                           mapType: maplauncher.MapType.apple,
//                           coords: maplauncher.Coords(lat,
//                               lng),
//                           title: name,
//                         );
//                       },
//                     )
//                   : const Center(),
//               const SizedBox(
//                 height: 4,
//               ),
//               google!
//                   ? ListTile(
//                       leading: SvgPicture.asset(
//                         "assets/mapappsicons/google.svg",
//                         height: 30,
//                       ),
//                       title: const Text('Google Haitalar'),
//                       onTap: () async {
//                           await maplauncher.MapLauncher.showMarker(
//                           mapType: maplauncher.MapType.apple,
//                           coords: maplauncher.Coords(lat,
//                               lng),
//                           title: name,
//                         );
//                       },
//                     )
//                   : const Center(),
//               const SizedBox(
//                 height: 4,
//               ),
//               yandex!
//                   ? ListTile(
//                       leading: SvgPicture.asset(
//                         "assets/mapappsicons/yandex.svg",
//                         height: 30,
//                       ),
//                       title: const Text('Yandex Haritalar'),
//                       onTap: () async {
//                           await maplauncher.MapLauncher.showMarker(
//                           mapType: maplauncher.MapType.apple,
//                           coords: maplauncher.Coords(lat,
//                               lng),
//                           title: name,
//                         );
//                       },
//                     )
//                   : const Center(),
//               yandexnavi!
//                   ? ListTile(
//                       leading: SvgPicture.asset(
//                         "assets/mapappsicons/yandexnavi.svg",
//                         height: 30,
//                       ),
//                       title: const Text('Yandex Navi'),
//                       onTap: () async {
//                           await maplauncher.MapLauncher.showMarker(
//                           mapType: maplauncher.MapType.apple,
//                           coords: maplauncher.Coords(lat,
//                               lng),
//                           title: name,
//                         );
//                       },
//                     )
//                   : const Center(),
//               // const SizedBox(height: 20,),
//               // ListTile(
//               //   leading: SvgPicture.asset("assets/mapappsicons/herelogo.svg"),
//               //   title: const Text('Here Map'),
//               //   onTap: () {
//               //     Navigator.pop(context);
//               //   },
//               // ),
//               const SizedBox(
//                 height: 30,
//               )
//             ],
//           );
//         });
//   }