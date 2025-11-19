import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool showWishlist;
  final bool isWishlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

  const ProductCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.showWishlist = false,
    this.isWishlisted = false,
    this.onTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Image + Wishlist Button
            Stack(
              children: [
                // Image
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Wishlist Icon (Optional)
                if (showWishlist)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted
                              ? Colors.red
                              : Colors.grey.shade700,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            /// Title & Description
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}