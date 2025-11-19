import 'package:ecommerce_urban/modules/bottom_nav/bottom_controller.dart';
import 'package:ecommerce_urban/modules/category/category_screen.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/customer_screen.dart';
import 'package:ecommerce_urban/modules/wishlist/wishlist_screen.dart';
import 'package:ecommerce_urban/modules/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNav extends StatelessWidget {
  final BottomNavController controller = Get.find();

  final List<Widget> pages = [
    CustomerScreen(),
    CategoryScreen(),
    WishlistScreen(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
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
                    icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category_outlined), label: "Category"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: "Wishlist"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile"),
              ],
            ),
          ),
        );
      },
    );
  }
}
