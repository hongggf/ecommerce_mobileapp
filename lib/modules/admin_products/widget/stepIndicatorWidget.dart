import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';

class StepIndicatorWidget extends StatelessWidget {
  final ProductManagementController controller;

  const StepIndicatorWidget({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          _buildStep(
            'Product',
            'Basic info',
            Icons.inventory_2_rounded,
            0,
            isDark,
          ),
          _buildConnector(0, 1, isDark),
          _buildStep(
            'Variants',
            'Add options',
            Icons.layers_rounded,
            1,
            isDark,
          ),
          _buildConnector(1, 2, isDark),
          _buildStep(
            'Assets',
            'Upload media',
            Icons.image_rounded,
            2,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    String label,
    String subtitle,
    IconData icon,
    int step,
    bool isDark,
  ) {
    final isActive = controller.currentStep.value >= step;
    final isCurrent = controller.currentStep.value == step;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? AppColors.primary
                  : isDark
                      ? Colors.grey[800]
                      : Colors.grey[200],
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : isDark
                      ? Colors.grey[600]
                      : Colors.grey[400],
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
              color: isCurrent
                  ? AppColors.primary
                  : isDark
                      ? (isActive ? Colors.white : Colors.grey[500])
                      : (isActive ? Colors.grey[900] : Colors.grey[500]),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey[600] : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(int from, int to, bool isDark) {
    final isActive = controller.currentStep.value >= to;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [AppColors.primary, AppColors.primary]
                  : isDark
                      ? [Colors.grey[800]!, Colors.grey[800]!]
                      : [Colors.grey[300]!, Colors.grey[300]!],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class NavigationButtonsWidget extends StatelessWidget {
  final ProductManagementController controller;

  const NavigationButtonsWidget({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (controller.currentStep.value > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.previousStep(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (controller.currentStep.value > 0) const SizedBox(width: 12),
              if (controller.currentStep.value == 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => Get.back(),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (controller.currentStep.value == 0) const SizedBox(width: 12),
              Expanded(
                flex: controller.currentStep.value == 0 ? 2 : 1,
                child: FilledButton.icon(
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
                                'Variants Required',
                                'Please create at least one variant before proceeding',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.blue[700],
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.info_rounded,
                                  color: Colors.white,
                                ),
                                borderRadius: 12,
                                margin: const EdgeInsets.all(16),
                              );
                            }
                          } else {
                            Get.back();
                          }
                        },
                  icon: controller.isLoading.value
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
                      : Icon(
                          controller.currentStep.value == 2
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                  label: Text(
                    controller.currentStep.value == 0
                        ? 'Save & Continue'
                        : controller.currentStep.value == 2
                            ? 'Finish'
                            : 'Next Step',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}