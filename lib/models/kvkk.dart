import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getkvkk() async {
  try {
    var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/getkvkk.php');
  final response = await http.get(url);
   if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return res;
  } else {
    throw Exception('Failed');
  }
  } catch (e) {
     return Future.error('getOnemliGun');
  }
}