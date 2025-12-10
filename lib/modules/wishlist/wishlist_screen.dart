import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/wishlist/wishlist_controller.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: controller.wishlistItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62, // FIX OVERFLOW
            ),
            itemBuilder: (context, index) {
              return _modernCard(context, controller.wishlistItems[index]);
            },
          ),
        );
      }),
    );
  }

  // ---------------- EMPTY -------------------

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 90, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Your wishlist is empty",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Add items you love",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Start Shopping",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // ---------------- MODERN CARD -------------------

  Widget _modernCard(BuildContext context, WishlistItem item) {
    return GestureDetector(
      onTap: () {
        Get.offNamed('/product_detail');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 12,
              color: Colors.black12.withOpacity(0.06),
            ),
          ],
        ),
        child: Column(
          children: [
            // ---------------- IMAGE ----------------
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.network(
                    item.image,
                    height: 150, // reduced to prevent overflow
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // HEART ICON
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () {
                        controller.toggleWishlist(item.id);

                        Get.snackbar(
                          "Wishlist",
                          backgroundColor: AppColors.primary,
                          item.isWishlisted.value
                              ? "Added to wishlist"
                              : "Removed from wishlist",
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6)
                          ],
                        ),
                        child: Icon(
                          item.isWishlisted.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            // ---------------- DETAILS (Expanded prevents overflow) ----------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 4),

                    // PRICE
                    Text(
                      "\$${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 6),

                    // RATING TAG
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 14, color: Colors.amber),
                              const SizedBox(width: 3),
                              Text("${item.rating}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(), // pushes button down safely

                    // ADD TO CART BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.addToCart(item.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Add to Cart",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
