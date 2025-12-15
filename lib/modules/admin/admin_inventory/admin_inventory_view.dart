import 'dart:io';
import 'package:ecommerce_urban/modules/admin/admin_inventory/widget/admin_inventory_form.dart';
import 'package:ecommerce_urban/modules/admin/admin_inventory/widget/admin_product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'admin_inventory_controller.dart';

class AdminInventoryView extends StatelessWidget {

  final AdminInventoryController controller = Get.put(AdminInventoryController());

  AdminInventoryView({super.key});

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.prepareForm();
          AdminInventoryForm.show(controller: controller);
        },
        icon: const Icon(Icons.add),
        label: const Text("Create Product"),
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
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return ListView.separated(
            itemCount: controller.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final product = controller.products[index];
              return AdminProductItemWidget(
                product: product,
                onEdit: () {
                  controller.prepareForm(product: product);
                  AdminInventoryForm.show(controller: controller);
                },
                onDelete: () => controller.deleteProduct(product.id),
              );
            },
          );
        }),
    );
  }
}