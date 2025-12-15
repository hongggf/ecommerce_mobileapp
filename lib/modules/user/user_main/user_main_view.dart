import 'package:ecommerce_urban/modules/user/user_main/user_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainView extends StatelessWidget {

  final UserMainController controller = Get.put(UserMainController());

  final List<Widget> pages = [
    Text(""),
    Text(""),
    Text(""),
    Text(""),
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