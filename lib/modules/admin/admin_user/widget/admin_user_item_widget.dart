import 'dart:io';
import 'dart:typed_data';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:flutter/material.dart';

enum AvatarType { network, asset, memory, file }

class AdminUserItemWidget extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String role; // Admin or Customer
  final String? avatarPath;
  final AvatarType? avatarType;
  final Uint8List? memoryImage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminUserItemWidget({
    super.key,
    required this.name,
    required this.role,
    this.subtitle,
    this.avatarPath,
    this.avatarType,
    this.memoryImage,
    this.onEdit,
    this.onDelete,
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
                color: role.toLowerCase() == 'admin'
                    ? Colors.redAccent.withOpacity(0.2)
                    : Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                role.toUpperCase(),
                style: textTheme.bodySmall?.copyWith(
                  color: role.toLowerCase() == 'admin'
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.paddingM),

            /// Avatar + Info + Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatar(context),
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
                        Text(subtitle!, style: textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.edit,
                  color: Colors.green,
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

  /// ---------------- AVATAR ----------------
  Widget _buildAvatar(BuildContext context) {
    const double avatarSize = 48;

    return CircleAvatar(
      radius: avatarSize / 2,
      backgroundColor: _avatarBackgroundColor(),
      child: ClipOval(
        child: _buildAvatarImage(avatarSize),
      ),
    );
  }

  Widget _buildAvatarImage(double size) {
    /// ✅ NEW: handle empty string or null
    if (avatarPath == null || avatarPath!.isEmpty) {
      return _fallbackAvatar(size);
    }

    /// ✅ NEW: auto-detect network image
    if (avatarPath!.startsWith('http')) {
      return Image.network(
        avatarPath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackAvatar(size),
      );
    }

    /// Existing behavior
    if (avatarType == null) {
      return _fallbackAvatar(size);
    }

    switch (avatarType!) {
      case AvatarType.asset:
        return Image.asset(
          avatarPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackAvatar(size),
        );

      case AvatarType.memory:
        if (memoryImage == null) return _fallbackAvatar(size);
        return Image.memory(
          memoryImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackAvatar(size),
        );

      case AvatarType.file:
        return Image.file(
          File(avatarPath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackAvatar(size),
        );

      case AvatarType.network:
        return Image.network(
          avatarPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackAvatar(size),
        );
    }
  }

  /// ✅ NEW: Colored background for fallback avatar
  Color _avatarBackgroundColor() {
    if (avatarPath == null || avatarPath!.isEmpty) {
      return Colors.blueGrey;
    }
    return Colors.grey[300]!;
  }

  Widget _fallbackAvatar(double size) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "?",
        style: TextStyle(
          fontSize: size * 0.5,
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