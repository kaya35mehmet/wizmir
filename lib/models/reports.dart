import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<String> sendreport2(username, sorun, String? apid) async {
  var storage = const FlutterSecureStorage();
  if (username == null || username == "") {
    username = await storage.read(key: "number");
  }
  var guid = await storage.read(key: "guid") ?? "-";

  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/sorunkaydet.php');
  final response = await http.post(
    url,
    body: <String, String>{
      "guid": guid,
      "username": username.toString().replaceAll("+", ""),
      "sorun": sorun,
      "apid": apid!,
    },
  );

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

Future<String> sendreport(
    username, sorun, diger, String? apid, File? file) async {
  var storage = const FlutterSecureStorage();
  if (username == null || username == "") {
    username = await storage.read(key: "number");
  }
  var guid = await storage.read(key: "guid") ?? "-";

  var request = http.MultipartRequest(
      "POST", Uri.parse("https://yonetim.wizmir.net/mobilapi/sorunkaydet.php"));
  request.fields["guid"] = guid;
  request.fields["username"] = username;
  request.fields["sorun"] = sorun;
  request.fields["apid"] = apid ?? "";
  request.fields["diger"] = diger ?? "";

  if (file != null) {
    var pic = await http.MultipartFile.fromPath("resim", file.path);
    request.files.add(pic);
  } else {
    request.fields["resim"] = "";
  }

  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  return responseString;
}

Future<String> senddisasterreport(
     yikilanbina, hasarlibina, yaralisayisi, vefatsayisi, aciklama, File? file) async {
  var storage = const FlutterSecureStorage();
  var username = await storage.read(key: "number");
  var guid = await storage.read(key: "guid") ?? "-";
  var request = http.MultipartRequest(
      "POST", Uri.parse("https://yonetim.wizmir.net/mobilapi/muhtarafetkaydet.php"));
  request.fields["guid"] = guid;
  request.fields["username"] = username!;
  request.fields["yikilanbina"] = yikilanbina;
  request.fields["hasarlibina"] = hasarlibina;
  request.fields["yaralisayisi"] = yaralisayisi;
  request.fields["vefatsayisi"] = vefatsayisi;
  request.fields["aciklama"] = aciklama;

  if (file != null) {
    var pic = await http.MultipartFile.fromPath("resim", file.path);
    request.files.add(pic);
  } else {
    request.fields["resim"] = "";
  }

  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  return responseString;
}
