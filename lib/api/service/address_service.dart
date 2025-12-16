import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class AddressService {
  final Dio _dio = DioService.dio;

  // GET all addresses
  Future<List<AddressModel>> getAddresses() async {
    final response = await _dio.get(AppConstant.addresses);
    final List list = response.data['data'];
    return list.map((e) => AddressModel.fromJson(e)).toList();
  }

  // CREATE address
  Future<AddressModel> createAddress(AddressModel address) async {
    final response = await _dio.post(AppConstant.addresses, data: address.toJson());
    return AddressModel.fromJson(response.data['data']);
  }

  // UPDATE address
  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    final response = await _dio.put(AppConstant.addressById(id), data: address.toJson());
    return AddressModel.fromJson(response.data['data']);
  }

  // DELETE address
  Future<void> deleteAddress(int id) async {
    await _dio.delete(AppConstant.addressById(id));
  }

  Future<AddressModel?> getDefaultAddress() async {
    try {
      final response = await _dio.get(AppConstant.defaultAddress);
      if (response.data['success'] == true && response.data['data'] != null) {
        return AddressModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch default address: $e');
    }
  }
}