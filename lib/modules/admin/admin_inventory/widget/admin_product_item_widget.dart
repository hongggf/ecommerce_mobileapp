import 'package:flutter/material.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/api/model/product_model.dart';

class AdminProductItemWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminProductItemWidget({
    super.key,
    required this.product,
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
                color: product.status.toLowerCase() == 'active'
                    ? Colors.greenAccent.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.status.toUpperCase(),
                style: textTheme.bodySmall?.copyWith(
                  color: product.status.toLowerCase() == 'active'
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.paddingM),

            /// Product info row: Image + Details + Actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProductImage(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Category: ${product.category.name ?? 'N/A'}",
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "\$${product.price}",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.edit,
                  color: Colors.blue,
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

  /// ---------------- PRODUCT IMAGE ----------------
  Widget _buildProductImage() {
    const double size = 48;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: product.image.isNotEmpty
          ? Image.network(
        product.image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(size),
      )
          : _placeholderImage(size),
    );
  }

  /// Placeholder when image is null or fails to load
  Widget _placeholderImage(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.white),
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