import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/modules/user/user_address/user_address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';

class UserAddressForm extends StatelessWidget {
  final UserAddressController controller;
  final AddressModel? editingAddress;

  final _formKey = GlobalKey<FormState>();

  UserAddressForm({super.key, required this.controller, this.editingAddress}) {
    controller.prepareForm(address: editingAddress);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = editingAddress != null;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.paddingSM),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              /// Title
              TitleWidget(title: isEditing ? "Edit Address" : "Create Address"),
              SizedBox(height: AppSpacing.paddingSM),

              /// Full Name
              TextFormField(
                controller: controller.fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? "Full Name is required" : null,
              ),
              SizedBox(height: AppSpacing.paddingS),

              /// Phone
              TextFormField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value == null || value.trim().isEmpty ? "Phone is required" : null,
              ),
              SizedBox(height: AppSpacing.paddingS),

              /// Province
              TextFormField(
                controller: controller.provinceController,
                decoration: InputDecoration(
                  labelText: "Province",
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? "Province is required" : null,
              ),
              SizedBox(height: AppSpacing.paddingS),

              /// District
              TextFormField(
                controller: controller.districtController,
                decoration: InputDecoration(
                  labelText: "District",
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? "District is required" : null,
              ),
              SizedBox(height: AppSpacing.paddingS),

              /// Street
              TextFormField(
                controller: controller.streetController,
                decoration: InputDecoration(
                  labelText: "Street",
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? "Street is required" : null,
              ),
              SizedBox(height: AppSpacing.paddingS),

              /// Is Default
              Obx(() => CheckboxListTile(
                value: controller.isDefault.value,
                onChanged: (val) => controller.isDefault.value = val ?? false,
                title: const Text('Set as default address'),
              )),
              SizedBox(height: AppSpacing.paddingL),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newAddress = AddressModel(
                        fullName: controller.fullNameController.text,
                        phone: controller.phoneController.text,
                        province: controller.provinceController.text,
                        district: controller.districtController.text,
                        street: controller.streetController.text,
                        isDefault: controller.isDefault.value,
                      );

                      if (isEditing) {
                        controller.updateAddress(controller.editingAddressId.value!, newAddress);
                      } else {
                        controller.addAddress(newAddress);
                      }
                      Get.back();
                    }
                  },
                  child: Text(isEditing ? "Update Address" : "Create Address"),
                ),
              ),
              SizedBox(height: AppSpacing.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- SHOW BOTTOM SHEET ----------------
  static void show({required UserAddressController controller, AddressModel? editingAddress}) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => UserAddressForm(controller: controller, editingAddress: editingAddress),
    );
  }
}