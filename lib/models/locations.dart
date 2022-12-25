import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Iterable? res;

Future<List<Locations>> getalllocations() async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getlocations.php');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    return res.map((e) => Locations.fromJson(e)).toList();
  } else {
    throw Exception('Failed');
  }
}

Future<List<Locations>> getdetail() async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getApList.php');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);

    return res.map((e) => Locations.fromJsonall(e)).toList();
  } else {
    throw Exception('Failed');
  }
}

Future<String> senddescription(String id, String description) async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/aciklamakaydet.php');
  final response = await http.post(url, body: <String, String>{
    "apid": id,
    "aciklama": "$description - ${DateTime.now()}",
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString().replaceAll(" ", "");
  } else {
    throw Exception('Failed');
  }
}

Future<String> calismakaydet(String id) async {
  var storage = const FlutterSecureStorage();
  var username = await storage.read(key: "number");
  username = username!.replaceAll('+', '');
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/calismakaydet.php');
  final response = await http.post(url, body: <String, String>{
    "apid": id,
    "username": username,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString().replaceAll(" ", "");
  } else {
    throw Exception('Failed');
  }
}

Future<String> calismabitir(String id) async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/calismabitir.php');
  final response = await http.post(url, body: <String, String>{
    "apid": id,
  });
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString().replaceAll(" ", "");
  } else {
    throw Exception('Failed');
  }
}

class Locations {
  String id;
  double? lat;
  double? lng;
  String antenAdi;
  bool aktifmi;
  bool mylocation;
  String kullanicisayisi;
  String? aciklama;
  bool baslatildi;
  String lokasyon;

  Locations(
      {required this.id,
      this.lat,
      this.lng,
      required this.antenAdi,
      required this.aktifmi,
      required this.mylocation,
      required this.kullanicisayisi,
      this.aciklama,
      required this.lokasyon,
      required this.baslatildi});

  Locations.copyWith(Locations item, String desc)
      : id = item.id,
        lng = item.lat,
        lat = item.lng,
        antenAdi = item.antenAdi,
        aktifmi = item.aktifmi,
        mylocation = item.mylocation,
        lokasyon = item.lokasyon,
        kullanicisayisi = item.kullanicisayisi,
        aciklama = desc,
        baslatildi = item.baslatildi;

  Locations.copyWithwork(Locations item, bool baslat)
      : id = item.id,
        lng = item.lat,
        lat = item.lng,
        antenAdi = item.antenAdi,
        aktifmi = item.aktifmi,
        mylocation = item.mylocation,
        kullanicisayisi = item.kullanicisayisi,
        aciklama = item.aciklama,
        lokasyon = item.lokasyon,
        baslatildi = baslat;

  factory Locations.fromJson(Map json) {
    return Locations(
      id: json["Id"],
      lat: double.parse(json['LatLong'].toString().split(',')[0]),
      lng: double.parse(json['LatLong'].toString().split(',')[1]),
      antenAdi: json['AntenAdi'],
      aktifmi: toBoolean(json['Aktif']),
      mylocation: false,
      kullanicisayisi: json["OnlineKullanici"],
      aciklama: json["Aciklama"],
      baslatildi: json["calisma"] != null ? true : false,
      lokasyon: json["Lokasyon"],
    );
  }

  factory Locations.fromJsonall(Map json) {
    return Locations(
      id: json["Id"],
      antenAdi: json['AntenAdi'],
      aktifmi: toBoolean(json['Aktif']),
      mylocation: false,
      kullanicisayisi: json["OnlineKullanici"],
      aciklama: json["Aciklama"],
      baslatildi: json["calisma"] != null ? true : false,
      lokasyon: json["Lokasyon"],
    );
  }
}

bool toBoolean(String str, [bool strict = false]) {
  if (strict == true) {
    return str == '1' || str == 'true';
  }
  return str != '0' && str != 'false' && str != '';
}
