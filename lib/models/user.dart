import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<String> register(User user, String sms) async {
 String username = user.telefon.replaceAll('+', '');
  var url =
      Uri.parse('https://yonetim.wizmir.net/mobilapi/uyekayit.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
    "adsoyad": user.adsoyad,
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

class User {
  String telefon;
  String adsoyad;
  String sifre;
  String cinsiyet;
  String? rol;
  String yas;

  User(
      {required this.telefon,
      required this.adsoyad,
      required this.sifre,
      required this.cinsiyet,
       this.rol,
      required this.yas});
}
