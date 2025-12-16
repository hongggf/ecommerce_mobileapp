import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  const BannerWidget({
    super.key,
    this.imageUrl,
    this.height = 200,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          height: height,
          width: double.infinity,
          color: theme.colorScheme.surfaceVariant,
          child: _buildImage(theme),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    /// If no image URL → show default placeholder
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _defaultImage(theme);
    }

    /// Network image
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _defaultImage(theme),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _defaultImage(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: theme.iconTheme.color?.withOpacity(0.6),
          ),
          const SizedBox(height: 8),
          Text(
            "No Image",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}