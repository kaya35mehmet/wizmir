import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<City>> getcitiesfromdb() async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/iller.php');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    return res.map((e) => City.fromjson(e)).toList();
  } else {
    throw Exception('Failed');
  }
}

Future<List<District>> getdistrictfromdb(id) async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/ilceler.php');

  final response = await http.post(url, body: <String, String>{
    "ilid": id,
  });

  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    return res.map((e) => District.fromjson(e)).toList();
  } else {
    throw Exception('Failed');
  }
}

class City {
  String id;
  String sehiradi;

  City({required this.id, required this.sehiradi});

  factory City.fromjson(Map json) {
    return City(id: json["id"], sehiradi: json["sehiradi"]);
  }
}

class District{
  String id;
  String ilceadi;

  District({
    required this.id,
    required this.ilceadi,
  });

   factory District.fromjson(Map json) {
    return District(id: json["id"], ilceadi: json["ilceadi"]);
  }
}
