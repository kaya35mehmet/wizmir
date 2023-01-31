import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wizmir/models/notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var brightness = SchedulerBinding.instance.window.platformBrightness;

  Future<List<Notifications>> getdata() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
    var list = getnotificantions();
    return list;
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
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
              left: mobilelayout ? 240 : 70.0, right: mobilelayout ? 240 : 70),
          child: SafeArea(
            child: Image.asset(
              brightness == Brightness.light
                  ? "assets/images/1.png"
                  : "assets/images/2.png",
              fit: BoxFit.cover,
            ),
          ),
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
      body: FutureBuilder<List<Notifications>>(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Text(
                          "${snapshot.data![index].note} ${snapshot.data![index].tarih}"),
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
          }),
    );
  }
}
