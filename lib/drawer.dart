import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toast/toast.dart';
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
  const NavigationDrawer(
      {Key? key,
      required this.islogin,
      required this.pc,
      required this.callback,
      required this.isadmin,
      required this.userview, 
      required this.callbackuserview,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 24,
                          bottom: 24),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SvgPicture.asset(
                          "assets/images/wizmirnet_icon2.svg",
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Wrap(runSpacing: 2, children: [
                    ListTile(
                      leading: Icon(
                          islogin ? Icons.logout_sharp : Icons.login_sharp),
                      title: Text(islogin ? "logout".tr() : "login".tr()),
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
                    islogin
                        ? ListTile(
                            leading: const Icon(Icons.graphic_eq_rounded),
                            title: Text("usagedetails".tr()),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UserPage()));
                            },
                          )
                        : const Center(),
                    islogin
                        ? ListTile(
                            leading: const Icon(Icons.password),
                            title: Text("changepassword".tr()),
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
                    ListTile(
                      leading: const Icon(Icons.videocam),
                      title:  Text("userguide".tr()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VideoPage()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.question_answer),
                      title:  Text("faq".tr()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FAQView()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.warning),
                      title:  Text("reportaproblem".tr()),
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
                    isadmin
                        ? ListTile(
                            leading: const Icon(Icons.speed),
                            title:  Text("speedtest".tr()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  SpeedTest(),
                                ),
                              );
                            },
                          )
                        : const Center(),
                    isadmin
                        ? ListTile(
                            leading: const Icon(Icons.location_on),
                            title:  Text("locations".tr()),
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
                   isadmin || userview ? ListTile(
                      leading: const Icon(Icons.person),
                      title:  Text( userview ? "adminview".tr() : "userview".tr()),
                      onTap: () {
                        callbackuserview(!userview);
                        Navigator.pop(context);
                      },
                    ):const Center(),
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                hoverColor: Colors.blue,
                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                title:  Text('${'version'.tr()} 1.0.0'),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
