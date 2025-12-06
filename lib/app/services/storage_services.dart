// import 'package:shared_preferences/shared_preferences.dart';

// class StorageService {
//   static const _keyUsername = 'username';

//   Future<void> saveUsername(String username) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyUsername, username);
//   }

//   Future<String?> getUsername() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_keyUsername);
//   }

//   Future<void> clear() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  // Token management
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // User data management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userDataKey);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

// ===========================
  // CLEAR ONLY AUTH DATA
  // (token, user info, role)
  // ===========================
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove('user_role');
  }

  // ===========================
  // CLEAR ALL DATA
  // Only use if you want to wipe everything
  // ===========================
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  // // Clear all
  // Future<void> clear() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_tokenKey);
  //   await prefs.remove(_userDataKey);
  // }
}
