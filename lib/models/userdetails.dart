import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<UserDetails> getdetails() async {
  var storage = const FlutterSecureStorage();
  String? username = await storage.read(key: "number");

  username = username!.replaceAll('+', '');
  var url =
      Uri.parse('https://yonetim.wizmir.net/mobilapi/userdetails.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
  });

  if (response.statusCode == 200) {
    var url2 =
        Uri.parse('https://yonetim.wizmir.net/mobilapi/getuseraplist.php');

    final response2 = await http.post(url2, body: <String, String>{
      "username": username,
    });
    
    var res = json.decode(response.body);
    var ud = UserDetails.fromjson(res);

    if (response2.statusCode == 200) {
      var res2 = json.decode(response2.body);
      
      if (res2 != 0) {
        Iterable itr = res2;
        ud.girisLokasyonlari = itr.map((e)=>UserLocations.fromJson(e)).toList();
      }
    }
   
    return ud;
  } else {
    throw Exception('Failed');
  }
}



class UserDetails {
  int toplamGiris;
  double toplamDownload;
  double toplamUpload;
  double toplamSureSaat;
  double toplamSureDakika;
  double toplamSureSaniye;
  List<UserLocations>? girisLokasyonlari;

  UserDetails({
    required this.toplamGiris,
    required this.toplamDownload,
    required this.toplamUpload,
    required this.toplamSureSaat,
    required this.toplamSureDakika,
    required this.toplamSureSaniye,
    this.girisLokasyonlari,
  });

  factory UserDetails.fromjson(Map json) {
    return UserDetails(
      toplamGiris: int.parse(json["ToplamGiris"]),
      toplamDownload:
          ((double.parse(json["ToplamDownload"]) / 1024) / 1024) / 1024,
      toplamUpload: ((double.parse(json["ToplamUpload"]) / 1024) / 1024) / 1024,
      toplamSureSaat: double.parse(json["ToplamSure"].toString().split(':')[0]),
      toplamSureDakika:
          double.parse(json["ToplamSure"].toString().split(':')[1]),
      toplamSureSaniye:
          double.parse(json["ToplamSure"].toString().split(':')[2]),
      // girisLokasyonlari: (json["types"] as List)
      //     .map((i) => UserLocations.fromJson(i))
      //     .toList(),
    );
  }
}

class UserLocations {
  String name;

  UserLocations({required this.name});

  factory UserLocations.fromJson(Map json) {
    return UserLocations(
      name: json['AntenAdi'],
    );
  }
}
