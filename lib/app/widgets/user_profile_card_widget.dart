import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:flutter/material.dart';

class UserProfileCardWidget extends StatelessWidget {
  final String? avatarUrl;
  final String title;
  final String? description;
  final IconData? rightIcon;
  final VoidCallback? onTap;
  final VoidCallback? onRightTap;

  const UserProfileCardWidget({
    super.key,
    this.avatarUrl,
    required this.title,
    this.description,
    this.rightIcon,
    this.onTap,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.08),
                theme.colorScheme.secondary.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.15),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ---------------- AVATAR ----------------
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: (avatarUrl == null || avatarUrl!.isEmpty)
                      ? Icon(Icons.person, size: 34, color: theme.primaryColor)
                      : null,
                ),
              ),

              SizedBox(width: AppSpacing.paddingS),

              // ---------------- TITLE + DESCRIPTION ----------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (description != null && description!.isNotEmpty) ...[
                      Text(
                        description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ---------------- RIGHT ICON (OPTIONAL) ----------------
              if (rightIcon != null)
                InkWell(
                  onTap: onRightTap,
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primaryColor.withOpacity(0.12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      rightIcon,
                      size: AppWidgetSize.iconXS,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}