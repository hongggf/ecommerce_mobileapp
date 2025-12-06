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

// Import the separate widget files


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
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            controller.product.value == null ? 'Create Product' : 'Edit Product',
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          elevation: 0,
        ),
        body: controller.isLoading.value && controller.product.value == null
            ? const LoadingShimmerWidget()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    StepIndicatorWidget(controller: controller),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
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