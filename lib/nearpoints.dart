// import 'package:animations/animations.dart';
import 'package:animated_button/animated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wizmir/functions.dart';
import 'package:wizmir/models/nearcluster.dart';
import 'package:wizmir/functions.dart' as functions;

class NearPointsPage extends StatefulWidget {
  const NearPointsPage({
    Key? key,
    required this.list,
    required this.callback,
    required this.callbackopen,
    required this.callbackgotolocation,
  }) : super(key: key);
  final List<NearLocations> list;
  final Function callback;
  final Function callbackopen;
  final Function callbackgotolocation;
  @override
  State<NearPointsPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NearPointsPage> {
  // final ContainerTransitionType _transitionType = ContainerTransitionType.fadeThrough;
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  final PanelController _pc = PanelController();
  String? phonenumber;
  Widget arrow = const Icon(Icons.arrow_upward,color: Colors.white,);

  TextEditingController controller = TextEditingController();
  TextEditingController usercnt = TextEditingController();
  TextEditingController passcnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    return SlidingUpPanel(
      onPanelOpened: () {
        setState(() {
          arrow =  Icon(
            Icons.arrow_downward,color: brightness == Brightness.light ? Colors.white : null,
          );
        });
        widget.callbackopen(false);
      },
      onPanelClosed: () {
        setState(() {
          arrow =  Icon(
            Icons.arrow_upward,color: brightness == Brightness.light ? Colors.white : null,
          );
        });
        widget.callback(true);
      },
      boxShadow: const [
        CustomBoxShadow(
            color: Colors.transparent,
            offset: Offset(10.0, 10.0),
            blurRadius: 0.0,
            blurStyle: BlurStyle.outer)
      ],
      controller: _pc,
      backdropColor: Colors.transparent,
      color: Colors.transparent,
      minHeight: 70,
      panel: Column(
        children: [
          AnimatedButton(
            color: Colors.blue,
            onPressed: () {
              if (_pc.isPanelOpen) {
                _pc.close();
              } else {
                _pc.open();
              }
            },
            enabled: true,
            shadowDegree: ShadowDegree.light,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "closestpoints".tr(),
                    style:  TextStyle(
                        color: brightness == Brightness.light ? Colors.white : null,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'),
                  ),
                  arrow,
                ],
              ),
            ),
          ),
          // Container(
          //   color: Colors.transparent,
          //   width: MediaQuery.of(context).size.width,
          //   child: Stack(
          //     children: [
          //       Center(
          //         child: GestureDetector(
          //           onTap: () {
          //             if (_pc.isPanelOpen) {
          //               _pc.close();
          //             } else {
          //               _pc.open();
          //             }
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width * 0.5,
          //             decoration: BoxDecoration(
          //               border: Border.all(
          //                 color: Colors.black,
          //                 width: 1,
          //               ),
          //               color: Colors.white,
          //               borderRadius: const BorderRadius.all(
          //                 Radius.circular(10),
          //               ),
          //             ),
          //             padding: const EdgeInsets.all(10.0),
          //             child: Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     "closestpoints".tr(),
          //                     style: const TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 16,
          //                         fontWeight: FontWeight.bold,
          //                         fontFamily: 'Roboto'),
          //                   ),
          //                   arrow,
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Container(
              decoration:  BoxDecoration(color: brightness == Brightness.light ? Colors.white : null),
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.4,
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        verticalOffset: -250,
                        child: ScaleAnimation(
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            // height: _w / 4,
                            decoration: BoxDecoration(
                              color: brightness == Brightness.light ? Colors.white : Color(0xFF424242),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                widget.callbackgotolocation(
                                    widget.list[index].locations);
                                _pc.close();
                              },
                              child: ListTile(
                                title:
                                    Text(widget.list[index].locations.antenAdi,),
                                trailing: IconButton(
                                  onPressed: (() {
                                    functions.showmodalmaps(
                                        widget.list[index].locations.lat,
                                        widget.list[index].locations.lng,
                                        widget.list[index].locations.antenAdi
                                            .replaceAll("_", " "),
                                        context);
                                  }),
                                  icon: const Icon(Icons.directions),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              //  ListView.builder(
              //   itemCount: widget.list.length,
              //   itemBuilder: ((context, index) {
              //   return GestureDetector(
              //    onTap: () {
              //     widget.callbackgotolocation(widget.list[index].locations);
              //     _pc.close();
              //    },
              //     child: Card(
              //         child: ListTile(
              //           title:  Text(widget.list[index].locations.antenAdi),
              //           trailing: IconButton(onPressed: (() {
              //                functions.showmodalmaps(widget.list[index].locations.lat, widget.list[index].locations.lng,
              //                             widget.list[index].locations.antenAdi.replaceAll("_", " "), context);
              //           }), icon:  const Icon(Icons.directions),),
              //         ),
              //       ),
              //   );
              // })),
            ),
          ),
        ],
      ),
    );
  }
}
