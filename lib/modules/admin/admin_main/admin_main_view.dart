import 'package:ecommerce_urban/modules/admin/admin_main/admin_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminMainView extends StatelessWidget {

  final AdminMainController controller = Get.put(AdminMainController());

  final List<Widget> pages = [
    Text(""),
    Text(""),
    Text(""),
    Text("")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}