import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Faq>> getsss() async {
  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getsss.php');

  final response = await http.get(url);

  if (response.statusCode == 200) {

     Iterable res = json.decode(response.body);
    return res.map((e) => Faq.fromJson(e)).toList();
  } else {
    throw Exception('Failed');
  }
}

class Faq {
  String id;
  String title;
  String content;

  Faq({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Faq.fromJson(Map json) {
    return Faq(
      content: json["Icerik"],
      id: json["Id"],
      title: json["Baslik"],
    );
  }
}
