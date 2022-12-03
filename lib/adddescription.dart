import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wizmir/models/locations.dart';

class AddDescriptionPage extends StatefulWidget {
  const AddDescriptionPage(
      {Key? key, required this.location, required this.callback})
      : super(key: key);
  final Locations location;
  final Function callback;
  @override
  State<AddDescriptionPage> createState() => _AddDescriptionPageState();
}

class _AddDescriptionPageState extends State<AddDescriptionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController desc = TextEditingController();

  @override
  void initState() {
    if (widget.location.aciklama != null) {
      desc.text = widget.location.aciklama!;
    }

    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
          "addadescription".tr(),
          style: const TextStyle(color: Colors.black),
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
      body: Container(
        color: Colors.black12,
        padding: const EdgeInsets.all(2),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Form(
                child: Column(
              children: [
                Text(
                  widget.location.antenAdi.replaceAll("_", " "),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: desc,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  minLines: 14,
                  maxLines: 18,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        senddescription(widget.location.id, desc.text)
                            .then((value) {
                          if (value == "1") {
                            Navigator.pop(context);
                            Toast.show("sent".tr(),
                                duration: Toast.lengthShort,
                                gravity: Toast.bottom);
                            Locations newitem =
                                Locations.copyWith(widget.location, desc.text);
                            widget.callback(widget.location, newitem);
                          } else {
                            Toast.show("anerroroccurred".tr(),
                                duration: Toast.lengthShort,
                                gravity: Toast.bottom);
                          }
                        });
                      },
                      child:  Text("save".tr())),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
