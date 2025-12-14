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

  Future<void> fetchCategories({String? search, String? sort}) async {
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
    if (editingCategoryId.value == null) {
      await _createCategory();
    } else {
      await _updateCategory();
    }
  }

  Future<void> _createCategory() async {
    try {
      isLoading.value = true;
      await _service.createCategory(
          name: nameController.text.trim(),
          slug: slugController.text.trim()
      );
      ToastWidget.show(message: "Success Created Category");
      await fetchCategories();
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to create category!");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateCategory() async {
    try {
      isLoading.value = true;
      await _service.updateCategory(
        id: editingCategoryId.value!,
        name: nameController.text,
        slug: slugController.text,
      );
      ToastWidget.show(message: "Success Updated Category");
      await fetchCategories();
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to update category");
    } finally {
      isLoading.value = false;
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
          // ToastWidget.show(type: "error", message: "Failed to delete category");
          ToastWidget.show(type: "error", message: e.toString());
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}