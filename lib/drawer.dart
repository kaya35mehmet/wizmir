import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wizmir/changepassword.dart';
import 'package:wizmir/faqview.dart';
import 'package:wizmir/locationspage.dart';
import 'package:wizmir/report.dart';
import 'package:wizmir/speedtest.dart';
import 'package:wizmir/userpage.dart';
import 'package:wizmir/video.dart';

class NavigationDrawer extends StatelessWidget {
  final bool islogin;
  final bool isadmin;
  final bool userview;
  final PanelController pc;
  final Function callback;
  final Function callbackuserview;
  const NavigationDrawer({
    Key? key,
    required this.islogin,
    required this.pc,
    required this.callback,
    required this.isadmin,
    required this.userview,
    required this.callbackuserview, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: brightness == Brightness.light ? Colors.black : null,
          gradient: brightness == Brightness.light
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xFF00529c),
                    Color.fromARGB(255, 83, 165, 237),
                  ],
                  tileMode: TileMode.mirror,
                )
              : null,
        ),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top, bottom: 4),
                      // color:brightness == Brightness.light ? Colors.white :Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.only(left:80.0, right: 80,bottom: 4),
                        child: Image.asset("assets/images/wizmirnetson.png",width: MediaQuery.of(context).size.width * 0.2,)
                        // SvgPicture.asset(
                        //   "assets/images/wizmirnet_icon2.svg",
                        //   fit: BoxFit.contain,
                        //   width: MediaQuery.of(context).size.width * 0.5,
                        // ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(
                        islogin ? Icons.logout_sharp : Icons.login_sharp,
                        color: Colors.white,
                      ),
                      title: Text(
                        islogin ? "logout".tr() : "login".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        if (islogin) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('areyousure'.tr()),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.grey),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('cancel'.tr())),
                                ElevatedButton(
                                    onPressed: () {
                                      var storage =
                                          const FlutterSecureStorage();
                                      storage.delete(key: "guid").then((value) {
                                        callback();
                                        storage.delete(key: "isadmin");
                                        Navigator.pop(context);
                                      });
                                      Toast.show("checkedout".tr(),
                                          duration: Toast.lengthShort,
                                          gravity: Toast.bottom);
                                    },
                                    child: Text('ok'.tr()))
                              ],
                            ),
                          );
                        } else {
                          pc.open();
                        }
                      },
                    ),
                    const Divider(
                      color: Colors.white30,
                    ),
                    islogin
                        ? ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            leading: const Icon(
                              Icons.graphic_eq_rounded,
                              color: Colors.white,
                            ),
                            title: Text(
                              "usagedetails".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UserPage()));
                            },
                          )
                        : const Center(),
                    islogin
                        ? const Divider(
                            color: Colors.white30,
                          )
                        : const Center(),
                    islogin
                        ? ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            leading: const Icon(
                              Icons.password,
                              color: Colors.white,
                            ),
                            title: Text(
                              "changepassword".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Scaffold.of(context).closeDrawer();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordPage(
                                    isadmin: isadmin,
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(),
                    islogin
                        ? const Divider(
                            color: Colors.white30,
                          )
                        : const Center(),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      leading: const Icon(
                        Icons.videocam,
                        color: Colors.white,
                      ),
                      title: Text(
                        "userguide".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VideoPage()));
                      },
                    ),
                    const Divider(
                      color: Colors.white30,
                    ),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      leading: const Icon(
                        Icons.question_answer,
                        color: Colors.white,
                      ),
                      title: Text(
                        "faq".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FAQView()));
                      },
                    ),
                    const Divider(
                      color: Colors.white30,
                    ),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      leading: const Icon(
                        Icons.warning,
                        color: Colors.white,
                      ),
                      title: Text(
                        "reportaproblem".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportView(
                              islogin: islogin,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.white30,
                    ),
                    isadmin
                        ? ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            leading: const Icon(
                              Icons.speed,
                              color: Colors.white,
                            ),
                            title: Text(
                              "speedtest".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  const SpeedTest(),
                                ),
                              );
                            },
                          )
                        : const Center(),
                    isadmin
                        ? const Divider(
                            color: Colors.white30,
                          )
                        : const Center(),
                    isadmin
                        ? ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            title: Text(
                              "locations".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Loc(),
                                ),
                              );
                            },
                          )
                        : const Center(),
                    isadmin
                        ? const Divider(
                            color: Colors.white30,
                          )
                        : const Center(),
                    isadmin || userview
                        ? ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            leading: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            title: Text(
                              userview ? "adminview".tr() : "userview".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              callbackuserview(!userview);
                              Navigator.pop(context);
                            },
                          )
                        : const Center(),
                    isadmin
                        ? const Divider(
                            color: Colors.white30,
                          )
                        : const Center(),
                  ]),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  hoverColor: Colors.blue,
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -4),
                  title: Text(
                    '${'version'.tr()} 1.0.0',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}