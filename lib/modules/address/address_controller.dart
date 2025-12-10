import 'package:ecommerce_urban/modules/address/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final RxBool isDefault = false.obs;

  final formKey = GlobalKey<FormState>();
  String? editingAddressId;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  @override
  void onClose() {
    titleController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }

  void loadAddresses() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      addresses.value = [
        AddressModel(
          id: '1',
          title: 'Home',
          fullName: 'LIM HONG',
          phoneNumber: '+855 12 345 678',
          address: '123 Street 271',
          city: 'Phnom Penh',
          state: 'Phnom Penh',
          zipCode: '12000',
          isDefault: true,
        ),
        AddressModel(
          id: '2',
          title: 'Office',
          fullName: 'LIM HONG',
          phoneNumber: '+855 98 765 432',
          address: '456 Monivong Blvd',
          city: 'Phnom Penh',
          state: 'Phnom Penh',
          zipCode: '12001',
          isDefault: false,
        ),
      ];
      isLoading.value = false;
    });
  }

  void openAddAddressForm() {
    clearForm();
    editingAddressId = null;
    Get.toNamed('/address_form');
  }

  void openEditAddressForm(AddressModel address) {
    editingAddressId = address.id;
    titleController.text = address.title;
    fullNameController.text = address.fullName;
    phoneController.text = address.phoneNumber;
    addressController.text = address.address;
    cityController.text = address.city;
    stateController.text = address.state;
    zipCodeController.text = address.zipCode;
    isDefault.value = address.isDefault;
    Get.toNamed('/address/form');
  }

  void saveAddress() {
    if (!formKey.currentState!.validate()) return;

    if (editingAddressId != null) {
      // Update existing address
      final index = addresses.indexWhere((a) => a.id == editingAddressId);
      if (index != -1) {
        addresses[index] = AddressModel(
          id: editingAddressId!,
          title: titleController.text,
          fullName: fullNameController.text,
          phoneNumber: phoneController.text,
          address: addressController.text,
          city: cityController.text,
          state: stateController.text,
          zipCode: zipCodeController.text,
          isDefault: isDefault.value,
        );

        if (isDefault.value) {
          _updateDefaultAddress(editingAddressId!);
        }

        Get.back();
        Get.snackbar(
          'Success',
          'Address updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } else {
      // Add new address
      final newAddress = AddressModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text,
        fullName: fullNameController.text,
        phoneNumber: phoneController.text,
        address: addressController.text,
        city: cityController.text,
        state: stateController.text,
        zipCode: zipCodeController.text,
        isDefault: isDefault.value,
      );

      addresses.add(newAddress);

      if (isDefault.value) {
        _updateDefaultAddress(newAddress.id);
      }

      Get.back();
      Get.snackbar(
        'Success',
        'Address added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void deleteAddress(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addresses.removeWhere((address) => address.id == id);
              Get.back();
              Get.snackbar(
                'Success',
                'Address deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void setDefaultAddress(String id) {
    _updateDefaultAddress(id);
    Get.snackbar(
      'Success',
      'Default address updated',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _updateDefaultAddress(String id) {
    addresses.value = addresses.map((address) {
      return address.copyWith(isDefault: address.id == id);
    }).toList();
  }

  void clearForm() {
    titleController.clear();
    fullNameController.clear();
    phoneController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    zipCodeController.clear();
    isDefault.value = false;
  }
}
