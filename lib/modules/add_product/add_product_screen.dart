import 'dart:convert';
import 'package:ecommerce_urban/modules/add_product/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admin_products/model/product_asset.dart';

class AdminAddProductView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AdminAddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAddProductController());

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.editingProductId == null
            ? "Add Product"
            : "Edit Product"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Product Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // NAME
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Product Name",
                  prefixIcon: const Icon(Icons.production_quantity_limits),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Product name is required" : null,
              ),
              const SizedBox(height: 16),

              // DESCRIPTION
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 16),

              // CATEGORY
              Obx(() {
                return DropdownButtonFormField<int>(
                  value: controller.selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: "Category",
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.blue.shade700, width: 2),
                    ),
                  ),
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (v) {
                    controller.selectedCategoryId = v;
                  },
                  validator: (v) => v == null ? "Category is required" : null,
                );
              }),
              const SizedBox(height: 16),

              // STATUS
              DropdownButtonFormField<String>(
                value: controller.selectedStatus,
                decoration: InputDecoration(
                  labelText: "Status",
                  prefixIcon: const Icon(Icons.info),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
                items: ["active", "inactive", "draft"]
                    .map((x) => DropdownMenuItem(
                          value: x,
                          child: Text(x.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (v) => controller.selectedStatus = v!,
              ),
              const SizedBox(height: 24),

              const Divider(height: 32),
              const Text("Images",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              /// SELECTED IMAGES
              const Text("Selected Images",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Obx(() {
                return controller.selectedImages.isEmpty
                    ? _emptyImageBox("No Selected Images")
                    : _imageGridSelected(controller);
              }),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: controller.pickImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Pick Images"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
              ),

              const SizedBox(height: 24),
              const Text("Uploaded Images",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),

              /// UPLOADED IMAGES
              Obx(() {
                return controller.uploadedAssets.isEmpty
                    ? _emptyImageBox("No Uploaded Images")
                    : _imageGridUploaded(controller);
              }),

              const SizedBox(height: 24),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  controller.submit();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                controller.editingProductId == null
                                    ? "Create Product"
                                    : "Update Product",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: controller.isUploading.value ||
                                controller.selectedImages.isEmpty
                            ? null
                            : controller.uploadImages,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: controller.isUploading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                "Upload Images",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyImageBox(String text) {
    return Container(
      alignment: Alignment.center,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported,
              color: Colors.grey.shade400, size: 48),
          const SizedBox(height: 8),
          Text(text,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              )),
        ],
      ),
    );
  }

  Widget _imageGridSelected(AdminAddProductController c) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: c.selectedImages.length,
      itemBuilder: (_, i) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                c.selectedImages[i],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey.shade400),
                  );
                },
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: () => c.selectedImages.removeAt(i),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _imageGridUploaded(AdminAddProductController c) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: c.uploadedAssets.length,
      itemBuilder: (_, i) {
        final asset = c.uploadedAssets[i];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _loadImage(asset, c),
            ),
            if (asset.isPrimary)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Primary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: () => c.deleteImage(asset.id!),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _loadImage(ProductAsset asset, AdminAddProductController c) {
    try {
      // Try URL first
      if (asset.url != null && asset.url!.isNotEmpty) {
        print('🖼️ Loading uploaded image from URL: ${asset.url}');
        return Image.network(
          'http://10.0.2.2:8000${asset.url}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('❌ URL load failed: $error, trying base64...');
            return _loadBase64Image(asset, c);
          },
        );
      }

      // Fallback to base64
      return _loadBase64Image(asset, c);
    } catch (e) {
      print('❌ Image load error: $e');
      return Container(
        color: Colors.grey.shade200,
        child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
      );
    }
  }

  Widget _loadBase64Image(ProductAsset asset, AdminAddProductController c) {
    try {
      if (asset.base64File == null || asset.base64File!.isEmpty) {
        return Container(
          color: Colors.grey.shade200,
          child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
        );
      }

      String base64String = asset.base64File!;

      // Remove data URL prefix if present
      if (base64String.startsWith('data:')) {
        base64String = base64String.split(',').last;
      }

      // Clean whitespace
      base64String = base64String.replaceAll('\n', '').replaceAll('\r', '');

      print('🖼️ Loading base64 image (${base64String.length} chars)');

      final bytes = base64Decode(base64String);
      print('✅ Base64 decoded: ${bytes.length} bytes');

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Base64 decode error: $error');
          return Container(
            color: Colors.grey.shade200,
            child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
          );
        },
      );
    } catch (e) {
      print('❌ Base64 error: $e');
      return Container(
        color: Colors.grey.shade200,
        child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
      );
    }
  }
}