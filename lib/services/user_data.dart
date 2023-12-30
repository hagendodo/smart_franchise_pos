import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  static Future<void> storeUserData(
      String id, Map<String, dynamic> userData) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString('authStatus', 'logged');
    await preferences.setString('userId', id);
    await preferences.setString('username', userData['username']);
    await preferences.setString('role', userData['role']);
    await preferences.setString('kodeToko', userData['kodeToko']);
    await preferences.setString('namaToko', userData['namaToko']);
    await preferences.setString('kodeCabang', userData['kodeCabang'] ?? "");
    await preferences.setString('namaCabang', userData['namaCabang'] ?? "");
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final Map<String, dynamic> userData = {
      'authStatus': preferences.getString('authStatus'),
      'userId': preferences.getString('userId'),
      'username': preferences.getString('username'),
      'role': preferences.getString('role'),
      'kodeToko': preferences.getString('kodeToko'),
      'namaToko': preferences.getString('namaToko'),
      'kodeCabang': preferences.getString('kodeCabang'),
      'namaCabang': preferences.getString('namaCabang'),
    };

    return userData;
  }

  static Future<void> clearUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.clear();
  }
}
