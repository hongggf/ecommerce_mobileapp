import 'package:ecommerce_urban/api/model/cart_item_model.dart';
import 'package:flutter/material.dart';

class CartItemCardWidget extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onRemove;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CartItemCardWidget({
    super.key,
    required this.item,
    this.onRemove,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 110,
        child: Row(
          children: [
            /// PRODUCT IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: item.product.image != null && item.product.image!.isNotEmpty
                  ? Image.network(
                item.product.image!,
                width: 120,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(theme),
              )
                  : _placeholder(theme),
            ),

            const SizedBox(width: 12),

            /// DETAILS + ACTIONS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// PRODUCT NAME + DELETE ICON
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: onRemove,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete,
                              size: 20,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// PRODUCT DESCRIPTION
                    if (item.product.description != null && item.product.description!.isNotEmpty)
                      Text(
                        item.product.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),

                    const Spacer(),

                    /// PRICE + QUANTITY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// PRICE
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${item.product.price}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),

                        /// QUANTITY CONTROLS
                        Row(
                          children: [
                            _buildQuantityButton(Icons.remove, onDecrement, theme),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${item.quantity}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildQuantityButton(Icons.add, onIncrement, theme),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- QUANTITY BUTTON ----------------
  Widget _buildQuantityButton(IconData icon, VoidCallback? onTap, ThemeData theme) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: theme.iconTheme.color,
        ),
      ),
    );
  }

  /// ---------------- PLACEHOLDER ----------------
  Widget _placeholder(ThemeData theme) {
    return Container(
      width: 120,
      height: double.infinity,
      color: theme.colorScheme.surfaceVariant,
      child: Icon(
        Icons.image_outlined,
        size: 40,
        color: theme.iconTheme.color?.withOpacity(0.5),
      ),
    );
  }
}