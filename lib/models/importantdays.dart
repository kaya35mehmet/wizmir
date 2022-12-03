import 'dart:convert';
import 'package:http/http.dart' as http;

Future<ImportantDays> getimportantdays() async {
  try {
    var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getOnemliGun.php');
  final response = await http.get(url);
   if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return ImportantDays.fromjson(res[0]);
  } else {
    throw Exception('Failed');
  }
  } catch (e) {
     return Future.error('getOnemliGun');
  }
}

class ImportantDays {
  String id;
  String baslik;
  String turu;
  String url;

  ImportantDays(
      {required this.id,
      required this.baslik,
      required this.turu,
      required this.url});

  factory ImportantDays.fromjson(Map json) {
    return ImportantDays(
      baslik: json["Baslik"],
      id: json["Id"],
      turu: json["Turu"],
      url: "https://yonetim.wizmir.net/OnemliGunResimler/${json["Url"]}",
    );
  }
}
