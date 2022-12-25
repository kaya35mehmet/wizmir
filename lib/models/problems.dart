import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Problems>> getproblems() async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getSorunTuru.php');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    return res.map((e) => Problems.fromJson(e)).toList();
  } else {
    throw Exception('Failed');
  }
}

class Problems {
  String id;
  String name;
  String sorunTuruIng;

  Problems({required this.id, required this.name, required this.sorunTuruIng});

  factory Problems.fromJson(Map json) {
    
    return Problems(
      id: json["Id"],
      name: json["SorunTuru"],
      sorunTuruIng: json["SorunTuruIng"],
    );
  }
}
