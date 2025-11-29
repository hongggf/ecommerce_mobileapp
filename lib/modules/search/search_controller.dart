// lib/app/modules/search/controllers/search_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  
  final RxList<Product> searchResults = <Product>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxList<String> popularSearches = <String>[
    'Laptop',
    'Smartphone',
    'Headphones',
    'Watch',
    'Camera',
    'Shoes',
  ].obs;
  
  final RxBool isLoading = false.obs;
  final RxBool showResults = false.obs;
  final RxString searchQuery = ''.obs;
  
  // Filter options
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedPriceRange = 'All'.obs;
  final RxString selectedRating = 'All'.obs;
  final RxString sortBy = 'relevance'.obs;

  // SharedPreferences key
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 10;

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      showResults.value = false;
      searchResults.clear();
    } else {
      showResults.value = true;
      _performSearch(query);
    }
  }

  void onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _addToRecentSearches(query);
      _performSearch(query);
    }
  }

  void _performSearch(String query) {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      // Mock search results - replace with actual API call
      searchResults.value = _getMockSearchResults(query);
      isLoading.value = false;
    });
  }

  void searchFromChip(String query) {
    searchTextController.text = query;
    searchQuery.value = query;
    onSearchSubmitted(query);
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    searchResults.clear();
    showResults.value = false;
  }

  void removeRecentSearch(String query) {
    recentSearches.remove(query);
    _saveRecentSearches();
  }

  void clearAllRecentSearches() {
    recentSearches.clear();
    _saveRecentSearches();
  }

  // SharedPreferences Methods
  Future<void> _addToRecentSearches(String query) async {
    // Remove if already exists
    if (recentSearches.contains(query)) {
      recentSearches.remove(query);
    }
    
    // Add to the beginning
    recentSearches.insert(0, query);
    
    // Keep only the last N searches
    if (recentSearches.length > _maxRecentSearches) {
      recentSearches.removeRange(_maxRecentSearches, recentSearches.length);
    }
    
    await _saveRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? searchesJson = prefs.getString(_recentSearchesKey);
      
      if (searchesJson != null) {
        final List<dynamic> decoded = json.decode(searchesJson);
        recentSearches.value = decoded.cast<String>();
      }
    } catch (e) {
      print('Error loading recent searches: $e');
    }
  }

  Future<void> _saveRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(recentSearches);
      await prefs.setString(_recentSearchesKey, encoded);
    } catch (e) {
      print('Error saving recent searches: $e');
    }
  }

  void showFilterBottomSheet() {
    Get.bottomSheet(
      FilterBottomSheet(),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void applyFilters() {
    _performSearch(searchQuery.value);
    Get.back();
  }

  void resetFilters() {
    selectedCategory.value = 'All';
    selectedPriceRange.value = 'All';
    selectedRating.value = 'All';
    sortBy.value = 'relevance';
  }

  List<Product> _getMockSearchResults(String query) {
    // Mock data - replace with actual API response
    return List.generate(
      8,
      (index) => Product(
        id: index.toString(),
        name: 'Product ${index + 1} - $query',
        price: (index + 1) * 10.99,
        rating: 4.0 + (index % 5) * 0.2,
        image: 'assets/images/product${index + 1}.jpg',
        category: index % 2 == 0 ? 'Electronics' : 'Fashion',
      ),
    );
  }
}

// Mock Product Model
class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
  });
}

// Filter Bottom Sheet Widget
class FilterBottomSheet extends GetView<SearchController> {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: controller.resetFilters,
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8,
                children: ['relevance', 'price_low', 'price_high', 'rating']
                    .map((sort) => ChoiceChip(
                          label: Text(_getSortLabel(sort)),
                          selected: controller.sortBy.value == sort,
                          onSelected: (selected) {
                            if (selected) controller.sortBy.value = sort;
                          },
                        ))
                    .toList(),
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'relevance':
        return 'Relevance';
      case 'price_low':
        return 'Price: Low to High';
      case 'price_high':
        return 'Price: High to Low';
      case 'rating':
        return 'Rating';
      default:
        return sort;
    }
  }
}