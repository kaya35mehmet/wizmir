import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    return User.getjson(res);
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

Future<String> updateprfil(String username, ad, soyad, cinsiyet, yas) async {
  username = username.replaceAll('+', '');
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/updateprofile.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
    "ad": ad,
    "soyad":soyad,
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



class User {
  String telefon;
  String ad;
  String soyad;
  String sifre;
  String cinsiyet;
  String? rol;
  String yas;

  User(
      {required this.telefon,
      required this.ad,
      required this.soyad,
      required this.sifre,
      required this.cinsiyet,
      this.rol,
      required this.yas});

  factory User.getjson(Map user) {
    return User(
        telefon: user["username"],
        ad: user["firstname"],
        soyad: user["lastname"],
        sifre: user["password"],
        cinsiyet: user["Cinsiyet"],
        yas: user["Yas"]);
  }
}
