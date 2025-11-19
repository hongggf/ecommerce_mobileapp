import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:flutter/material.dart';

enum IconDirection { column, row }

class KPIItem {
  final IconData icon;
  final Color? iconBgColor;
  final String title;
  final String value;
  final String? result;
  final VoidCallback? onTap;

  KPIItem({
    required this.icon,
    this.iconBgColor,
    required this.title,
    required this.value,
    this.result,
    this.onTap,
  });
}

class AdminKPICardWidget extends StatelessWidget {
  final List<KPIItem> items;
  final double spacing;
  final double runSpacing;
  final int maxItemsPerRow;
  final IconDirection iconDirection;

  const AdminKPICardWidget({
    super.key,
    required this.items,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.maxItemsPerRow = 3,
    this.iconDirection = IconDirection.column,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double itemWidth = (maxWidth - spacing * (maxItemsPerRow - 1)) / maxItemsPerRow;

            return Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              children: items.map((item) {
                return SizedBox(
                  width: itemWidth,
                  child: _buildItem(context, item),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, KPIItem item) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: iconDirection == IconDirection.column
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(item, theme),
            _buildTexts(item, theme),
          ],
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(item, theme),
            SizedBox(width: AppSpacing.paddingS),
            Expanded(child: _buildTexts(item, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(KPIItem item, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: item.iconBgColor ?? theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(AppSpacing.paddingSM),
      child: Icon(
        item.icon,
        size: AppWidgetSize.iconSM,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildTexts(KPIItem item, ThemeData theme) {
    return Column(
      crossAxisAlignment: iconDirection == IconDirection.row
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          item.title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: iconDirection == IconDirection.row ? TextAlign.start : TextAlign.center,
        ),
        Text(
          item.value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: iconDirection == IconDirection.row ? TextAlign.start : TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (item.result != null && item.result!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            item.result!,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
            textAlign: iconDirection == IconDirection.row ? TextAlign.start : TextAlign.center,
          ),
        ],
      ],
    );
  }
}