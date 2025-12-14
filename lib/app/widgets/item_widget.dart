import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final IconData icon;
  final Color? iconBgColor;
  final String title;
  final String? subtitle;
  final Widget? rightWidget;
  final VoidCallback? onTapCard;

  const ItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconBgColor,
    this.rightWidget,
    this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTapCard,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingSM),
          child: Row(
            children: [

              /// Left Icon with background
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor ?? Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: AppWidgetSize.iconS,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: AppSpacing.paddingS),

              /// Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),

              /// Right Widget or Default Back Icon
              rightWidget ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppWidgetSize.iconXS,
                    color: Colors.grey,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}