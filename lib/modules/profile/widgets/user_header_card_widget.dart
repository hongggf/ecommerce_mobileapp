import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHeaderCardWidget extends StatelessWidget {
  final RxString name;
  final List<UserHeaderRightIcon>? rightIcons;

  const UserHeaderCardWidget({
    super.key,
    required this.name,
    this.rightIcons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ---------------- Avatar ----------------
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.7),
                    AppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 32, color: AppColors.primary),
              ),
            ),

            const SizedBox(width: 16),

            // ---------------- Username ----------------
            Expanded(
              child: Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.value.isNotEmpty ? name.value : "Guest User",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Welcome back!",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ---------------- Right Icons ----------------
            if (rightIcons != null)
              Row(
                children: rightIcons!.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: item.onTap,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: Icon(
                          item.icon,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

/// Model for right icon
class UserHeaderRightIcon {
  final IconData icon;
  final VoidCallback? onTap;

  UserHeaderRightIcon({required this.icon, this.onTap});
}