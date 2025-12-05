// lib/modules/dashboard/admin/views/admin_products_view.dart
import 'package:ecommerce_urban/modules/admin_products/admin_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminProductsView extends StatelessWidget {
  final AdminProductsController controller =
      Get.find<AdminProductsController>();

  AdminProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Products Content Here'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/admin_add_product'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
