import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';
import 'package:ecommerce_urban/modules/user/user_search/user_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';

class UserSearchView extends StatelessWidget {

  final UserSearchController controller = Get.put(UserSearchController());

  UserSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchProducts,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: AppSpacing.marginM),
            _buildSortDropdown(),
            _buildProductsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Search by product name",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        controller.search.value = value;
        controller.fetchProducts();
      },
    );
  }

  Widget _buildSortDropdown() {
    return Obx(() => DropdownButton<String>(
      value: controller.sort.value.isEmpty ? "all" : controller.sort.value,
      hint: const Text("Sort"),
      items: const [
        DropdownMenuItem(value: "all", child: Text("All")),
        DropdownMenuItem(value: "price_asc", child: Text("Price ↑")),
        DropdownMenuItem(value: "price_desc", child: Text("Price ↓")),
        DropdownMenuItem(value: "name_asc", child: Text("Name A-Z")),
        DropdownMenuItem(value: "name_desc", child: Text("Name Z-A")),
      ],
      onChanged: (value) {
        if (value != null) {
          controller.sort.value = value;
          controller.fetchProducts();
        }
      },
    ));
  }

  Widget _buildProductsList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.products.isEmpty) {
          return const Center(
            child: Text("No products found"),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ProductCardWidget(
              name: product.name.toString(),
              description: product.description.toString(),
              imageUrl: product.image.toString(),
              price: product.price.toString(),
              onAddToCartTap: (){},
            );
          },
        );
      }),
    );
  }
}