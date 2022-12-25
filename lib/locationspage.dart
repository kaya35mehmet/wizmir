import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wizmir/addDescription.dart';
import 'package:wizmir/models/locations.dart';

class Loc extends StatefulWidget {
  const Loc({Key? key}) : super(key: key);

  @override
  State<Loc> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Loc> {
  late Future<List<Locations>> locations;
  List<Locations> locationlist = [];
  int active = 0;
  int passive = 0;
  int all = 0;
  @override
  void initState() {
    locations = getdata();
    super.initState();
  }

  Future<List<Locations>> getdata() async {
    locationlist = await getdetail();
    await Future<dynamic>.delayed(const Duration(milliseconds: 3000));

    setState(() {
      active = locationlist.where((element) => element.aktifmi).length;
      passive = locationlist.where((element) => !element.aktifmi).length;
      all = locationlist.length;
    });

    return locationlist;
  }

  Map<T, List<Locations>> groupBy<S, T>(
      List<Locations> values, T Function(Locations) key) {
    var map = <T, List<Locations>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  _callback(oldlocation, newlocation) {
    setState(() {
      int index = locationlist.indexOf(oldlocation);
      locationlist.remove(oldlocation);
      locationlist.insert(index, newlocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: brightness == Brightness.light ? Colors.black : null,
          ),
          centerTitle: true,
          title: Text(
            "locations".tr(),
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
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Text(
                  "${'all'.tr()} ($all)",
                  style: TextStyle(
                      color:
                          brightness == Brightness.light ? Colors.black : null),
                ),
              ),
              Tab(
                icon: Text(
                  "${'active'.tr()} ($active)",
                  style: TextStyle(
                      color:
                          brightness == Brightness.light ? Colors.black : null),
                ),
              ),
              Tab(
                icon: Text(
                  "${'passive'.tr()} ($passive)",
                  style: TextStyle(
                      color:
                          brightness == Brightness.light ? Colors.black : null),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black12,
          child: FutureBuilder(
            future: locations,
            builder: (BuildContext context,
                AsyncSnapshot<List<Locations>> snapshot) {
              if (locationlist.isNotEmpty) {
                // var aktif =
                //     locationlist.where((element) => element.aktifmi).toList();
                // var pasif =
                //     locationlist.where((element) => !element.aktifmi).toList();

                var all = groupBy(
                    locationlist.toList(),
                    (Locations obj) => obj.lokasyon);
                var aktif = groupBy(
                    locationlist.where((element) => element.aktifmi).toList(),
                    (Locations obj) => obj.lokasyon);
                var pasif = groupBy(
                    locationlist.where((element) => !element.aktifmi).toList(),
                    (Locations obj) => obj.lokasyon);
                return TabBarView(
                  children: <Widget>[
                     ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: all.length,
                      itemBuilder: (BuildContext context, int index) {
                        var ss = all.values.elementAt(index);
                        return ExpansionTile(
                          textColor:brightness == Brightness.light ? Colors.black : null,
                          collapsedTextColor: brightness == Brightness.light ? Colors.black : null,
                          collapsedBackgroundColor:brightness == Brightness.light ? Colors.white: null,
                          title: Text("${all.keys.elementAt(index)} (${ss.length})"),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: ss.length,
                                itemBuilder:
                                    (BuildContext context, int index2) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(ss[index2].antenAdi),
                                      trailing: ss[index2].aciklama != null
                                          ? const Icon(Icons.bookmark)
                                          : null,
                                    ),
                                  );
                                }),
                          ],
                        );
                      },
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: aktif.length,
                      itemBuilder: (BuildContext context, int index) {
                        var ss = aktif.values.elementAt(index);
                        return ExpansionTile(
                          textColor:brightness == Brightness.light ? Colors.black : null,
                          collapsedTextColor: brightness == Brightness.light ? Colors.black : null,
                          collapsedBackgroundColor:brightness == Brightness.light ? Colors.white: null,
                           title: Text("${all.keys.elementAt(index)} (${ss.length})"),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: ss.length,
                                itemBuilder:
                                    (BuildContext context, int index2) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(ss[index2].antenAdi),
                                      trailing: ss[index2].aciklama != null
                                          ? const Icon(Icons.bookmark)
                                          : null,
                                    ),
                                  );
                                }),
                          ],
                        );
                      },
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pasif.length,
                      itemBuilder: (BuildContext context, int index) {
                        var ss = pasif.values.elementAt(index);
                        return ExpansionTile(
                          textColor:brightness == Brightness.light ? Colors.black : null,
                          collapsedTextColor: brightness == Brightness.light ? Colors.black : null,
                          collapsedBackgroundColor:brightness == Brightness.light ? Colors.white: null,
                                   title: Text("${all.keys.elementAt(index)} (${ss.length})"),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: ss.length,
                                itemBuilder:
                                    (BuildContext context, int index2) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(ss[index2].antenAdi),
                                      trailing: ss[index2].aciklama != null
                                          ? const Icon(Icons.bookmark)
                                          : null,
                                    ),
                                  );
                                }),
                          ],
                        );
                      },
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
