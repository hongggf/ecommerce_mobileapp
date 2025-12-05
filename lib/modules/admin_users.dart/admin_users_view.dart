import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminUsersView extends StatelessWidget {
 late final AdminUsersController controller = Get.find<AdminUsersController>();

  AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Users Content Here'),
          ],
        ),
      ),
     
    );
  }
}