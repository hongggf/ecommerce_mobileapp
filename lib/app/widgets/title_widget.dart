import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onIconTap;

  const TitleWidget({
    super.key,
    required this.title,
    this.icon,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title text
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Optional icon
        if (icon != null)
          InkWell(
            onTap: onIconTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                size: theme.iconTheme.size ?? 24,
                color: theme.iconTheme.color ?? theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}