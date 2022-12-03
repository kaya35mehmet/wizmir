import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<int> getUserStatus() async {
  var storage = const FlutterSecureStorage();
  var username = await storage.read(key: "number");
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getUserStatus.php');
  final response = await http.post(url, body: <String, String>{
    "username": username!,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res;
  } else {
    throw Exception('Failed');
  }
}
