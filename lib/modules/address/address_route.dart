import 'package:ecommerce_urban/modules/address/address_binding.dart';
import 'package:ecommerce_urban/modules/address/address_form_view.dart';
import 'package:ecommerce_urban/modules/address/address_list_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final addressRoute = [
  GetPage(
    name: AppRoutes.address,
    page: () => AddressListView(),
    binding: AddressBinding(),
  ),
  GetPage(
    name: AppRoutes.addressForm,
    page: () => AddressFormView(),
    binding: AddressBinding(),
  ),
];

