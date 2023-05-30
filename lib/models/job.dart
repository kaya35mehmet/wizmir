import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Job>> getjobsfromdb() async {

  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getMeslekler.php');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    List<Job> dd = res.map((e) => Job.fromjson(e)).toList();
    
    Job diger = dd.firstWhere((element) => element.title == 'Diğer');

    dd.remove(diger);
    dd.insert(dd.length, diger);
    return dd;
  } else {
    throw Exception('Failed');
  }
}


class Job{
  String id;
String title;

Job({required this.id,required this.title});

factory Job.fromjson(Map json) {
    return Job(id: json["Id"], title: json["Meslek"]);
  }
}