import 'package:animated_button/animated_button.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/dd.dart';
import 'package:wizmir/models/locations.dart';
import 'package:wizmir/report.dart';
import 'package:wizmir/functions.dart' as functions;

class InfoWindowScreen extends StatelessWidget {
  final Locations location;
  final bool islogin;
  final bool isadmin;
  final Function callback;
  final Function closecallback;
  final CustomInfoWindowController controller;
  const InfoWindowScreen(
      {Key? key,
      required this.location,
      required this.islogin,
      required this.isadmin,
      required this.callback, required this.controller, required this.closecallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
         color: brightness == Brightness.light ?  Colors.white : const Color(0xFF424242),
          border: Border.all(width: 1, color: Colors.black12),
          borderRadius: BorderRadius.circular(4)),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment:location.baslatildi || !location.aktifmi ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              location.baslatildi || !location.aktifmi ?  Padding(
                padding: const EdgeInsets.only(left:8.0),
                child:  Text("incare".tr(), style:const TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16), ),
              ):const Text(""),
              IconButton(onPressed: (){
                closecallback();
                controller.hideInfoWindow!();
              }, icon: Icon(Icons.cancel_outlined, color: brightness == Brightness.light ?  Colors.black : null,)),
            ],
          ),
          
           Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(child: WifiPage()),
                    Text(
                      location.antenAdi.replaceAll("_", " "),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isadmin
                        ? SizedBox(
                            child: Text(
                              "${"onlineusercount".tr()} ${location.kullanicisayisi}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : const Center(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportView(
                                  isadmin: isadmin,
                                  islogin: islogin,
                                  locations: location,
                                ),
                              ),
                            );
                          },
                          duration: 70,
                          height: 50,
                          width: 50,
                          enabled: true,
                          shadowDegree: ShadowDegree.light,
                          color: Colors.white54,
                          child: const Icon(
                            Icons.warning,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AnimatedButton(
                            onPressed: () {
                              functions.showmodalmaps(
                                  location.lat,
                                  location.lng,
                                  location.antenAdi.replaceAll("_", " "),
                                  context);
                            },
                            duration: 70,
                            height: 50,
                            width: 50,
                            enabled: true,
                            shadowDegree: ShadowDegree.light,
                            color: Colors.lightBlue,
                            child: const Icon(
                              Icons.directions,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isadmin
                        ? Center(
                            child: location.baslatildi
                                ? AnimatedButton(
                                    onPressed: () {
                                      calismabitir(location.id).then((val) {
                                        var nloc = Locations.copyWithwork(
                                            location, false);
                                        callback(nloc);
                                        Toast.show("succesful".tr(),
                                            duration: Toast.lengthShort,
                                            gravity: Toast.bottom);
                                      });
                                    },
                                    duration: 70,
                                    height: 50,
                                    enabled: true,
                                    shadowDegree: ShadowDegree.light,
                                    color: Colors.green,
                                    child: Text(
                                      "stop".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                : AnimatedButton(
                                    onPressed: () {
                                      calismakaydet(location.id).then((val) {
                                        var nloc = Locations.copyWithwork(
                                            location, true);
                                        callback(nloc);
                                        Toast.show("succesful".tr(),
                                            duration: Toast.lengthShort,
                                            gravity: Toast.bottom);
                                      });
                                    },
                                    duration: 70,
                                    height: 50,
                                    enabled: true,
                                    shadowDegree: ShadowDegree.light,
                                    color: Colors.orange,
                                    child: Text(
                                      "start".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                          )
                        : const Center()
                  ],
                ),
              ),
        ],
      ),
    );
  }
}