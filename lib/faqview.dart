import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title:  Text(
          "faq".tr(),
          style:const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<Faq>>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) => ExpansionTile(
                        title: Text(
                          snapshot.data![index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        children: [
                          ListTile(title: Text(snapshot.data![index].content)),
                        ],
                      )),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                     CircularProgressIndicator()
                  ],
                );
              }
            }),
      ),
    );
  }
}
