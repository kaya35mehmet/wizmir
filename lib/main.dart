import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wizmir/ss.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
    // return MaterialApp(
    //    debugShowCheckedModeBanner: false,
    //   builder: (context, child) => ResponsiveWrapper.builder(child,
    //       maxWidth: 1200,
    //       minWidth: 480,
    //       defaultScale: true,
    //       breakpoints: [
    //         const ResponsiveBreakpoint.resize(480, name: MOBILE),
    //         const ResponsiveBreakpoint.autoScale(800, name: TABLET),
    //         const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
    //       ],
    //       background: Container(color: const Color(0xFFF5F5F5))),
    //   initialRoute: "/",
    //   home: SplashScreen(guid: guid!, isadmin: isadmin, brightness: brightness),
    //   localizationsDelegates: context.localizationDelegates,
    //   supportedLocales: context.supportedLocales,
    //   locale: context.locale,
    //   darkTheme: ThemeData(
    //     brightness: Brightness.dark,
    //   ),
    //   theme: ThemeData(
    //     brightness: Brightness.light,
    //   ).copyWith(
    //     pageTransitionsTheme: const PageTransitionsTheme(
    //       builders: <TargetPlatform, PageTransitionsBuilder>{
    //         TargetPlatform.android: ZoomPageTransitionsBuilder(),
    //       },
    //     ),
    //   ),
    // );
    return MaterialApp(
      title: 'WizmirNET',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
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
      home: SecondClass(guid: guid!, isadmin: isadmin, brightness: brightness),
      // home: SplashScreen(
      //   guid: guid!,
      //   isadmin: isadmin,
      //   brightness:brightness
      // ),
    );
  }
}
