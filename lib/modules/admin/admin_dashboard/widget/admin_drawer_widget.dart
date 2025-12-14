import 'package:flutter/material.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';

class AdminDrawerWidget extends StatelessWidget {
  final Function(String route)? onTapItem;

  const AdminDrawerWidget({super.key, this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.lightBackground,
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              icon: Icons.dashboard,
              title: "Dashboard",
              onTap: () => onTapItem?.call("/dashboard"),
            ),
            _buildMenuItem(
              context,
              icon: Icons.shopping_cart,
              title: "Orders",
              onTap: () => onTapItem?.call("/orders"),
            ),
            _buildMenuItem(
              context,
              icon: Icons.inventory,
              title: "Products",
              onTap: () => onTapItem?.call("/products"),
            ),
            _buildMenuItem(
              context,
              icon: Icons.person,
              title: "Users",
              onTap: () => onTapItem?.call("/users"),
            ),
            const Spacer(),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: "Logout",
              onTap: () => onTapItem?.call("/logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Admin Name",
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "admin@domain.com",
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}