import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';

class ProductListScreen extends StatelessWidget {
  final String categoryName;

  ProductListScreen({super.key, required this.categoryName});

  final ProductController controller = Get.put(ProductController());

  // -------------------------
  // FILTER / SORT DIALOG
  // -------------------------

  // -------------------------
  // MAIN UI
  // -------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        actions: [
          IconButton(
              onPressed: _openSortFilterDialog,
              icon: Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadProducts,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.products.isEmpty) {
            return Center(
              child: Text("No products found", style: TextStyle(fontSize: 16)),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(12),
            itemCount: controller.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (_, index) {
              return _buildCard(controller.products[index]);
            },
          );
        }),
      ),
    );
  }

// void _openSortFilterDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: const Text("Sort & Filter"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text("Sort By"),
//             const SizedBox(height: 10),

//             // SORT OPTIONS
//             Obx(() => DropdownButton<String>(
//                   value: controller.selectedSort.value,
//                   items: [
//                     "Latest",
//                     "LowToHigh",
//                     "HighToLow",
//                   ]
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (value) {
//                     controller.applySort(value!);
//                   },
//                 )),

//             const SizedBox(height: 20),
//             const Text("Filter By"),
//             const SizedBox(height: 10),

//             // FILTER OPTIONS
//             Obx(() => DropdownButton<String>(
//                   value: controller.selectedFilter.value,
//                   items: [
//                     "None",
//                     "<50",
//                     "Nike",
//                   ]
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (value) {
//                     controller.applyFilter(value!);
//                   },
//                 )),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text("Close"),
//           )
//         ],
//       ),
//     );
//   }
  void _openSortFilterDialog() {
    Get.bottomSheet(
      Container(
        // Apply subtle padding and rounded top corners for a modern look
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColors.darkSurface
              : AppColors.lightBackground, // Use your app's background color
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Title/Header
            Text(
              "Sort & Filter",
              style: TextStyle(
                fontSize: AppFontSize.headlineSmall,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 25, thickness: 1), // Visual separator

            // 2. Sort Options Section
            Text(
              "Sort By",
              style: TextStyle(fontSize: AppFontSize.headlineSmall),
            ),
            const SizedBox(height: 10),

            // Custom Widget for Dropdown to keep UI clean and consistent
            _buildSortDropdown(),

            const SizedBox(height: 30),

            // 3. Filter Options Section
            Text(
              "Filter By",
              style: TextStyle(fontSize: AppFontSize.headlineSmall),
            ),
            const SizedBox(height: 10),

            // Custom Widget for Dropdown
            _buildFilterDropdown(),

            const SizedBox(height: 30),

            // 4. Action Button (optional, but good for closing)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Apply & Close",
                  style: TextStyle(fontSize: AppFontSize.headlineSmall),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper widget for a more styled dropdown
  Widget _buildSortDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300), // Subtle border
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true, // Make it take full width
            value: controller.selectedSort.value,
            items: [
              "Latest",
              "LowToHigh",
              "HighToLow",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              controller.applySort(value!);
              // Optional: Close sheet immediately on selection
              // Get.back();
            },
          ),
        ),
      ),
    );
  }

// Helper widget for a more styled dropdown
  Widget _buildFilterDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedFilter.value,
            items: [
              "None",
              "<50",
              "Nike",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              controller.applyFilter(value!);
              // Optional: Close sheet immediately on selection
              // Get.back();
            },
          ),
        ),
      ),
    );
  }

  // -------------------------
  // PRODUCT CARD UI
  // -------------------------
  Widget _buildCard(Map item) {
    return GestureDetector(
      onTap: () => Get.toNamed('/product_detail'),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              color: Colors.black12.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------
            // PRODUCT IMAGE + FAVORITE
            // --------------------------
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item["image"],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // ❤️ Favorite Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      Get.snackbar(
                        "Wishlist",
                        "${item["name"]} added to wishlist",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primary,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --------------------------
            // PRODUCT NAME + PRICE + ADD TO CART
            // --------------------------
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      item["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(height: 4),

                    // Price
                    Text(
                      "\$${item["price"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueAccent,
                      ),
                    ),

                    Spacer(),

                    // ADD TO CART BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar("Cart", "Added ${item["name"]} to cart");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
