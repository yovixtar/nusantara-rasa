import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nusantara/models/promo.dart';

class PromoService {
  String baseUrl = "https://faux-api.com/api/v1/promo_8199927638358229";

  Future<List<Promo>> fetchPromo() async {
    try {
      var url = Uri.parse(baseUrl);

      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['result'];
        return data.map((item) => Promo.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
