import 'package:ecommerce_urban/modules/add_product/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddProductView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();

  AdminAddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAddProductController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Add New Product",
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 1: Category Management
              _buildStepHeader(context, '1', 'Category Management'),
              SizedBox(height: 16),
              _buildCategorySection(controller, theme, isDark),
              SizedBox(height: 32),

              // Step 2: Product Details
              _buildStepHeader(context, '2', 'Product Details'),
              SizedBox(height: 16),
              _buildProductDetailsSection(controller, theme),
              SizedBox(height: 32),

              // Step 3: Variant
              _buildStepHeader(context, '3', 'Add Variant (SKU & Price)'),
              SizedBox(height: 16),
              _buildVariantSection(controller, theme, isDark),
              SizedBox(height: 32),

              // Step 4: Images
              _buildStepHeader(context, '4', 'Upload Images'),
              SizedBox(height: 16),
              _buildImagesSection(controller, theme, isDark),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context, String step, String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(step,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }

  Widget _buildCategorySection(
      AdminAddProductController controller, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add New Category
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.blue.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.add_circle_outline,
                      color: theme.primaryColor, size: 20),
                  SizedBox(width: 8),
                  Text('Add New Category (Optional)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      )),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        prefixIcon: Icon(Icons.folder_open),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Obx(() => ElevatedButton.icon(
                        onPressed: controller.isCreatingCategory.value
                            ? null
                            : () {
                                if (_categoryNameController.text
                                    .trim()
                                    .isNotEmpty) {
                                  controller.createCategory(
                                      _categoryNameController.text.trim());
                                  _categoryNameController.clear();
                                } else {
                                  Get.snackbar('Error', 'Enter category name',
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white);
                                }
                              },
                        icon: Icon(Icons.add, size: 18),
                        label: Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Select Category
        Obx(() {
          if (controller.categories.isEmpty) {
            return _buildEmptyCard(
                theme, isDark, 'No categories available. Add one above.');
          }

          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Category',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: controller.selectedCategoryId.value,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (v) {
                    controller.selectedCategoryId.value = v;
                  },
                  validator: (v) =>
                      v == null ? "Please select a category" : null,
                ),
                SizedBox(height: 16),
                Text('Available Categories',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    )),
                SizedBox(height: 12),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      final isSelected =
                          controller.selectedCategoryId.value == category.id;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.only(bottom: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.primaryColor.withOpacity(0.1)
                              : (isDark ? Colors.grey[800] : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.primaryColor
                                : (isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.folder,
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.grey[600],
                                size: 22),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(category.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  )),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle,
                                  color: theme.primaryColor, size: 22),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProductDetailsSection(
      AdminAddProductController controller, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: controller.nameController,
            decoration: _buildInputDecoration(
                'Product Name', Icons.shopping_bag, theme),
            validator: (v) => v!.isEmpty ? "Product name is required" : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: controller.descriptionController,
            maxLines: 4,
            decoration:
                _buildInputDecoration('Description', Icons.description, theme),
            validator: (v) => v!.isEmpty ? "Description is required" : null,
          ),
          SizedBox(height: 16),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedStatus.value,
                decoration: _buildInputDecoration('Status', Icons.info, theme),
                items: ['active', 'inactive', 'draft']
                    .map((x) => DropdownMenuItem(
                        value: x, child: Text(x.toUpperCase())))
                    .toList(),
                onChanged: (v) => controller.selectedStatus.value = v!,
              )),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            controller.createProduct();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Create Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          )),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSection(
      AdminAddProductController controller, ThemeData theme, bool isDark) {
    return Obx(() {
      if (controller.editingProductId.value == null) {
        return _buildEmptyCard(
            theme, isDark, 'Create product first to add variants');
      }

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            TextFormField(
              controller: controller.skuController,
              decoration: _buildInputDecoration('SKU', Icons.qr_code, theme),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              decoration:
                  _buildInputDecoration('Price', Icons.attach_money, theme),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.createVariant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text('Create Variant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            )),
                  )),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildImagesSection(
      AdminAddProductController controller, ThemeData theme, bool isDark) {
    return Obx(() {
      if (controller.editingVariantId.value == null) {
        return _buildEmptyCard(
            theme, isDark, 'Create variant first to upload images');
      }

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Images',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Obx(() => controller.selectedImages.isEmpty
                ? Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              color: Colors.grey[400], size: 48),
                          SizedBox(height: 8),
                          Text('No images selected',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (_, i) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.image,
                                  color: theme.primaryColor, size: 40),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () =>
                                  controller.selectedImages.removeAt(i),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade600,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.pickImages,
                icon: Icon(Icons.add_photo_alternate),
                label: Text('Pick Images'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isUploading.value ||
                            controller.selectedImages.isEmpty
                        ? null
                        : controller.uploadImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: controller.isUploading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text('Upload Images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            )),
                  )),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyCard(ThemeData theme, bool isDark, String message) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                )),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      String label, IconData icon, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.primaryColor,
          width: 2,
        ),
      ),
    );
  }
}
