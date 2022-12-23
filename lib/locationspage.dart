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
          iconTheme:  IconThemeData(
            color: brightness == Brightness.light ?  Colors.black : null,
          ),
          centerTitle: true,
          title:  Text(
            "locations".tr(),
            style: TextStyle(color:brightness == Brightness.light ?  Colors.black : null),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: brightness == Brightness.light ?  Colors.white : null,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Text(
                  "${'all'.tr()} ($all)",
                  style:  TextStyle(color: brightness == Brightness.light ?  Colors.black : null),
                ),
              ),
              Tab(
                icon: Text(
                  "${'active'.tr()} ($active)",
                  style:  TextStyle(color: brightness == Brightness.light ?  Colors.black : null),
                ),
              ),
              Tab(
                icon: Text(
                  "${'passive'.tr()} ($passive)",
                  style:  TextStyle(color:brightness == Brightness.light ?  Colors.black : null),
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
                var aktif =
                    locationlist.where((element) => element.aktifmi).toList();
                var pasif =
                    locationlist.where((element) => !element.aktifmi).toList();
                return TabBarView(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: locationlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(locationlist[index].antenAdi),
                            trailing: locationlist[index].aciklama != null ? const Icon(Icons.bookmark):null,
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: aktif.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(aktif[index].antenAdi),
                            trailing: aktif[index].aciklama != null ? const Icon(Icons.bookmark):null,

                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: pasif.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(pasif[index].antenAdi),
                            trailing: Wrap(
                              children: [
                                pasif[index].aciklama != null ? IconButton(
                                  onPressed: () {
                                  
                                  },
                                  icon: const Icon(Icons.bookmark),
                                ): const SizedBox(),

                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddDescriptionPage(
                                          location: pasif[index],
                                          callback: _callback,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.description),
                                ),
                              ],
                            ),
                          ),
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
