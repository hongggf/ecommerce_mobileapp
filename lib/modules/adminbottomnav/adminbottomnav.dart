import 'package:ecommerce_urban/modules/admin_analystics/admin_analystics_view.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_order_list_screen.dart';
import 'package:ecommerce_urban/modules/admin_products/admin_products_view.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_view.dart';
import 'package:ecommerce_urban/modules/adminbottomnav/adminbottom_controller.dart';

import 'package:ecommerce_urban/modules/dashboard/admin/admin_screen.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class Adminbottomnav extends StatelessWidget {
 late final AdminbottomController controller = Get.find();

  final List<Widget> pages = [
    AdminScreen(),
    AdminProductsView(),
    AdminOrderListScreen(),
    AdminUsersView(),
    AdminAnalyticsView(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminbottomController>(
      builder: (_) {
        return Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedIndex.value,
              onTap: controller.onItemTapped,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: "Dashboard",
                    tooltip: "Home Dashboard"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.inventory_2),
                    label: "Products",
                    tooltip: "Manage Products"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_checkout),
                    label: "Orders",
                    tooltip: "Manage Orders"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: "users",
                    tooltip: "Manage Users"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics),
                    label: "Analytics",
                    tooltip: "View Analytics"),
              ],
            ),
          ),
        );
      },
    );
  }
}
