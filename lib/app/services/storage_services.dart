import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();

  static const _tokenKey = 'token';
  static const _roleKey = 'role';

  // TOKEN
  static void saveToken(String token) {
    _box.write(_tokenKey, token);
  }

  static String? get token => _box.read(_tokenKey);

  static void clearToken() {
    _box.remove(_tokenKey);
  }

  // ROLE
  static void saveRole(String role) {
    _box.write(_roleKey, role);
  }

  static String? get role => _box.read(_roleKey);

  static void clearRole() {
    _box.remove(_roleKey);
  }

  // CLEAR ALL
  static void clearAll() {
    _box.erase();
  }
}