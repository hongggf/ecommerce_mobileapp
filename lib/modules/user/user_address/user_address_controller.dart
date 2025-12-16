import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/api/service/address_service.dart';
import 'package:ecommerce_urban/app/widgets/confirm_dialog_widget.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAddressController extends GetxController {
  final AddressService _service = AddressService();

  var addresses = <AddressModel>[].obs;
  var defaultAddress = Rxn<AddressModel>();
  var isLoading = false.obs;

  // Form controllers
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var provinceController = TextEditingController();
  var districtController = TextEditingController();
  var streetController = TextEditingController();
  var isDefault = false.obs;

  var editingAddressId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  // ------------------ Fetch addresses ------------------
  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      addresses.value = await _service.getAddresses();
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ Prepare form ------------------
  void prepareForm({AddressModel? address}) {
    if (address != null) {
      // Editing
      editingAddressId.value = address.id;
      fullNameController.text = address.fullName;
      phoneController.text = address.phone;
      provinceController.text = address.province;
      districtController.text = address.district;
      streetController.text = address.street;
      isDefault.value = address.isDefault;
    } else {
      // Creating
      editingAddressId.value = null;
      fullNameController.clear();
      phoneController.clear();
      provinceController.clear();
      districtController.clear();
      streetController.clear();
      isDefault.value = false;
    }
  }

  // ------------------ Add new address ------------------
  Future<void> addAddress(AddressModel address) async {
    try {
      final newAddress = await _service.createAddress(address);
      addresses.add(newAddress);
      ToastWidget.show(message: 'Address added successfully');
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    }
  }

  // ------------------ Update address ------------------
  Future<void> updateAddress(int id, AddressModel address) async {
    try {
      final updated = await _service.updateAddress(id, address);
      final index = addresses.indexWhere((a) => a.id == id);
      if (index != -1) addresses[index] = updated;
      ToastWidget.show(message: 'Address updated successfully');
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    }
  }

  // ------------------ Delete address ------------------
  Future<void> deleteAddress(int id) async {
    Get.dialog(
      ConfirmDialogWidget(
        title: "Confirm Delete",
        subtitle: "Are you sure you want to delete?",
        icon: Icons.delete,
        iconColor: Colors.red,
        confirmText: "Delete",
        cancelText: "Cancel",
        onConfirm: () async {
          try {
            await _service.deleteAddress(id);
            addresses.removeWhere((a) => a.id == id);
            ToastWidget.show(message: 'Address deleted successfully');
          } catch (e) {
            ToastWidget.show(type: 'error', message: e.toString());
          }
        },
        onCancel: () => Get.back(),
      ),
    );
  }

  // ------------------ Fetch Default Address ------------------
  Future<void> fetchDefaultAddress() async {
    try {
      isLoading.value = true;
      final address = await _service.getDefaultAddress();
      defaultAddress.value = address;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}