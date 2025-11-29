// lib/app/modules/search/views/search_screen.dart

import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/search/search_controller.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: controller.showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // ---- SEARCH BAR (fixed – only one) ----
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSearchBar(),
          ),

          // ---- SEARCH RESULTS & RECENT & LOADING ----
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.searchQuery.isEmpty) {
                return _buildRecentAndPopular();
              }

              if (controller.showResults.isTrue) {
                return _buildSearchResults();
              }

              return const SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // SEARCH BAR
  // ========================================================
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),

          // ---- TEXT FIELD ----
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              onChanged: controller.onSearchChanged,
              onSubmitted: controller.onSearchSubmitted,
              decoration: const InputDecoration(
                hintText: "Search products...",
                border: InputBorder.none,
              ),
            ),
          ),

          Obx(() => controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox()),
        ],
      ),
    );
  }

  // ========================================================
  // RECENT + POPULAR SEARCHES
  // ========================================================
  Widget _buildRecentAndPopular() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recent Searches
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() => controller.recentSearches.isNotEmpty
                ? TextButton(
                    onPressed: controller.clearAllRecentSearches,
                    child: const Text("Clear All"),
                  )
                : const SizedBox()),
          ],
        ),
        const SizedBox(height: 10),

        Obx(() => Wrap(
              spacing: 8,
              children: controller.recentSearches
                  .map((item) => Chip(
                        label: Text(item),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => controller.removeRecentSearch(item),
                        backgroundColor: Colors.grey.shade200,
                      ))
                  .toList(),
            )),
        const SizedBox(height: 30),

        // Popular Searches
        const Text(
          'Popular Searches',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Obx(() => Wrap(
              spacing: 8,
              children: controller.popularSearches
                  .map((item) => ActionChip(
                        label: Text(item),
                        onPressed: () => controller.searchFromChip(item),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  // ========================================================
  // SEARCH RESULTS
  // ========================================================
  Widget _buildSearchResults() {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final product = controller.searchResults[index];
            return _buildProductTile(product);
          },
        ));
  }

  // ========================================================
  // PRODUCT TILE
  // ========================================================
  Widget _buildProductTile(Product product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(product.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            Text(product.rating.toStringAsFixed(1)),
          ],
        ),
        onTap: () {
          // navigate to product detail if you want
        },
      ),
    );
  }
}
