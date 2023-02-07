// import 'dart:convert';
// import 'package:http/http.dart' as http;

Future<List<Job>> getjobsfromdb() async {

  List<Job> jobs = [
    Job(id: "1", title: "Yazılımcı"),
    Job(id: "2", title: "Öğretmen"),
    Job(id: "3", title: "Belediye Personeli"),
    Job(id: "4", title: "Asker"),
    Job(id: "5", title: "Tekstilci"),
    Job(id: "6", title: "Çiçekçi"),
    Job(id: "7", title: "Şoför"),
    Job(id: "8", title: "Avukat"),
    Job(id: "9", title: "Doktor"),
    Job(id: "10", title: "Mühendis"),
  ];
  // var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/meslekler.php');

  // final response = await http.get(url);

  // if (response.statusCode == 200) {
  //   Iterable res = json.decode(response.body);
  //   return res.map((e) => Job.fromjson(e)).toList();
  // } else {
  //   throw Exception('Failed');
  // }

  return jobs;
}


class Job{
  String id;
String title;

Job({required this.id,required this.title});

factory Job.fromjson(Map json) {
    return Job(id: json["id"], title: json["sehiradi"]);
  }
}