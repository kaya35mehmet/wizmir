import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wizmir/models/faq.dart';

class FAQView extends StatefulWidget {
  const FAQView({Key? key}) : super(key: key);

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  Future<List<Faq>> getData() async {
    var sss = getsss();
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return sss;
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
            padding: const EdgeInsets.only(left: 50.0, right: 50,bottom: 10),
            child: SafeArea(
              child: Image.asset(
                brightness == Brightness.light ? "assets/images/ibblogo.png" : "assets/images/ibblogolight.png",
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<Faq>>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                var lang = context.locale.toString();
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) => ExpansionTile(
                        title: Text(
                          lang == "en_US"
                              ? snapshot.data![index].baslikIng
                              : snapshot.data![index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        children: [
                          ListTile(
                              title: Text(lang == "en_US"
                                  ? snapshot.data![index].icerikIng
                                  : snapshot.data![index].content)),
                        ],
                      )),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()],
                );
              }
            }),
      ),
    );
  }
}
