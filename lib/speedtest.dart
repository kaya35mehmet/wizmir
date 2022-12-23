// ignore_for_file: no_leading_underscores_for_local_identifiers, duplicate_ignore

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:speed_test_dart/classes/classes.dart';
import 'package:speed_test_dart/speed_test_dart.dart';
import 'package:wizmir/models/speedtest.dart';

void main() => runApp(const SpeedTest());

class SpeedTest extends StatefulWidget {
  const SpeedTest({super.key});

  @override
  State<SpeedTest> createState() => _SpeedTestState();
}

class _SpeedTestState extends State<SpeedTest> {
  SpeedTestDart tester = SpeedTestDart();
  List<Server> bestServersList = [];

  double downloadRate = 0;
  double uploadRate = 0;

  bool readyToTest = false;
  bool loadingDownload = false;
  bool loadingUpload = false;

  String downloadProgress = '0';
  String uploadProgress = '0';

  Future<void> setBestServers() async {
    final settings = await tester.getSettings();
    final servers = settings.servers;

    final _bestServersList = await tester.getBestServers(
      servers: servers,
    );

    setState(() {
      bestServersList = _bestServersList;
      readyToTest = true;
    });
  }

  Future<void> _testDownloadSpeed() async {
    setState(() {
      loadingDownload = true;
    });

    final _downloadRate = await tester.testDownloadSpeed(servers: bestServersList);
     setState(() {
        downloadRate = _downloadRate;
        loadingDownload = false;
      });
      _testUploadSpeed();
  }

  Future<void> _testUploadSpeed() async {
    setState(() {
      loadingUpload = true;
    });

    final _uploadRate = await tester.testUploadSpeed(servers: bestServersList);

    setState(() {
      uploadRate = _uploadRate;
      loadingUpload = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setBestServers();
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
          iconTheme:  IconThemeData(
            color: brightness == Brightness.light ? Colors.black : null,
          ),
          centerTitle: true,
          title: Text(
            "speedtest".tr(),
            style:  TextStyle(color:brightness == Brightness.light ? Colors.black : null),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: brightness == Brightness.light ? Colors.white : null,
          bottom:  TabBar(
            tabs: <Widget>[
              Tab(
                icon: Text(
                  "WizmirNET",
                  style: TextStyle(color: brightness == Brightness.light ? Colors.black : null),
                ),
              ),
              Tab(
                icon: Text(
                  "GSM",
                  style: TextStyle(color: brightness == Brightness.light ? Colors.black : null),
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
                                const Text(
                                  'Download Test:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                loadingDownload
                                    ? const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(
                                            value: 1.0),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (loadingDownload)
                                  Column(
                                    children: [
                                      Text('downloadspeedbeingtested'.tr()),
                                       Text('pleasewait'.tr()),
                                    ],
                                  )
                                else
                                  Text(
                                      'Download :  ${downloadRate.toStringAsFixed(2)} Mb/s'),
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                const Text(
                                  'Upload Test:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                loadingUpload
                                    ? const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(
                                            value: 1.0),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (loadingUpload)
                                  Column(
                                    children: [
                                      Text('uploadspeedbeingtested'.tr()),
                                     Text('pleasewait'.tr()),

                                    ],
                                  )
                                else
                                  Text(
                                      'Upload : ${uploadRate.toStringAsFixed(2)} Mb/s'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: readyToTest &&
                                                !loadingDownload &&
                                                !loadingUpload
                                            ? Colors.blue
                                            : Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40.0, vertical: 20.0),
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed:
                                          loadingDownload && loadingUpload
                                              ? null
                                              : () async {
                                                  if (!readyToTest ||
                                                      bestServersList.isEmpty)
                                                    return;
                                                  await _testDownloadSpeed();
                                                },
                                      child: Text('starttest'.tr()),
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
                                const Text(
                                  'Download Test:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                loadingDownload
                                    ? const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(
                                            value: 1.0),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (loadingDownload)
                                  Column(
                                    children: [
                              
                                      Text('downloadspeedbeingtested'.tr()),
                                      Text('pleasewait'.tr()),
                                    ],
                                  )
                                else
                                  Text(
                                      'Download :  ${downloadRate.toStringAsFixed(2)} Mb/s'),
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                const Text(
                                  'Upload Test:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                loadingUpload
                                    ? const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: CircularProgressIndicator(
                                            value: 1.0),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (loadingUpload)
                                  Column(
                                    children: [
                                      Text('uploadspeedbeingtested'.tr()),
                                      Text('pleasewait'.tr()),
                                    ],
                                  )
                                else
                                  Text(
                                      'Upload : ${uploadRate.toStringAsFixed(2)} Mb/s'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: readyToTest &&
                                                !loadingDownload &&
                                                !loadingUpload
                                            ? Colors.blue
                                            : Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40.0, vertical: 20.0),
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed:
                                          loadingDownload && loadingUpload
                                              ? null
                                              : () async {
                                                  if (!readyToTest ||
                                                      bestServersList.isEmpty)
                                                    return;
                                                  await _testDownloadSpeed();
                                                },
                                      child: Text('start'.tr()),
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
