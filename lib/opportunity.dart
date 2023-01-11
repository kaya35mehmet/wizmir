import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Opportunity extends StatefulWidget {
  const Opportunity({Key? key}) : super(key: key);

  @override
  State<Opportunity> createState() => _OpportunityState();
}

class _OpportunityState extends State<Opportunity> {
   var brightness = SchedulerBinding.instance.window.platformBrightness;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: brightness == Brightness.light ? Colors.black : null,
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/ibblogo.png",
              width: 230,
            ),
          ],
        ),
        // Text(
        //   "opportunity".tr(),
        //   style: TextStyle(
        //       color: brightness == Brightness.light ? Colors.black : null),
        // ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: brightness == Brightness.light ? Colors.white : null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text("comingsoon".tr(),style: const  TextStyle(fontSize: 20,color: Colors.grey,fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            )),
          ],
        )
      ]),
    );
  }
}