import 'dart:convert';

import 'package:http/http.dart' as http;

class PenggunaService {
  String baseUrl = "https://faux-api.com/api/v1/pengguna_8199927638358229";

  Future<bool> login({
    String? username,
    String? password,
  }) async {
    var url = Uri.parse('$baseUrl/{"username":"$username"}');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseData['result'].isEmpty) {
        return false;
      } else if (responseData['result'][0]['password'] != password) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> signup({
    String? username,
    String? password,
  }) async {
    var url = Uri.parse('$baseUrl/{"username":"$username"}');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseData['result'].isEmpty) {
        var url = Uri.parse(baseUrl);
        var body = jsonEncode([
          {'username': "$username", 'password': "$password"}
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
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> perbaruiProfile({
    String? username,
    String? password,
  }) async {
    var url = Uri.parse('$baseUrl/{"username":"$username"}');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseData['result'].isEmpty) {
        return false;
      } else {
        if (password != null) {
          var url = Uri.parse('$baseUrl/${responseData['result'][0]['id']}');
          var body = jsonEncode([
            {'username': "$username", 'password': "$password"}
          ]);
          var response_1 = await http.put(url,
              headers: {"Content-Type": "application/json"}, body: body);
          var responseData_2 = jsonDecode(response_1.body);
          if (response_1.statusCode == 200) {
            if (responseData_2['result'].isEmpty) {
              return false;
            } else {
              return true;
            }
          } else {
            return false;
          }
        } else {
          var url = Uri.parse(baseUrl);
          var body = jsonEncode([
            {'username': "$username"}
          ]);
          var response_2 = await http.put(url,
              headers: {"Content-Type": "application/json"}, body: body);
          var responseData_2 = jsonDecode(response_2.body);
          if (response_2.statusCode == 200) {
            if (responseData_2['result'].isEmpty) {
              return false;
            } else {
              return true;
            }
          } else {
            return false;
          }
        }
      }
    } else {
      return false;
    }
  }
}
