import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String title;
  final String? subtitle;

  final IconData? icon;
  final Color? iconColor;

  final String confirmText;
  final String cancelText;

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialogWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Icon
            if (icon != null) _buildIcon(),

            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            /// Subtitle
            if (subtitle != null) ...[
              SizedBox(height: AppSpacing.paddingXS),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],

            const SizedBox(height: 24),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: onCancel,
                    child: Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: onConfirm,
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final Color color = iconColor ?? Colors.blue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: color.withOpacity(0.15),
        child: Icon(
          icon,
          size: 32,
          color: color,
        ),
      ),
    );
  }
}