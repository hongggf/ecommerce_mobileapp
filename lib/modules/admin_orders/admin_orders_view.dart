import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOrdersView extends StatelessWidget {
  late final AdminOrdersController controller =
      Get.find<AdminOrdersController>();

  AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Orders Content Here'),
          ],
        ),
      ),
    );
  }
}
