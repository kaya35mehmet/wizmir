import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:wizmir/models/notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  var brightness = SchedulerBinding.instance.window.platformBrightness;
  late Future<List<Notifications>> notifications;
  List<Notifications> notificationlist = [];

  @override
  void initState() {
    notifications = getdata();
    super.initState();
  }

  Future<List<Notifications>> getdata() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
    notificationlist = await getnotifications();

    return notificationlist;
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool mobilelayout = 600 < shortestSide;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: brightness == Brightness.light ? Colors.black : null,
        ),
        centerTitle: true,
        title: Text(
          "notifications".tr(),
          style: TextStyle(
              color: brightness == Brightness.light ? Colors.black : null),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: brightness == Brightness.light ? Colors.white : null,
      ),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(
      //     color: brightness == Brightness.light ? Colors.black : null,
      //   ),
      //   centerTitle: true,
      //   flexibleSpace: Padding(
      //     padding: EdgeInsets.only(
      //         left: mobilelayout ? 240 : 70.0, right: mobilelayout ? 240 : 70),
      //     child: SafeArea(
      //       child: Image.asset(
      //         brightness == Brightness.light
      //             ? "assets/images/1.png"
      //             : "assets/images/2.png",
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   ),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   elevation: 0,
      //   backgroundColor: brightness == Brightness.light ? Colors.white : null,
      // ),
      body: FutureBuilder<List<Notifications>>(
          future: notifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: notificationlist.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                            notificationlist[index].baslik),
                        subtitle: Text(notificationlist[index].note),
                        trailing: Text(notificationlist[index].tarih),
                      ),
                    );
                  });
            } else {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            "nonotification".tr(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )),
                      ],
                    )
                  ]);
            }
            } else {
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:  [LogoandSpinner(
                  imageAssets:brightness == Brightness.light ? 'assets/images/saatkulesi.png' : 'assets/images/saatkulesi_dark1.png',
                  reverse: true,
                  arcColor: Colors.blue,
                  spinSpeed:const Duration(milliseconds: 500),
                )],
                );
            }
          }),
    );
  }
}
