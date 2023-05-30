import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizmir/models/notifications.dart';

class NotificationScreen extends StatefulWidget {
  final List<Notifications>? list;
  const NotificationScreen({Key? key, this.list}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  late Future<List<Notifications>> notifications;
  List<Notifications> notificationlist = [];

  @override
  void initState() {
    setNotifi();
    super.initState();
  }

  setNotifi() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readlist = [];
    List<Notifications> itemlist = [];
    List<String>? deleteditems = prefs.getStringList("deleteditems");
    if (widget.list != null) {
      for (var element in widget.list!) {
        if (deleteditems != null) {
          if (!deleteditems.contains(element.id)) {
            itemlist.add(element);
          }
        } else {
          itemlist.add(element);
        }
        readlist.add(element.id);
      }
    }
    setState(() {
      notificationlist = itemlist;
    });
    prefs.setStringList("items", readlist);
  }

  deleteitem(id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? deleteditems = prefs.getStringList("deleteditems");
    if (deleteditems != null) {
      deleteditems.add(id);
    } else {
      deleteditems = [id];
    }
    prefs.setStringList("deleteditems", deleteditems);
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
        body: notificationlist.isNotEmpty
            ? ListView.builder(
                itemCount: notificationlist.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: ValueKey(notificationlist[index].id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          flex: 2,
                          onPressed: (value) {
                            deleteitem(notificationlist[index].id);
                            setState(() {
                              notificationlist.removeAt(index);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'delete'.tr(),
                        ),
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(notificationlist[index].baslik),
                        subtitle: Text(notificationlist[index].note),
                        trailing: Text(notificationlist[index].tarih),
                      ),
                    ),
                  );
                })
            : Column(
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
                  ]));
  }
}
