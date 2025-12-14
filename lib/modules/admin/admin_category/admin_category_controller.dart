import 'package:ecommerce_urban/api/model/category_model.dart';
import 'package:ecommerce_urban/api/service/category_service.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCategoryController extends GetxController {

  final CategoryService _service = CategoryService();

  var categories = <CategoryData>[].obs;
  var isLoading = false.obs;

  var sortBy = "".obs;

  // Form controllers
  var nameController = TextEditingController();
  var slugController = TextEditingController();
  var editingCategoryId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories({String? search, String? sort}) async {
    try {
      isLoading.value = true;
      final result = await _service.getCategories(search: search, sort: sort);
      categories.assignAll(result);
    } catch (e) {
      ToastWidget.show(type:"error", message: "Failed to fetch categories");
    } finally {
      isLoading.value = false;
    }
  }

  void prepareForm({CategoryData? category}) {
    if (category != null) {
      editingCategoryId.value = category.id;
      nameController.text = category.name ?? "";
      slugController.text = category.slug ?? "";
    } else {
      editingCategoryId.value = null;
      nameController.clear();
      slugController.clear();
    }
  }

  void submitCategoryForm() async {
    final name = nameController.text.trim();
    final slug = slugController.text.trim();

    if (name.isEmpty || slug.isEmpty) {
      ToastWidget.show(type:"error", message: "Please fill all fields");
      return;
    }

    try {
      if (editingCategoryId.value == null) {
        final newCategory = await _service.createCategory(name: name, slug: slug);
        categories.insert(0, newCategory);
        ToastWidget.show(message: "Success Created Category");
      } else {
        final updatedCategory = await _service.updateCategory(
          id: editingCategoryId.value!,
          name: name,
          slug: slug,
        );
        int index = categories.indexWhere((c) => c.id == updatedCategory.id);
        if (index != -1) categories[index] = updatedCategory;
        ToastWidget.show(message: "Success Updated Category");
      }
      Get.back();
    } catch (e) {
      ToastWidget.show(type: "error", message: e.toString());
    }
  }

  void deleteCategory(int id) async {
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText: "Are you sure you want to delete this category?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        try {
          isLoading.value = true;
          await _service.deleteCategory(id);
          categories.removeWhere((c) => c.id == id);
          ToastWidget.show(message: "Success delete category");
        } catch (e) {
          ToastWidget.show(type: "error", message: "Failed to delete category");
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}