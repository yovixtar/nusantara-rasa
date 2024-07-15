import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nusantara/models/pesanan.dart';
import 'package:nusantara/services/session.dart';

class PesananService {
  String baseUrl = "https://faux-api.com/api/v1/pesanan_8199927638358229";

  Future<bool> pesanMenu({
    List<Map<String, dynamic>>? pesananItem,
    int? total,
    String? pengambilan,
  }) async {
    var pengguna = await SessionManager.getUsername();
    var url = Uri.parse(baseUrl);

    var body = jsonEncode([
      {
        'pengguna': "$pengguna",
        'menus': pesananItem,
        "total": "$total",
        "pengambilan": "$pengambilan",
      },
    ]);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseData['result'].isEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<List<Pesanan>> fetchPesanan() async {
    try {
      var username = await SessionManager.getUsername();
      var url = Uri.parse('$baseUrl/{"pengguna":"$username"}');

      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['result'];
        return data.map((item) => Pesanan.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
