import 'package:get/get.dart';

class ProductController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;

  // Sorting & Filtering State
  RxString selectedSort = "Latest".obs;
  RxString selectedFilter = "None".obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading(true);

    await Future.delayed(const Duration(seconds: 1)); // simulate fetch

    products.assignAll([
      {"image": "https://picsum.photos/300?1", "name": "Air Max", "price": 79.99},
      {"image": "https://picsum.photos/300?2", "name": "Sneaker X", "price": 49.99},
      {"image": "https://picsum.photos/300?3", "name": "Sandals", "price": 25.99},
      {"image": "https://picsum.photos/300?4", "name": "Leather Bag", "price": 120.00},
    ]);

    isLoading(false);
  }

  // -------------------------
  // SORT LOGIC
  // -------------------------
  void applySort(String value) {
    selectedSort.value = value;

    if (value == "LowToHigh") {
      products.sort((a, b) => a["price"].compareTo(b["price"]));
    } else if (value == "HighToLow") {
      products.sort((a, b) => b["price"].compareTo(a["price"]));
    }
  }

  // -------------------------
  // FILTER LOGIC
  // -------------------------
  void applyFilter(String value) {
    selectedFilter.value = value;

    loadProducts(); // refresh (simulate real filter)
    if (value == "<50") {
      products.value =
          products.where((p) => p["price"] < 50).toList();
    } else if (value == "Nike") {
      products.value =
          products.where((p) => p["name"].toString().contains("Air")).toList();
    }
  }
}
