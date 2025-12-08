import 'dart:convert';
import 'package:ecommerce_urban/modules/admin_users.dart/model/role_model.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';

class UserService {
  final String _baseUrl = ApiConstants.baseUrl;
  final StorageService _storage = StorageService();

  Future<Map<String, String>> get _headers async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // ==================== USER CRUD ====================

 Future<List<UserModel>> fetchUsers() async {
  try {
    final headers = await _headers;
    print('📡 Fetching users from: $_baseUrl/users');

    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: headers,
    ).timeout(const Duration(seconds: 15));

    print('📥 Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('✅ Users loaded: ${jsonData.length}');
      
      // Create list to store users with their roles
      final List<UserModel> usersWithRoles = [];
      
      // Fetch roles for each user
      for (var userData in jsonData) {
        final user = UserModel.fromJson(userData);
        print('📥 Fetching roles for: ${user.name}');
        
        try {
          // Fetch roles for this specific user
          final userRoles = await listUserRoles(user.id);
          final roleNames = userRoles.map((r) => r.name).toList();
          
          print('✅ ${user.name} has roles: $roleNames');
          
          // Create user with roles
          final userWithRoles = UserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            avatar: user.avatar,
            status: user.status,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
            roles: roleNames.isNotEmpty ? roleNames : [],
          );
          
          usersWithRoles.add(userWithRoles);
        } catch (e) {
          print('⚠️ Could not fetch roles for ${user.name}: $e');
          // Add user without roles if role fetch fails
          usersWithRoles.add(user);
        }
      }
      
      return usersWithRoles;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching users: $e');
    throw Exception('Network error: $e');
  }
}

  Future<UserModel?> fetchUserById(String userId) async {
    try {
      final headers = await _headers;
      print('📡 Fetching user: $_baseUrl/users/$userId');

      final response = await http.get(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ User loaded');
        return UserModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('❌ Error fetching user: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<UserModel?> createUser(Map<String, dynamic> userData) async {
    try {
      final headers = await _headers;
      print('📡 Creating user');
      
      // Convert field names to match backend
      final backendData = {
        'full_name': userData['name'] ?? userData['full_name'],
        'email': userData['email'],
        'phone': userData['phone'],
        'password': userData['password'],
        'status': userData['status'] ?? 'active',
      };
      
      print('📦 Request body: ${json.encode(backendData)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: headers,
        body: json.encode(backendData),
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('✅ User created');
        return UserModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Failed to create user: ${errorData['message'] ?? response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating user: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      final headers = await _headers;
      print('📡 Updating user: $_baseUrl/users/$userId');
      print('📦 Request body: ${json.encode(userData)}');

      final response = await http.put(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: headers,
        body: json.encode(userData),
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ User updated');
        return true;
      } else if (response.statusCode == 422) {
        // Validation error
        final errorData = json.decode(response.body);
        print('❌ Validation Error: ${errorData['message']}');
        print('❌ Errors: ${errorData['errors']}');
        throw Exception('Validation error: ${errorData['message']}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        final errorData = json.decode(response.body);
        print('❌ Error: ${errorData['message']}');
        throw Exception('Failed to update user: ${response.statusCode} - ${errorData['message']}');
      }
    } catch (e) {
      print('❌ Error updating user: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final headers = await _headers;
      print('📡 Deleting user: $_baseUrl/users/$userId');

      final response = await http.delete(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ User deleted');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting user: $e');
      throw Exception('Network error: $e');
    }
  }

  // ==================== ROLE CRUD ====================

  Future<List<RoleModel>> fetchRoles() async {
    try {
      final headers = await _headers;
      print('📡 Fetching roles from: $_baseUrl/roles');

      final response = await http.get(
        Uri.parse('$_baseUrl/roles'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Roles loaded: ${jsonData.length}');
        return jsonData.map((json) => RoleModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load roles: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching roles: $e');
      throw Exception('Network error: $e');
    }
  }
Future<List<UserModel>> fetchUsersWithRoles() async {
  try {
    final headers = await _headers;
    print('📡 Fetching users from: $_baseUrl/users');

    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: headers,
    ).timeout(const Duration(seconds: 15));

    print('📥 Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('✅ Users loaded: ${jsonData.length}');
      
      // Convert to UserModel first
      final users = jsonData
          .map((json) => UserModel.fromJson(json))
          .toList();
      
      // Fetch all roles in parallel for better performance
      final futures = users.map((user) async {
        try {
          final userRoles = await listUserRoles(user.id);
          final roleNames = userRoles.map((r) => r.name).toList();
          
          // Return user with roles
          return UserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            avatar: user.avatar,
            status: user.status,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
            roles: roleNames.isNotEmpty ? roleNames : [],
          );
        } catch (e) {
          print('⚠️ Could not fetch roles for ${user.name}: $e');
          return user; // Return without roles if fetch fails
        }
      });
      
      // Wait for all role fetches to complete
      final usersWithRoles = await Future.wait(futures);
      
      // Print results
      for (var user in usersWithRoles) {
        print('👤 ${user.name}: ${user.roles}');
      }
      
      return usersWithRoles;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching users: $e');
    throw Exception('Network error: $e');
  }
}
  Future<RoleModel?> createRole(Map<String, dynamic> roleData) async {
    try {
      final headers = await _headers;
      print('📡 Creating role');

      final response = await http.post(
        Uri.parse('$_baseUrl/roles'),
        headers: headers,
        body: json.encode(roleData),
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('✅ Role created');
        return RoleModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to create role: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating role: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateRole(String roleId, Map<String, dynamic> roleData) async {
    try {
      final headers = await _headers;
      print('📡 Updating role: $_baseUrl/roles/$roleId');

      final response = await http.put(
        Uri.parse('$_baseUrl/roles/$roleId'),
        headers: headers,
        body: json.encode(roleData),
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Role updated');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to update role: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error updating role: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteRole(String roleId) async {
    try {
      final headers = await _headers;
      print('📡 Deleting role: $_baseUrl/roles/$roleId');

      final response = await http.delete(
        Uri.parse('$_baseUrl/roles/$roleId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Role deleted');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to delete role: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting role: $e');
      throw Exception('Network error: $e');
    }
  }

  // ==================== USER ROLE CRUD ====================

  Future<bool> assignRole(String userId, String roleId) async {
    try {
      final headers = await _headers;
      print('📡 Assigning role to user');
      print('📦 Request body: {"user_id": "$userId", "role_id": "$roleId"}');

      final response = await http.post(
        Uri.parse('$_baseUrl/user-roles/assign'),
        headers: headers,
        body: json.encode({
          'user_id': userId,
          'role_id': roleId,
        }),
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Role assigned');
        return true;
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        print('❌ Bad Request: ${errorData['message']}');
        throw Exception('Bad request: ${errorData['message']}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        final errorData = json.decode(response.body);
        print('❌ Error: ${errorData['message']}');
        throw Exception('Failed to assign role: ${response.statusCode} - ${errorData['message']}');
      }
    } catch (e) {
      print('❌ Error assigning role: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> removeRole(String userId, String roleId) async {
    try {
      final headers = await _headers;
      print('📡 Removing role from user');

      final response = await http.post(
        Uri.parse('$_baseUrl/user-roles/remove'),
        headers: headers,
        body: json.encode({
          'user_id': userId,
          'role_id': roleId,
        }),
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Role removed');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to remove role: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error removing role: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<List<RoleModel>> listUserRoles(String userId) async {
    try {
      final headers = await _headers;
      print('📡 Fetching user roles');

      final response = await http.get(
        Uri.parse('$_baseUrl/user-roles/user/$userId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ User roles loaded');
        return jsonData.map((json) => RoleModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load roles: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching user roles: $e');
      throw Exception('Network error: $e');
    }
  }
}