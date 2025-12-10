import 'package:get/get.dart';

class CategoryItem {
  final String id;
  final String name;
  final String icon;

  CategoryItem({required this.id, required this.name, required this.icon});
}

class CategoryController extends GetxController {
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      categories.assignAll([
        CategoryItem(id: '1', name: 'Shoes', icon: '👟'),
        CategoryItem(id: '2', name: 'Bags', icon: '👜'),
        CategoryItem(id: '3', name: 'Watches', icon: '⌚'),
        CategoryItem(id: '4', name: 'Glasses', icon: '👓'),
        CategoryItem(id: '5', name: 'Hats', icon: '🎩'),
        CategoryItem(id: '6', name: 'Accessories', icon: '✨'),
      ]);
      isLoading.value = false;
    });
  }

  void selectCategory(CategoryItem category) {
    Get.snackbar('Category', 'Selected ${category.name}', snackPosition: SnackPosition.BOTTOM);
  }
}