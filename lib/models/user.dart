import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<String> register(User user, String sms) async {
  String username = user.telefon.replaceAll('+', '');
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/uyekayit.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
    "ad": user.ad,
    "soyad":user.soyad,
    "sifre": user.sifre,
    "cinsiyet": user.cinsiyet,
    "yas": user.yas.toString(),
    "sms": sms,
    "ilceid": user.ilceid!,
    "ilid": user.ilid!,
    "meslek" : user.meslek!,
    "eposta" : user.eposta!,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

Future<User> getuserbyusername() async {
  var storage = const FlutterSecureStorage();
  String? username = await storage.read(key: "number");

  username = username!.replaceAll('+', '');
  var url =
      Uri.parse('https://yonetim.wizmir.net/mobilapi/getuserbyusername.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    var u =User.getjson(res);
    return u;
  } else {
    throw Exception('Failed');
  }
}

Future<String> profilecomplete(String username, cinsiyet, yas) async {
  username = username.replaceAll('+', '');
  var url =
      Uri.parse('https://yonetim.wizmir.net/mobilapi/profilecomplete.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
    "cinsiyet": cinsiyet,
    "yas": yas.toString(),
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

Future<String> deleteaccount(String username) async {
  username = username.replaceAll('+', '');
  var url =
      Uri.parse('https://yonetim.wizmir.net/mobilapi/deleteaccount.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

Future<String> updateprfil(String username, ad, soyad, eposta, cinsiyet, yas, il, ilce, meslek) async {
  username = username.replaceAll('+', '');
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/updateprofile.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
    "ad": ad,
    "soyad":soyad,
    "cinsiyet": cinsiyet,
    "yas": yas.toString(),
    "ilid": il,
    "ilceid": ilce,
    "meslek": meslek,
    "eposta": eposta,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}


class User {
  String telefon;
  String ad;
  String soyad;
  String sifre;
  String cinsiyet;
  String? rol;
  String? yas;
  String? ilceid;
  String? ilid;
  String? meslek;
  String? eposta;

  User(
      {required this.telefon,
      required this.ad,
      required this.soyad,
      required this.sifre,
      required this.cinsiyet,
      this.rol,
      this.yas,
      this.ilceid,
      this.ilid,
      this.meslek,
      this.eposta,
      });

  factory User.getjson(Map user) {
    return User(
        telefon: user["username"],
        ad: user["firstname"],
        soyad: user["lastname"],
        sifre: user["password"],
        cinsiyet: user["Cinsiyet"],
        yas: user["Yas"],
        ilceid: user["ilce"],
        ilid: user["il"],
        eposta: user["email"],
        meslek: user["meslek"]);
  }
}
