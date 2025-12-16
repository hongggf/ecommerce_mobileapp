import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? description;
  final String? price;
  final VoidCallback? onAddToCartTap;
  final VoidCallback? onTap;

  const ProductCardWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.description,
    this.price,
    this.onAddToCartTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        // elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE + PRICE
            Flexible(
              flex: 4,
              child: Stack(
                children: [
                  _buildImage(theme),
                  if (price != null)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "\$$price",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// TITLE + DESCRIPTION
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (name != null)
                      Text(
                        name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (description != null && description!.isNotEmpty)
                      Text(
                        description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),

            /// ADD TO CART BUTTON
            Flexible(
              flex: 2,
              child: Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAddToCartTap,
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: colorScheme.onPrimary,
                    ),
                    label: Text(
                      "Add to Cart",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- IMAGE ----------------
  Widget _buildImage(ThemeData theme) {
    const double borderRadius = 14;

    /// Placeholder if no image or error
    Widget placeholder(IconData icon) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Icon(
          icon,
          size: 48,
          color: theme.iconTheme.color?.withOpacity(0.5),
        ),
      );
    }

    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder(Icons.image_outlined);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder(Icons.broken_image),
      ),
    );
  }
}