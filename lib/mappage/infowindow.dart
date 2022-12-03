import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/models/locations.dart';
import 'package:wizmir/report.dart';
import 'package:wizmir/functions.dart' as functions;

class InfoWindowScreen extends StatelessWidget {
  final Locations location;
  final bool islogin;
  final bool isadmin;
  const InfoWindowScreen(
      {Key? key,
      required this.location,
      required this.islogin,
      required this.isadmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black12),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      location.antenAdi.replaceAll("_", " "),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    isadmin
                        ? SizedBox(
                            // height: 20,
                            child: Text(
                                "${"onlineusercount".tr()} ${location.kullanicisayisi}"),
                          )
                        : const Center(),
                    const SizedBox(
                        // height: 10,
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportView(
                                  islogin: islogin,
                                  locations: location,
                                ),
                              ),
                            );
                          },
                          child: Text("reportaproblem".tr()),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            functions.showmodalmaps(
                                location.lat,
                                location.lng,
                                location.antenAdi.replaceAll("_", " "),
                                context);
                          },
                          child: Text("direction".tr()),
                        ),
                      ],
                    ),
                    isadmin
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => calismakaydet(location.id).whenComplete(() => Toast.show("succesful".tr(),
                  duration: Toast.lengthShort, gravity: Toast.bottom)),
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              child: Text("start".tr()),
                            ),
                          )
                        : const Center()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
