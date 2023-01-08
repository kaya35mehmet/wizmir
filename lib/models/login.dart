import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<Login> login(String username, String password) async {
  username = username.replaceAll('+', '');
  String passwordmd5 = md5.convert(utf8.encode(password)).toString();
  String secretkey = md5
      .convert(utf8.encode(md5.convert(utf8.encode(username)).toString() +
          md5.convert(utf8.encode(passwordmd5)).toString()))
      .toString();
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/user.php');
  final response = await http.post(url, body: <String, String>{
    "username": username,
    "password": passwordmd5,
    "secretkey": secretkey
  });

  if (response.statusCode == 200) {
    var dddata = response.body.toString().split("|");
    var res = json.decode(dddata[0]);
    var dd = md5.convert(utf8.encode(secretkey)).toString();
    bool isadmin = false;
    if (res.toString() == dd) {
      var storage = const FlutterSecureStorage();
      await storage.write(key: "guid", value: res.toString());
      await storage.write(key: "number", value: username);
      var url2 = Uri.parse('https://yonetim.wizmir.net/mobilapi/getAdmin.php');
      final response2 = await http.post(url2, body: <String, String>{
        "username": username,
      });

      if (response2.statusCode == 200) {
        var res2 = json.decode(response2.body);
        if (res2 == 1) {
          isadmin = true;
          await storage.write(key: "isadmin", value: "1");
        } else {
          isadmin = false;
          await storage.write(key: "isadmin", value: "0");
        }
      }
      return Login(
          username: username,
          password: password,
          isadmin: isadmin,
          success: res,
          fullprofile: dddata[1] != "" && dddata[2] != "" ? true : false
          );
    } else {
      return Login(
          username: username, password: password, isadmin: false, success: "0");
    }
  } else {
    throw Exception('Failed');
  }
}

Future<String> sendsms(String username, String type) async {
  username = username.replaceAll('+', '');
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/smsgonder.php');

  final response = await http.post(url, body: <String, String>{
    "username": username,
    "type": type,
  });

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

Future<String> forgotpassword(String username, String sms) async {
  username = username.replaceAll('+', '');
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/forgotpassword.php');
  final response = await http
      .post(url, body: <String, String>{"username": username, "sms": sms});
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

Future<String> newpassword(String username, String password) async {
  username = username.replaceAll('+', '');
  String passwordmd5 = md5.convert(utf8.encode(password)).toString();

  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/newpassword.php');
  final response = await http.post(url, body: <String, String>{
    "username": username,
    "password": passwordmd5,
    "password2": password
  });
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

Future<String> changepassword(
    String username, String oldpassword, String newpassword) async {
  username = username.replaceAll('+', '');
  String oldpasswordmd5 = md5.convert(utf8.encode(oldpassword)).toString();
  String newpasswordmd5 = md5.convert(utf8.encode(newpassword)).toString();
  String secretkey = md5
      .convert(utf8.encode(md5.convert(utf8.encode(username)).toString() +
          md5.convert(utf8.encode(oldpasswordmd5)).toString()))
      .toString();
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/changepassword.php');
  final response = await http.post(url, body: <String, String>{
    "username": username,
    "oldpassword": oldpasswordmd5,
    "newpassword": newpasswordmd5,
    "password": newpassword,
    "secretkey": secretkey
  });
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res.toString();
  } else {
    throw Exception('Failed');
  }
}

class Login {
  String username;
  String password;
  bool? isadmin;
  String? success;
  bool? fullprofile;

  Login(
      {required this.username,
      required this.password,
      this.isadmin,
      this.success,
      this.fullprofile,
      });

  factory Login.fromJson(Map json) {
    return Login(
      username: json['username'],
      password: json['password'],
    );
  }
}
