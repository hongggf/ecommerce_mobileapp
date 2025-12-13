import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_controller.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/create_new_user_screen.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/widget/assignment.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/widget/role_tab_widget.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/widget/users_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Management'),
          backgroundColor: AppColors.primary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => Get.to(() => const CreateUserScreen()),
              tooltip: 'Create New User',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Roles'),
              Tab(text: 'Assignment'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: const TabBarView(
          children: [
            UsersTab(),
            RolesTab(),
            AssignmentTab(),
          ],
        ),
      ),
    );
  }
}