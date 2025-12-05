
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
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Product name is required" : null,
              ),
              const SizedBox(height: 16),

              // DESCRIPTION
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 16),

              // STATUS
              DropdownButtonFormField<String>(
                value: controller.selectedStatus,
                decoration: const InputDecoration(
                    labelText: "Status", border: OutlineInputBorder()),
                items: ["active", "inactive", "draft"]
                    .map((x) => DropdownMenuItem(
                          value: x,
                          child: Text(x.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (v) => controller.selectedStatus = v!,
              ),
              const SizedBox(height: 16),

              const Divider(height: 32),
              const Text("Images",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              /// SELECTED IMAGES
              Obx(() {
                return controller.selectedImages.isEmpty
                    ? _emptyImageBox("No Selected Images")
                    : _imageGridSelected(controller);
              }),

              const SizedBox(height: 8),

              ElevatedButton.icon(
                onPressed: controller.pickImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Pick Images"),
              ),

              const SizedBox(height: 24),
              const Text("Uploaded Images",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : Text(controller.editingProductId == null
                                ? "Create Product"
                                : "Update Product"),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: controller.isUploading.value ||
                                controller.selectedImages.isEmpty
                            ? null
                            : controller.uploadImages,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: controller.isUploading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Upload Images"),
                      );
                    }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyImageBox(text) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Text(text),
    );
  }

  Widget _imageGridSelected(AdminAddProductController c) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: c.selectedImages.length,
      itemBuilder: (_, i) {
        return Stack(
          children: [
            Image.file(c.selectedImages[i], fit: BoxFit.cover),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => c.selectedImages.removeAt(i),
                child: const Icon(Icons.close, color: Colors.red),
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
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: c.uploadedAssets.length,
      itemBuilder: (_, i) {
        final asset = c.uploadedAssets[i];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _loadImage(asset, c),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => c.deleteImage(asset.id!),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _loadImage(ProductAsset asset, AdminAddProductController c) {
    if (asset.base64File.startsWith("data:")) {
      return Image.memory(
        c.decodeBase64(asset.base64File),
        fit: BoxFit.cover,
      );  
    }
    return Image.network(asset.base64File, fit: BoxFit.cover);
  }
}
