import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';

// ==================== STEP INDICATOR WIDGET ====================
class StepIndicatorWidget extends StatelessWidget {
  final ProductManagementController controller;

  const StepIndicatorWidget({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStep('Product', 0),
          Container(
            width: 40,
            height: 2,
            color: _getStepColor(0, 1),
          ),
          _buildStep('Variants', 1),
          Container(
            width: 40,
            height: 2,
            color: _getStepColor(1, 2),
          ),
          _buildStep('Assets', 2),
        ],
      ),
    );
  }

  Widget _buildStep(String label, int step) {
    final isActive = controller.currentStep.value >= step;
    final isCurrent = controller.currentStep.value == step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue.shade700 : Colors.grey.shade300,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? Colors.blue.shade700 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Color _getStepColor(int from, int to) {
    return controller.currentStep.value >= to
        ? Colors.blue.shade700
        : Colors.grey.shade300;
  }
}

// ==================== NAVIGATION BUTTONS WIDGET ====================
class NavigationButtonsWidget extends StatelessWidget {
  final ProductManagementController controller;

  const NavigationButtonsWidget({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        if (controller.currentStep.value > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.previousStep(),
              child: const Text('Previous'),
            ),
          ),
        if (controller.currentStep.value > 0) const SizedBox(width: 12),
        if (controller.currentStep.value == 0)
          Expanded(
            child: OutlinedButton(
              onPressed: controller.isLoading.value ? null : () => Get.back(),
              child: const Text('Cancel'),
            ),
          ),
        if (controller.currentStep.value == 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                if (controller.currentStep.value == 0) {
                  controller.saveProduct();
                } else if (controller.currentStep.value == 1) {
                  if (controller.variants.isNotEmpty) {
                    controller.nextStep();
                  } else {
                    Get.snackbar(
                      'Info',
                      'Create at least one variant before adding assets',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  Get.back();
                }
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
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
                controller.currentStep.value == 0
                    ? 'Save & Next'
                    : controller.currentStep.value == 2
                    ? 'Finish'
                    : 'Next',
              ),
          ),
        ),
      ],
    ));
  }
}