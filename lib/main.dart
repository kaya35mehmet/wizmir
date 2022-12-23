import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wizmir/animatesplash.dart';
import 'package:wizmir/dd.dart';
import 'package:wizmir/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  String? guid = "0";
  bool isadmin = false;
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  @override
  void initState() {
    _guid();
    super.initState();
  }

  Future<void> _guid() async {
    storage.read(key: "guid").then((value) => setState(
          () => setState(() {
            guid = value ?? "0";
          }),
        ));
    storage.read(key: "isadmin").then((value) => setState(
          () => setState(() {
            isadmin = value == "1" ? true : false;
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WizmirNET',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue
      ),
      theme: ThemeData(
        brightness: Brightness.light,
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // home: const AnimeWidget(),
      home: SplashScreen(
        guid: guid!,
        isadmin: isadmin,
      ),
    );
  }
}
