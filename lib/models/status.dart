import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Status> getstatus() async {


  var url = Uri.parse('https://yonetim.wizmir.net/mobilapi/status.php');
  final response = await http.get(
    url
  );

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    var status = Status.getjson(res);
    return status;
  } else {
    throw Exception('Failed');
  }
}

class Status{
  String toplamKayitliKullanici;
  String toplamOnlineKullanici;
  String toplamGirisSayisi;
  String toplamUpload;
  String toplamDownload;
  String sonCron;
  String lokasyonSayisi;

  Status({
   required this.toplamKayitliKullanici,
   required this.toplamOnlineKullanici,
   required this.toplamGirisSayisi,
   required this.toplamUpload,
   required this.toplamDownload,
   required this.sonCron,
   required this.lokasyonSayisi,
  });

  factory Status.getjson(Map json){
    return Status(
      toplamKayitliKullanici: json["ToplamKayitliKullanici"],
      toplamOnlineKullanici: json["ToplamOnlineKullanici"],
      toplamGirisSayisi: json["ToplamGirisSayisi"],
      toplamUpload: json["ToplamUpload"],
      toplamDownload: json["ToplamDownload"],
      sonCron: json["SonCron"],
      lokasyonSayisi: json["LokasyonSayisi"],
    );
  }
}