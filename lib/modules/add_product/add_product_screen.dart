import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecommerce_urban/modules/add_product/add_product_controller.dart';

class AdminAddProductView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AdminAddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAddProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
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
              // ==================== STEP 1: PRODUCT DETAILS ====================
              _buildSectionTitle('Step 1: Product Details'),
              const SizedBox(height: 16),

              // NAME
              TextFormField(
                controller: controller.nameController,
                decoration:
                    _buildInputDecoration('Product Name', Icons.shopping_bag),
                validator: (v) =>
                    v!.isEmpty ? "Product name is required" : null,
              ),
              const SizedBox(height: 16),

              // DESCRIPTION
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration:
                    _buildInputDecoration('Description', Icons.description),
                validator: (v) => v!.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 16),

              // CATEGORY
              Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedCategoryId.value,
                  decoration: _buildInputDecoration('Category', Icons.category),
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (v) {
                    print('Category selected: $v');
                    controller.selectedCategoryId.value = v;
                  },
                  validator: (v) {
                    if (v == null) {
                      print('❌ Category validator: v is null');
                      return "Category is required";
                    }
                    print('✅ Category validator: v=$v');
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // STATUS
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value,
                  decoration: _buildInputDecoration('Status', Icons.info),
                  items: ['active', 'inactive', 'draft']
                      .map((x) => DropdownMenuItem(
                          value: x, child: Text(x.toUpperCase())))
                      .toList(),
                  onChanged: (v) => controller.selectedStatus.value = v!,
                ),
              ),
              const SizedBox(height: 24),

              // CREATE PRODUCT BUTTON
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            print('🔘 CREATE PRODUCT BUTTON PRESSED');
                            print('Form validation: ${_formKey.currentState!.validate()}');
                            if (_formKey.currentState!.validate()) {
                              print('✅ Form is valid, calling createProduct()');
                              controller.createProduct();
                            } else {
                              print('❌ Form validation failed');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Create Product',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Divider(height: 32),

              // ==================== STEP 2: VARIANT ====================
              _buildSectionTitle('Step 2: Add Variant (SKU & Price)'),
              const SizedBox(height: 16),

              // Check if product exists - wrap in Obx to react to changes
              Obx(
                () => controller.editingProductId.value != null
                    ? Column(
                        children: [
                          // SKU
                          TextFormField(
                            controller: controller.skuController,
                            decoration:
                                _buildInputDecoration('SKU', Icons.code),
                          ),
                          const SizedBox(height: 16),

                          // PRICE
                          TextFormField(
                            controller: controller.priceController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                                'Price', Icons.attach_money),
                          ),
                          const SizedBox(height: 16),

                          // CREATE VARIANT BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.createVariant,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade700,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Create Variant',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : _buildDisabledSection('Create product first'),
              ),

              const SizedBox(height: 32),
              const Divider(height: 32),

              // ==================== STEP 3: IMAGES ====================
              _buildSectionTitle('Step 3: Upload Images'),
              const SizedBox(height: 16),

              // Check if variant exists - wrap in Obx to react to changes
              Obx(
                () => controller.editingVariantId.value != null
                    ? Column(
                        children: [
                          // SELECTED IMAGES
                          const Text('Selected Images',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Obx(
                            () => controller.selectedImages.isEmpty
                                ? _emptyImageBox('No Selected Images')
                                : _imageGrid(controller),
                          ),
                          const SizedBox(height: 16),

                          // PICK IMAGES BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: controller.pickImages,
                              icon: const Icon(Icons.add_photo_alternate),
                              label: const Text('Pick Images'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // UPLOAD IMAGES BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: controller.isUploading.value ||
                                        controller.selectedImages.isEmpty
                                    ? null
                                    : controller.uploadImages,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: controller.isUploading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Upload Images',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : _buildDisabledSection('Create variant first'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
    );
  }

  Widget _buildDisabledSection(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Text(
        message,
        style:
            TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
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
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _imageGrid(AdminAddProductController c) {
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
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}