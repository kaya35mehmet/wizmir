// import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wizmir/functions.dart';
import 'package:wizmir/models/nearcluster.dart';
import 'package:wizmir/functions.dart' as functions;

class NearPointsPage extends StatefulWidget {
  const NearPointsPage({
    Key? key, required this.list, required this.callback, required this.callbackopen, required this.callbackgotolocation,
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
  Widget arrow = const Icon(Icons.arrow_upward);

  TextEditingController controller = TextEditingController();
  TextEditingController usercnt = TextEditingController();
  TextEditingController passcnt = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      onPanelOpened: () {
        setState(() {
          arrow = const Icon(
            Icons.arrow_downward,
          );
        });
        widget.callbackopen(false);
      },
      onPanelClosed: () {
        setState(() {
          arrow = const Icon(
            Icons.arrow_upward,
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
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_pc.isPanelOpen) {
                        _pc.close();
                      } else {
                        _pc.open();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        color: Colors.white,
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
                              "closestpoints".tr(),
                              style:const TextStyle(
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
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: ((context, index) {
                return GestureDetector(
                 onTap: () {
                  widget.callbackgotolocation(widget.list[index].locations);
                  _pc.close();
                 },
                  child: Card(
                      child: ListTile(
                        title:  Text(widget.list[index].locations.antenAdi),
                        trailing: IconButton(onPressed: (() {
                             functions.showmodalmaps(widget.list[index].locations.lat, widget.list[index].locations.lng,
                                          widget.list[index].locations.antenAdi.replaceAll("_", " "), context);
                        }), icon:  const Icon(Icons.directions),),
                      ),
                    ),
                );
              })),
            ),
          ),
        ],
      ),
    );
  }
}
