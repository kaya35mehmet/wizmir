import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:wizmir/models/userdetails.dart';
import 'indicator.dart';
import 'color_extensions.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int touchedIndex = -1;
  UserDetails? details;
  late Future<UserDetails> _list;

  @override
  void initState() {
    _list = getData();
    super.initState();
  }

  Future<UserDetails> getData() async {
    details = await getdetails();
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return details!;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: brightness == Brightness.light ? Colors.black : null,
        ),
        centerTitle: true,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50, bottom: 10),
          child: SafeArea(
            child: Image.asset(
              brightness == Brightness.light
                  ? "assets/images/ibblogo.png"
                  : "assets/images/ibblogolight.png",
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: FutureBuilder<UserDetails>(
              future: _list,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "${details?.toplamGiris}",
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "totalnumberoflogin".tr(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "${snapshot.data!.toplamSureSaat.toInt()} ${'hour'.tr()}",
                                               style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    Text(
                                      " ${snapshot.data!.toplamSureDakika.toInt()} ${'minute'.tr()}",
                                               style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "totalusagetime".tr(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1.3,
                        child: Card(
                          color: brightness == Brightness.light
                              ? Colors.white
                              : null,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 28,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Indicator(
                                    color: const Color(0xff0293ee),
                                    text: 'totaldownload'.tr(),
                                    isSquare: false,
                                    size: touchedIndex == 0 ? 18 : 16,
                                    textColor: touchedIndex == 0
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Indicator(
                                    color: const Color(0xfff8b250),
                                    text: 'totalupload'.tr(),
                                    isSquare: false,
                                    size: touchedIndex == 1 ? 18 : 16,
                                    textColor: touchedIndex == 1
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                        pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
                                                .touchedSection!
                                                .touchedSectionIndex;
                                          });
                                        }),
                                        startDegreeOffset: 180,
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 1,
                                        centerSpaceRadius: 0,
                                        sections: showingSections(
                                            snapshot.data!.toplamUpload,
                                            snapshot.data!.toplamDownload)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: brightness == Brightness.light
                              ? Colors.white
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "loginlocations".tr(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                snapshot.data!.girisLokasyonlari != null
                                    ? ListView.builder(
                                        itemCount: snapshot
                                            .data!.girisLokasyonlari!.length,
                                        shrinkWrap: true,
                                        itemBuilder: ((context, index) {
                                          int sayi = index + 1;
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "$sayi.${snapshot.data!.girisLokasyonlari![index].name}"),
                                          );
                                        }))
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Text("youarenotyetconnected".tr()),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [CircularProgressIndicator()],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(double upload, double download) {
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color(0xff0293ee);
        const color1 = Color(0xfff8b250);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: 25,
              title:
                  "${download.toString().substring(0, download.toString().indexOf("."))}${download.toString().substring(download.toString().indexOf("."), download.toString().indexOf(".") + 3)}GB",
              // title: download.toString().length > 7
              //     ? '${download.toString().substring(0, 7)}GB'
              //     : '${download}GB',
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color0.darken(40), width: 6)
                  : BorderSide(color: color0.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: 25,
              title:
                  "${upload.toString().substring(0, upload.toString().indexOf("."))}${upload.toString().substring(upload.toString().indexOf("."), upload.toString().indexOf(".") + 3)}GB",
              // title: upload.toString().length > 7
              //     ? '${upload.toString().substring(0, 7)}GB'
              //     : '${upload}GB',
              radius: 65,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color1.darken(40), width: 6)
                  : BorderSide(color: color1.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }
}
