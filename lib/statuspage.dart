import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:wizmir/models/status.dart';
import 'package:wizmir/models/userdetails.dart';
import 'indicator.dart';
import 'color_extensions.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  int touchedIndex = -1;
  late Status status;
  late Future<Status> _list;

  @override
  void initState() {
    _list = getData();
    super.initState();
  }

  Future<Status> getData() async {
    status = await getstatus();
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool mobilelayout = 600 < shortestSide;
    var brightness = SchedulerBinding.instance.window.platformBrightness;
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
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: brightness == Brightness.light ? Colors.white : null,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<Status>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return GridView.count(
                  primary: true,
                  padding: const EdgeInsets.all(0),
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 2,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 8, right: 8, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          HexColor("#FFB295").withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF00529c),
                                    Color.fromARGB(255, 83, 165, 237),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 16, right: 16, bottom: 8),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "TotalRegisteredUser".tr(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: 0.2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            status.toplamKayitliKullanici,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 0.2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: brightness == Brightness.light
                                  ? BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 8, right: 8, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          HexColor("#FFB295").withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF00529c),
                                    Color.fromARGB(255, 83, 165, 237),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 16, right: 16, bottom: 8),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "TotalOnlineUser".tr(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: 0.2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            status.toplamOnlineKullanici,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 0.2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: brightness == Brightness.light
                                  ? BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 8, right: 8, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          HexColor("#FFB295").withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFa43c39),
                                    Color(0xFFd1716e),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 16, right: 16, bottom: 8),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "TotalNumberofEntries".tr(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: 0.2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            status.toplamGirisSayisi,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 0.2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: brightness == Brightness.light
                                  ? BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 8, right: 8, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          HexColor("#FFB295").withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFa43c39),
                                    Color(0xFFd1716e),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 16, right: 16, bottom: 8),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "NumberofLocations".tr(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: 0.2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            status.lokasyonSayisi,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 0.2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: brightness == Brightness.light
                                  ? BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 8, right: 8, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          HexColor("#FFB295").withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF168f5c),
                                    Color(0xFF439f78),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 16, right: 16, bottom: 8),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "TotalDownload".tr(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: 0.2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            status.toplamDownload,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 0.2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: brightness == Brightness.light
                                  ? BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 8, right: 8, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          HexColor("#FFB295").withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF168f5c),
                                    Color(0xFF439f78),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 16, right: 16, bottom: 8),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "TotalUpload".tr(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: 0.2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            status.toplamUpload,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 0.2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: brightness == Brightness.light
                                  ? BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LogoandSpinner(
                        imageAssets: brightness == Brightness.light
                            ? 'assets/images/saatkulesi.png'
                            : 'assets/images/saatkulesi_dark1.png',
                        reverse: true,
                        arcColor: Colors.blue,
                        spinSpeed: const Duration(milliseconds: 500),
                      )
                    ],
                  ),
                );
              }
            }),
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

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
