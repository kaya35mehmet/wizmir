import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<String> getUserStatus() async {
  var storage = const FlutterSecureStorage();
  var username = await storage.read(key: "number");
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getUserStatus.php');
  final response = await http.post(url, body: <String, String>{
    "username": username!,
  });

  if (response.statusCode == 200) {
    try {
      var res = json.decode(response.body);
      return res.toString().trim();
    } catch (e) {
      return response.body.trim();
    }
  } else {
    throw Exception('Failed');
  }
}

Future<String> setSpeedTest(String download, String upload,String durum, String lokasyon) async {
  var storage = const FlutterSecureStorage();
  var username = await storage.read(key: "number");
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/setSpeedTest.php');
  final response = await http.post(url, body: <String, String>{
    "kullanici": username!,
    "download": download,
    "upload": upload,
    "durum": durum,
    "lokasyon": lokasyon,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString().trim();
  } else {
    throw Exception('Failed');
  }
}
