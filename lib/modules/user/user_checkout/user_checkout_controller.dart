import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/api/service/address_service.dart';
import 'package:get/get.dart';

class UserCheckoutController extends GetxController {

  final AddressService _service = AddressService();

  var defaultAddress = Rxn<AddressModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDefaultAddress();
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