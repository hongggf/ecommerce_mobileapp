import 'package:ecommerce_urban/app/controller/theme_controller.dart';
import 'package:ecommerce_urban/app/modules/profile/profile_controller.dart';
import 'package:ecommerce_urban/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 6),

              // Profile Header + Theme Switch
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    child: const Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(width: 16),

                  // Username
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.name.value.isNotEmpty
                            ? controller.name.value
                            : "Guest User",
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // 🌙 Theme Switch Button
                  // IconButton(
                  //   onPressed: () {
                  //     themeController.toggleTheme();
                  //   },
                  //   icon: Obx(()=>Icon(
                  //     isDark ? Icons.light_mode : Icons.dark_mode,
                  //     color: theme.colorScheme.onBackground,
                  //     size: 26,
                  //   ),)
                  // ),
                  Obx(() => IconButton(
                        icon: Icon(
                          themeController.isDarkMode.value
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        onPressed: themeController.toggleTheme,
                      )),
                  // Settings Button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings,
                        color: theme.colorScheme.onBackground),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Options
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(
                        context, Icons.location_on_outlined, "Address"),
                    _buildMenuItem(
                        context, Icons.credit_card_outlined, "Payment method"),
                    _buildMenuItem(
                        context, Icons.card_giftcard_outlined, "Voucher"),
                    _buildMenuItem(
                        context, Icons.favorite_border, "My Wishlist"),
                    _buildMenuItem(context, Icons.star_border, "Rate this app"),
                    _buildMenuItem(
                      context,
                      Icons.logout,
                      "Log out",
                      onTap: controller.logout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Menu Item
  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return Card(
      shadowColor: Colors.black12,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          icon,
        ),
        title: Text(
          title,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
