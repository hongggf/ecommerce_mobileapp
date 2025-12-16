import 'package:ecommerce_urban/modules/user/user_home/user_home_view.dart';
import 'package:ecommerce_urban/modules/user/user_main/user_main_controller.dart';
import 'package:ecommerce_urban/modules/user/user_search/user_search_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainView extends StatelessWidget {

  final UserMainController controller = Get.put(UserMainController());

  final List<Widget> pages = [
    UserHomeView(),
    UserSearchView(),
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
              icon: Icon(Icons.home_max),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
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