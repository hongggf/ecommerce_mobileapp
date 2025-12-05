import 'package:ecommerce_urban/modules/user_mangement/user_model.dart';
import 'package:get/get.dart';

class UserManagementController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final users = <UserModel>[].obs;
  final filteredUsers = <UserModel>[].obs;
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // Fetch users (simulate API call)
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));

      // Mock data
      users.value = [
        UserModel(
          id: '1',
          name: 'John Doe',
          email: 'john.doe@example.com',
          role: 'Admin',
          status: 'Active',
          avatar: 'JD',
          joinedDate: DateTime(2023, 1, 15),
        ),
        UserModel(
          id: '2',
          name: 'Jane Smith',
          email: 'jane.smith@example.com',
          role: 'User',
          status: 'Active',
          avatar: 'JS',
          joinedDate: DateTime(2023, 3, 22),
        ),
        UserModel(
          id: '3',
          name: 'Mike Johnson',
          email: 'mike.j@example.com',
          role: 'Manager',
          status: 'Inactive',
          avatar: 'MJ',
          joinedDate: DateTime(2022, 11, 8),
        ),
        UserModel(
          id: '4',
          name: 'Sarah Williams',
          email: 'sarah.w@example.com',
          role: 'User',
          status: 'Active',
          avatar: 'SW',
          joinedDate: DateTime(2023, 5, 10),
        ),
        UserModel(
          id: '5',
          name: 'David Brown',
          email: 'david.b@example.com',
          role: 'User',
          status: 'Pending',
          avatar: 'DB',
          joinedDate: DateTime(2023, 8, 3),
        ),
      ];

      filteredUsers.value = users;
    } finally {
      isLoading.value = false;
    }
  }

  // Search users
  void searchUsers(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  // Filter users by status
  void filterByStatus(String status) {
    selectedFilter.value = status;
    applyFilters();
  }

  // Apply all filters
  void applyFilters() {
    filteredUsers.value = users.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          user.email.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesFilter = selectedFilter.value == 'All' || user.status == selectedFilter.value;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // Delete user
  void deleteUser(String userId) {
    users.removeWhere((user) => user.id == userId);
    applyFilters();
    Get.snackbar(
      'Success',
      'User deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Update user status
  void updateUserStatus(String userId, String newStatus) {
    final index = users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      users[index] = UserModel(
        id: users[index].id,
        name: users[index].name,
        email: users[index].email,
        role: users[index].role,
        status: newStatus,
        avatar: users[index].avatar,
        joinedDate: users[index].joinedDate,
      );
      applyFilters();
      Get.snackbar(
        'Success',
        'Status updated to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get stats
  int get totalUsers => users.length;
  int get activeUsers => users.where((u) => u.status == 'Active').length;
  int get inactiveUsers => users.where((u) => u.status == 'Inactive').length;
  int get pendingUsers => users.where((u) => u.status == 'Pending').length;
}
