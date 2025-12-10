// lib/modules/search/search_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchItem {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;

  SearchItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
  });
}

class SearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool showResults = false.obs;
  final RxList<SearchItem> searchResults = <SearchItem>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxList<String> popularSearches = <String>[
    'Nike Shoes',
    'Adidas Jacket',
    'Running Shoes',
    'Casual Wear',
    'Sports Gear',
    'Designer Bags',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    recentSearches.assignAll(['Nike', 'Adidas', 'Casual']);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (value.isEmpty) {
      showResults.value = false;
      searchResults.clear();
    }
  }

  void onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      performSearch(value);
      _addToRecentSearches(value);
    }
  }

  void performSearch(String query) {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      final results = [
        SearchItem(id: '1', name: 'Nike $query', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100', price: 129.99, rating: 4.5),
        SearchItem(id: '2', name: 'Adidas $query', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100', price: 139.99, rating: 4.3),
        SearchItem(id: '3', name: 'Puma $query', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100', price: 99.99, rating: 4.2),
      ];
      searchResults.assignAll(results);
      showResults.value = true;
      isLoading.value = false;
    });
  }

  void searchFromChip(String item) {
    searchTextController.text = item;
    searchQuery.value = item;
    performSearch(item);
    _addToRecentSearches(item);
  }

  void _addToRecentSearches(String search) {
    if (!recentSearches.contains(search)) {
      recentSearches.insert(0, search);
    }
  }

  void removeRecentSearch(String search) {
    recentSearches.remove(search);
  }

  void clearAllRecentSearches() {
    recentSearches.clear();
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    searchResults.clear();
    showResults.value = false;
  }

  void showFilterBottomSheet() {
    Get.snackbar('Filter', 'Filter options coming soon', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}

// ============================================================================

