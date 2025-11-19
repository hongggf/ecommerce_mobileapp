import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:flutter/material.dart';

class CardItem {
  final IconData icon;
  final Color? iconBgColor;
  final String title;
  final String? description;
  final IconData? rightIcon;
  final VoidCallback? onTapRightIcon;
  final VoidCallback? onTapCard;

  CardItem({
    required this.icon,
    this.iconBgColor,
    required this.title,
    this.description,
    this.rightIcon,
    this.onTapRightIcon,
    this.onTapCard,
  });
}

class ItemWidget extends StatelessWidget {
  final CardItem item;
  final double padding;

  const ItemWidget({
    super.key,
    required this.item,
    this.padding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: item.onTapCard,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left icon with background
              Container(
                decoration: BoxDecoration(
                  color: item.iconBgColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  item.icon,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(width: AppSpacing.paddingSM),

              // Title & description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.description != null && item.description!.isNotEmpty)
                    if (item.description != null && item.description!.isNotEmpty)
                      Text(
                        item.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),

              // Optional right icon
              if (item.rightIcon != null) ...[
                const SizedBox(width: 12),
                InkWell(
                  onTap: item.onTapRightIcon,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      item.rightIcon,
                      size: AppWidgetSize.iconXS,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}