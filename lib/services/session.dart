import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final String usernameKey = 'username';

  static Future<bool> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  static Future<bool> hasUsername() async {
    final username = await getUsername();
    return username != null;
  }

  static Future<bool> clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(usernameKey);
  }

  static Future<String?> getReqUsername() async {
    try {
      String? username = await getUsername();
      return username;
    } catch (e) {
      return null;
    }
  }
}
