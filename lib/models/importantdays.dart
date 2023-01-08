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
  DateTime baslangicTarihi;
  DateTime bitisTarihi;
  int gosterimSayisi;
  int silindi;
  int aktif;
  int onay;

  ImportantDays(
      {required this.id,
      required this.baslik,
      required this.turu,
      required this.url,
      required this.baslangicTarihi,
      required this.bitisTarihi,
      required this.gosterimSayisi,
      required this.silindi,
      required this.aktif,
      required this.onay,
      
      });

  factory ImportantDays.fromjson(Map json) {
    return ImportantDays(
      baslik: json["Baslik"],
      id: json["Id"],
      turu: json["Turu"],
      url: "https://yonetim.wizmir.net/mobilapi/images/${json["Url"]}",
      aktif: int.parse(json["Aktif"]), 
      baslangicTarihi: DateTime.parse(json["BaslangicTarihi"]), 
      bitisTarihi: DateTime.parse(json["BitisTarihi"]), 
      gosterimSayisi: int.parse(json["GosterimSayisi"]), 
      onay: int.parse(json["Onay"]), 
      silindi: int.parse(json["Silindi"]),
    );
  }
}
