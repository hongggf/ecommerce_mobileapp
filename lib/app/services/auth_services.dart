// import 'dart:convert';
// import 'package:ecommerce_urban/app/constants/constants.dart';
// import 'package:ecommerce_urban/modules/auth/auth_model.dart';
// import 'package:ecommerce_urban/modules/auth/login/login_request.dart';
// import 'package:ecommerce_urban/modules/auth/register/register_request.dart';
// import 'package:http/http.dart' as http;

// import 'package:ecommerce_urban/app/services/storage_services.dart';

// class AuthService {
//   // final String _baseUrl = 'http://10.0.2.2:8000/api';
//   final String _baseUrl = ApiConstants.baseUrl;
//   final StorageService _storage = StorageService();

//   Future<AuthModel> register(
//     String fullName,
//     String email,
//     String password,
//     String phone,
//   ) async {
//     try {
//       final request = RegisterRequest(
//         fullName: fullName,
//         email: email,
//         password: password,
//         phone: phone,
//       );

//       final response = await http.post(
//         Uri.parse('$_baseUrl/register'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode(request.toJson()),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final authModel = AuthModel.fromJson(jsonDecode(response.body));

//         // Save token and user data
//         if (authModel.token != null) {
//           await _storage.saveToken(authModel.token!);
//         }
//         await _storage.saveUserData(authModel.toJson());

//         return authModel;
//       }
//       throw Exception('Registration failed: ${response.reasonPhrase}');
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   // Future<AuthModel> login(String email, String password) async {
//   //   try {
//   //     final request = LoginRequest(
//   //       email: email,
//   //       password: password,
//   //     );
//   //     print('🔐 Login Request: ${request.toJson()}');
//   //     print('🔐 Login URL: $_baseUrl/login');

//   //     final response = await http.post(
//   //       Uri.parse('$_baseUrl/login'),
//   //       headers: {
//   //         'Content-Type': 'application/json',
//   //         'Accept': 'application/json',
//   //       },
//   //       body: jsonEncode(request.toJson()),
//   //     );
//   //     print('🔐 Login Response Status: ${response.statusCode}');
//   //     print('🔐 Login Response Body: ${response.body}');
//   //     if (response.statusCode == 200) {
//   //       final authModel = AuthModel.fromJson(jsonDecode(response.body));

//   //       // Save token and user data
//   //       if (authModel.token != null) {
//   //         await _storage.saveToken(authModel.token!);
//   //       }
//   //       await _storage.saveUserData(authModel.toJson());

//   //       return authModel;
//   //     }
//   //     throw Exception('Login failed: ${response.reasonPhrase}');
//   //   } catch (e) {
//   //     throw Exception(e.toString());
//   //   }
//   // }
//  Future<AuthModel> login(String email, String password) async {
//   try {
//     final request = LoginRequest(email: email, password: password);

//     final response = await http.post(
//       Uri.parse('$_baseUrl/login'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//       body: jsonEncode(request.toJson()),
//     );

//     print("Login Response: ${response.body}");

//     if (response.statusCode == 200) {
//       final authModel = AuthModel.fromJson(jsonDecode(response.body));

//       // Save token
//       if (authModel.token != null) {
//         await _storage.saveToken(authModel.token!);
//       }

//       // Save user data
//       await _storage.saveUserData(authModel.toJson());

//       // 🔥 FETCH ROLE HERE
//       if (authModel.userId != null) {
//         final role = await getUserRole(authModel.userId!);
//         print("Fetched Role: $role");

//         if (role != null) {
//           await _storage.saveRole(role);
//         }
//       }

//       return authModel;
//     }

//     throw Exception("Login failed");
//   } catch (e) {
//     throw Exception(e.toString());
//   }
// }

// Future<String?> getSavedRole() async {
//   return await _storage.getRole();
// }

// Future<String?> getUserRole(String userId) async {
//   final token = await _storage.getToken();
//   final role =await _storage.getRole();
//   final response = await http.get(
//     Uri.parse('$_baseUrl/userRole/$userId'),
//     headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     },
//   );

//   print("Role API Response: ${response.body}");

//   if (response.statusCode == 200) {
//     final List data = jsonDecode(response.body);

//     if (data.isNotEmpty) {
//       return data[0]['name']; // "admin"
//     }
//   }
// if (role != null) {
//   print('🔐 DEBUG - Saving role: $role');
//   await _storage.saveRole(role);
// }
//   return null;
// }

//  Future<void> logout() async {
//   try {
//     final token = await _storage.getToken();

//     if (token != null) {
//       await http.post(
//         Uri.parse('$_baseUrl/logout'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//     }

//     // Only clear auth-related data, NOT cart/order history
//     await _storage.clearAuthData();

//   } catch (e) {
//     await _storage.clearAuthData();
//     throw Exception(e.toString());
//   }
// }


//   Future<bool> isTokenValid() async {
//     final token = await _storage.getToken();
//     return token != null && token.isNotEmpty;
//   }

//   Future<String?> getToken() async {
//     return await _storage.getToken();
//   }

//   Future<String> getAuthHeader() async {
//     final token = await _storage.getToken();
//     return 'Bearer ${token ?? ''}';
//   }
// }
// lib/modules/auth/auth_service.dart


import 'package:ecommerce_urban/app/services/base_http_service.dart';
import 'package:ecommerce_urban/modules/auth/auth_model.dart';
import 'package:ecommerce_urban/modules/auth/login/login_request.dart';
import 'package:ecommerce_urban/modules/auth/register/register_request.dart';

import 'package:ecommerce_urban/app/services/storage_services.dart';


class AuthService extends BaseHttpService {
  final StorageService _storage = StorageService();

  /// Register new user
  Future<AuthModel> register(
    String fullName,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final request = RegisterRequest(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );

      // Use base class post method (no auth required)
      final response = await post(
        '/register',
        request.toJson(),
        requireAuth: false,
      );

      final authModel = AuthModel.fromJson(response);

      // Save token and user data
      if (authModel.token != null) {
        await _storage.saveToken(authModel.token!);
      }
      await _storage.saveUserData(authModel.toJson());

      return authModel;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Login user
  Future<AuthModel> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);

      // Use base class post method (no auth required)
      final response = await post(
        '/login',
        request.toJson(),
        requireAuth: false,
      );

      print("Login Response: $response");

      final authModel = AuthModel.fromJson(response);

      // Save token
      if (authModel.token != null) {
        await _storage.saveToken(authModel.token!);
      }

      // Save user data (including role)
      await _storage.saveUserData(authModel.toJson());

      // Save role separately for quick access
      if (authModel.role != null) {
        print("🔐 Saving Role: ${authModel.role}");
        await _storage.saveRole(authModel.role!);
      }

      return authModel;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Get saved role
  Future<String?> getSavedRole() async {
    return await _storage.getRole();
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final token = await _storage.getToken();

      if (token != null) {
        // Use base class post method (with auth)
        await post('/logout', {}, requireAuth: true);
      }
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      // Always clear auth data regardless of API success
      await _storage.clearAuthData();
    }
  }

  /// Check if token is valid
  Future<bool> isTokenValid() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Get token
  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  /// Get auth header
  Future<String> getAuthHeader() async {
    final token = await _storage.getToken();
    return 'Bearer ${token ?? ''}';
  }
}