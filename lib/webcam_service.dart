import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class Webcam {
  final String nom;
  final String url;
  final String webcamId;
  final List<dynamic> planXY;

  Webcam({
    required this.nom,
    required this.url,
    required this.webcamId,
    required this.planXY,
  });

  factory Webcam.fromJson(Map<String, dynamic> json) {
    return Webcam(
      nom: json['Nom'],
      url: json['Url'],
      webcamId: json['Webcam_ID'],
      planXY: json['Plan_XY'],
    );
  }

  Map toJson() =>
      {"nom": nom, "webcamID": webcamId, "planXY": planXY, "url": url};
}

Future<List<Webcam>> fetchWebcamUrls() async {
  const String url = 'https://ws-s69-legrandbornand.intence.tech';
  final String body = jsonEncode({
    "Function": "GET_WEBCAMS",
    "SITE_ID": "69",
    "SAISON": "hiver",
    "PARTNER_ID": "",
    "UID": ""
  });
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final webcamsData = data['WEBCAMS'] as List<dynamic>;
    return webcamsData.map((e) {
      return Webcam(
          nom: e["Nom"],
          url: e["Url"],
          webcamId: e["Webcam_ID"],
          planXY: e["Plan_XY"]);
    }).toList();
  } else {
    throw Exception('Failed to fetch webcam urls');
  }
}
