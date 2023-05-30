import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<NewNotification> getnotifications() async {
  final prefs = await SharedPreferences.getInstance();

  var url =
      Uri.parse('https://yonetim.wizmir.net/mobilapi/getnotifications.php');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    var dd = res.map((e) => Notifications.fromJson(e)).toList();
    final List<String>? items = prefs.getStringList('items');
    NewNotification nn =
        NewNotification(notificationlist: dd, isnewnotification: false);
    for (var element in dd) {
      if (items != null) {
        if (!items.contains(element.id)) {
          nn.isnewnotification = true;
          return nn;
        }
      }
    }
    return nn;
  } else {
    throw Exception('Failed');
  }
}

class Notifications {
  String id;
  String note;
  String tarih;
  String baslik;
  String? gonderen;
  String? onaylayan;
  String? onay;

  Notifications({
    required this.id,
    required this.note,
    required this.tarih,
    required this.baslik,
    this.gonderen,
    this.onaylayan,
    this.onay,
  });

  factory Notifications.fromJson(Map json) {
    return Notifications(
      id: json["Id"],
      note: json["Note"],
      tarih: json["Tarih"],
      baslik: json["Baslik"],
    );
  }
}

class NewNotification {
  List<Notifications> notificationlist;
  bool isnewnotification;

  NewNotification(
      {required this.isnewnotification, required this.notificationlist});
}
