import 'dart:io';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/widget/ProductFormWidget.dart';
import 'package:ecommerce_urban/modules/admin_products/widget/VaraintsSectionsWidget.dart';
import 'package:ecommerce_urban/modules/admin_products/widget/assetSectionWidget.dart';
import 'package:ecommerce_urban/modules/admin_products/widget/loadingShimmerWidget.dart';
import 'package:ecommerce_urban/modules/admin_products/widget/stepIndicatorWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductManagementView extends StatefulWidget {
  const ProductManagementView({super.key});

  @override
  State<ProductManagementView> createState() => _ProductManagementViewState();
}

class _ProductManagementViewState extends State<ProductManagementView> {
  late ProductManagementController controller;
  final picker = ImagePicker();

  late TextEditingController productNameController;
  late TextEditingController productDescriptionController;
  late TextEditingController variantNameController;
  late TextEditingController variantSkuController;
  late TextEditingController variantPriceController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductManagementController>();

    productNameController =
        TextEditingController(text: controller.productName.value);
    productDescriptionController =
        TextEditingController(text: controller.productDescription.value);
    variantNameController =
        TextEditingController(text: controller.variantName.value);
    variantSkuController =
        TextEditingController(text: controller.variantSku.value);
    variantPriceController =
        TextEditingController(text: controller.variantPrice.value);
  }

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    variantNameController.dispose();
    variantSkuController.dispose();
    variantPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      return Scaffold(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.grey[50],
        appBar: AppBar(
          title: Text(
            controller.product.value == null
                ? 'Create Product'
                : 'Edit Product',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark ? theme.appBarTheme.backgroundColor : Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        body: controller.isLoading.value && controller.product.value == null
            ? const LoadingShimmerWidget()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Modern Step Indicator
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? theme.cardColor : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: StepIndicatorWidget(controller: controller),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.currentStep.value == 0)
                            ProductFormWidget(
                              controller: controller,
                              productNameController: productNameController,
                              productDescriptionController:
                                  productDescriptionController,
                            )
                          else if (controller.currentStep.value == 1)
                            VariantsSectionWidget(
                              controller: controller,
                              picker: picker,
                              variantNameController: variantNameController,
                              variantSkuController: variantSkuController,
                              variantPriceController: variantPriceController,
                            )
                          else if (controller.currentStep.value == 2)
                            AssetsSectionWidget(
                              controller: controller,
                              picker: picker,
                            ),
                          const SizedBox(height: 24),
                          NavigationButtonsWidget(controller: controller),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}