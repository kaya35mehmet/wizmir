import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Notifications>> getnotifications() async {
  var url =
      Uri.parse('https://yonetim.wizmir.net/mobilapi/getnotifications.php');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    var dd = res.map((e) => Notifications.fromJson(e)).toList();
    return dd;
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
