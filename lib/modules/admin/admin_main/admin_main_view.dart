import 'package:ecommerce_urban/modules/admin/admin_category/admin_category_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/admin_dashboard_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_inventory/admin_inventory_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_main/admin_main_controller.dart';
import 'package:ecommerce_urban/modules/admin/admin_user_detail/admin_user_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminMainView extends StatelessWidget {

  final AdminMainController controller = Get.put(AdminMainController());

  final List<Widget> pages = [
    AdminDashboardView(),
    AdminCategoryView(),
    AdminInventoryView(),
    AdminUserDetailView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits_sharp),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'User',
            ),
          ],
        ),
      ),
    );
  }
}