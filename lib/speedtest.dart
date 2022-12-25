// ignore_for_file: no_leading_underscores_for_local_identifiers, duplicate_ignore

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';
import 'package:gauges/gauges.dart';
import 'package:wizmir/models/speedtest.dart';

void main() => runApp(const SpeedTest());

class SpeedTest extends StatefulWidget {
  const SpeedTest({super.key});

  @override
  State<SpeedTest> createState() => _SpeedTestState();
}

class _SpeedTestState extends State<SpeedTest> {
  final _speedtest = FlutterSpeedtest(
    baseUrl: 'https://speedtest.gsmnet.id.prod.hosts.ooklaserver.net:8080',
    pathDownload: '/download',
    pathUpload: '/upload',
    pathResponseTime: '/ping',
  );

  double _progressDownload = 0;
  double _progressUpload = 0;


  double _pointerValue = 0;
  bool start = false;
  String btnTitle = "starttest".tr();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // setBestServers();
    });
    super.initState();
  }

  Future<int> getdata() async {
    var statu = await getUserStatus();
    await Future<dynamic>.delayed(const Duration(milliseconds: 3000));
    return statu;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: brightness == Brightness.light ? Colors.black : null,
          ),
          centerTitle: true,
          title: Text(
            "speedtest".tr(),
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
                  "WizmirNET",
                  style: TextStyle(
                      color:
                          brightness == Brightness.light ? Colors.black : null),
                ),
              ),
              Tab(
                icon: Text(
                  "GSM",
                  style: TextStyle(
                      color:
                          brightness == Brightness.light ? Colors.black : null),
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<Object>(
            future: getdata(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return TabBarView(
                  children: [
                    Center(
                      child: snapshot.data == 1
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: RadialGauge(
                                      axes: [
                                        RadialGaugeAxis(
                                          minValue: 0,
                                          maxValue: 200,
                                          minAngle: -150,
                                          maxAngle: 150,
                                          radius: 0.4,
                                          width: 0.2,
                                          color: Colors.blue,
                                          ticks: [
                                            RadialTicks(
                                                interval: 50,
                                                alignment:
                                                    RadialTickAxisAlignment
                                                        .inside,
                                                color: Colors.black,
                                                length: 0.2,
                                                children: [
                                                  RadialTicks(
                                                    ticksInBetween: 5,
                                                    length: 0.2,
                                                    color: Colors.white12,
                                                  ),
                                                ]),
                                          ],
                                          pointers: [
                                            RadialNeedlePointer(
                                              value: _pointerValue,
                                              thicknessStart: 5,
                                              thicknessEnd: 0,
                                              color: Colors.red,
                                              length: 0.4,
                                              knobRadiusAbsolute: 4,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  'Download Test:  ${_progressDownload.round()} Mbps',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 20,
                                ),
                                Text(
                                  'Upload Test: ${_progressUpload.round()} Mbps',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            !start ? Colors.blue : Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40.0, vertical: 20.0),
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          start = true;
                                          btnTitle = "wait".tr();
                                          _progressDownload = 0;
                                          _progressUpload = 0;
                                        });
                                        if (start) {
                                          _speedtest.getDataspeedtest(
                                            downloadOnProgress:
                                                ((percent, transferRate) {
                                              setState(() {
                                                _pointerValue = transferRate * 2;
                                                _progressDownload =
                                                    transferRate * 2;
                                              });
                                            }),
                                            uploadOnProgress:
                                                ((percent, transferRate) {
                                              setState(() {
                                                _pointerValue = transferRate * 2;
                                                _progressUpload = transferRate * 2;
                                              });
                                            }),
                                            progressResponse:
                                                ((responseTime, jitter) {
                                              setState(() {
                                                // _ping = responseTime;
                                                // _jitter = jitter;
                                              });
                                            }),
                                            onError: ((errorMessage) {
                                              // print(errorMessage);
                                            }),
                                            onDone: () {
                                              setState(() {
                                                start = false;
                                                btnTitle = "starttest".tr();
                                              });
                                            },
                                          );
                                        }
                                      },
                                      child: Text(btnTitle),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "youarenotconnectedtothewizmirnetnetwork"
                                      .tr(),
                                )
                              ],
                            ),
                    ),
                    Center(
                      child: snapshot.data == 0
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: RadialGauge(
                                      axes: [
                                        RadialGaugeAxis(
                                          minValue: 0,
                                          maxValue: 100,
                                          minAngle: -150,
                                          maxAngle: 150,
                                          radius: 0.4,
                                          width: 0.2,
                                          color: Colors.blue,
                                          ticks: [
                                            RadialTicks(
                                                interval: 50,
                                                alignment:
                                                    RadialTickAxisAlignment
                                                        .inside,
                                                color: Colors.black,
                                                length: 0.2,
                                                children: [
                                                  RadialTicks(
                                                    ticksInBetween: 5,
                                                    length: 0.2,
                                                    color: Colors.white12,
                                                  ),
                                                ]),
                                          ],
                                          pointers: [
                                            RadialNeedlePointer(
                                              value: _pointerValue,
                                              thicknessStart: 5,
                                              thicknessEnd: 0,
                                              color: Colors.red,
                                              length: 0.4,
                                              knobRadiusAbsolute: 4,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  'Download Test:  ${_progressDownload.round()} Mbps',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 20,
                                ),
                                Text(
                                  'Upload Test: ${_progressUpload.round()} Mbps',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            !start ? Colors.blue : Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40.0, vertical: 20.0),
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          start = true;
                                          btnTitle = "wait".tr();
                                          _progressDownload = 0;
                                          _progressUpload = 0;
                                        });
                                        if (start) {
                                          _speedtest.getDataspeedtest(
                                            downloadOnProgress:
                                                ((percent, transferRate) {
                                              setState(() {
                                                _pointerValue = transferRate * 2;
                                                _progressDownload =
                                                    transferRate * 2;
                                              });
                                            }),
                                            uploadOnProgress:
                                                ((percent, transferRate) {
                                              setState(() {
                                                _pointerValue = transferRate * 2;
                                                _progressUpload = transferRate * 2;
                                              });
                                            }),
                                            progressResponse:
                                                ((responseTime, jitter) {
                                              setState(() {
                                                // _ping = responseTime;
                                                // _jitter = jitter;
                                              });
                                            }),
                                            onError: ((errorMessage) {
                                              // print(errorMessage);
                                            }),
                                            onDone: () {
                                              setState(() {
                                                start = false;
                                                btnTitle = "starttest".tr();
                                              });
                                            },
                                          );
                                        }
                                      },
                                      child: Text(btnTitle),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "youareconnectedtothewizmirnetnetwork".tr())
                              ],
                            ),
                    ),
                  ],
                );
              } else {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [CircularProgressIndicator()],
                  ),
                );
              }
            }),
      ),
    );
  }
}
