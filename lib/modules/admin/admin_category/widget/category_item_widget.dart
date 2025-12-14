import 'package:flutter/material.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';

class AdminCategoryItemWidget extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String status;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final IconData? icon;

  const AdminCategoryItemWidget({
    super.key,
    required this.name,
    this.subtitle,
    this.status = "Active",
    this.onEdit,
    this.onDelete,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Status label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status.toLowerCase() == 'active'
                    ? Colors.greenAccent.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status.toUpperCase(),
                style: textTheme.bodySmall?.copyWith(
                  color: status.toLowerCase() == 'active'
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.paddingM),

            /// Icon + Title/Subtile + Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIcon(context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.edit,
                  color: Colors.blue,
                  onTap: onEdit,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- ICON ----------------
  Widget _buildIcon(BuildContext context) {
    const double iconSize = 48;

    return CircleAvatar(
      radius: iconSize / 2,
      backgroundColor: Colors.grey[300],
      child: icon != null
          ? Icon(icon, size: 28, color: Colors.black54)
          : Text(
        name.isNotEmpty ? name[0].toUpperCase() : "?",
        style: TextStyle(
          fontSize: iconSize * 0.5,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ---------------- ACTION BUTTON ----------------
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}