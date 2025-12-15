import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:ecommerce_urban/api/model/product_model.dart';
import 'package:ecommerce_urban/api/service/product_service.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';

class AdminInventoryController extends GetxController {
  final ProductService _service = ProductService();

  /// State
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var search = ''.obs;
  var sort = ''.obs;

  /// Form
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final comparePriceController = TextEditingController();
  final stockController = TextEditingController();
  final lowStockController = TextEditingController();
  var selectedCategoryId = RxnInt();

  var imageFile = Rx<File?>(null); // Single image for now
  final ImagePicker _picker = ImagePicker();
  var editingProductId = RxnInt();

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  /// ---------------- FETCH ----------------
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final result = await _service.getProducts(
        search: search.value,
        sort: sort.value,
      );
      products.assignAll(result);
    } catch (e) {
      ToastWidget.show(type: 'error', message: 'Failed to load products $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- PICK + COMPRESS IMAGE ----------------
  Future<void> pickImage() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    File file = File(xfile.path);

    // Optional: compress if needed
    final size = await file.length();
    if (size > 2 * 1024 * 1024) {
      final temp = await Directory.systemTemp.createTemp();
      final target = path.join(temp.path, path.basename(file.path));
      final compressed = await FlutterImageCompress.compressAndGetFile(
        file.path,
        target,
        quality: 80,
      );
      if (compressed != null) file = File(compressed.path);
    }

    imageFile.value = file; // <- use .value
  }

  /// ---------------- PREPARE FORM ----------------
  void prepareForm({ProductModel? product}) {
    if (product != null) {
      editingProductId.value = product.id;
      nameController.text = product.name;
      descController.text = product.description;
      priceController.text = product.price;
      comparePriceController.text = product.comparePrice ?? '';
      stockController.text = product.stockQuantity.toString();
      lowStockController.text = product.lowStockAlert.toString();
      selectedCategoryId.value = product.category.id;
      imageFile.value = null;
    } else {
      editingProductId.value = null;
      nameController.clear();
      descController.clear();
      priceController.clear();
      comparePriceController.clear();
      stockController.clear();
      lowStockController.clear();
      selectedCategoryId.value = null;
      imageFile.value = null;
    }
  }

  /// ---------------- SUBMIT FORM ----------------
  Future<void> submitProductForm() async {
    if (editingProductId.value == null) {
      await _createProduct();
    } else {
      await _updateProduct();
    }
  }

  Future<void> _createProduct() async {
    if (imageFile.value == null) {
      ToastWidget.show(type: 'error', message: 'Please select an image');
      return;
    } else{
      try {
        isLoading.value = true;
        await _service.createProduct(
          name: nameController.text.trim(),
          categoryId: selectedCategoryId.value!,
          description: descController.text.trim(),
          price: priceController.text.trim(),
          comparePrice: comparePriceController.text.trim(),
          image: imageFile.value!,
          stockQuantity: int.tryParse(stockController.text) ?? 0,
          lowStockAlert: int.tryParse(lowStockController.text) ?? 0,
          status: 'active',
        );
        ToastWidget.show(message: 'Product created successfully');
        fetchProducts();
        prepareForm();
        Get.back();
      } catch (e) {
        ToastWidget.show(type: 'error', message: 'Failed to create product $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> _updateProduct() async {
    if (editingProductId.value == null) return;

    try {
      isLoading.value = true;
      await _service.updateProduct(
        editingProductId.value!,
        name: nameController.text.trim(),
        categoryId: selectedCategoryId.value!,
        description: descController.text.trim(),
        price: priceController.text.trim(),
        comparePrice: comparePriceController.text.trim(),
        image: imageFile.value, // Optional
        stockQuantity: int.tryParse(stockController.text) ?? 0,
        lowStockAlert: int.tryParse(lowStockController.text) ?? 0,
        status: 'active',
      );
      ToastWidget.show(message: 'Product updated successfully');
      fetchProducts();
      prepareForm();
      Get.back();
    } catch (e) {
      ToastWidget.show(type: 'error', message: 'Failed to update product $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- DELETE ----------------
  Future<void> deleteProduct(int id) async {
    Get.defaultDialog(
      title: 'Confirm Delete',
      middleText: 'Are you sure you want to delete this product?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        try {
          isLoading.value = true;
          await _service.deleteProduct(id);
          products.removeWhere((p) => p.id == id);
          ToastWidget.show(message: 'Product deleted');
        } catch (e) {
          ToastWidget.show(type: 'error', message: 'Failed to delete product $e');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}