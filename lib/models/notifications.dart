import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Notifications>> getnotificantions() async {

  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getnotifications.php');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    return res.map((e) => Notifications.fromJson(e)).toList();
  } else {
    throw Exception('Failed');
  }
}

class Notifications{

  String id;
  String note;
  String tarih;

  Notifications({required this.id, required this.note, required this.tarih});


  factory Notifications.fromJson(Map json) {
    
    return Notifications(
      id: json["Id"],
      note: json["Note"],
      tarih: json["Tarih"],
    );
  }
}