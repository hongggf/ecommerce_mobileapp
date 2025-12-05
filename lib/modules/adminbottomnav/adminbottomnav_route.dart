import 'package:ecommerce_urban/modules/adminbottomnav/adminbottomnav.dart';
import 'package:ecommerce_urban/modules/adminbottomnav/adminbottomnav_binding.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final adminBottomNavRoute = [
  GetPage(
    name: AppRoutes.adminbottomnav,
    page: () => Adminbottomnav(),
    binding: AdminbottomnavBinding(),
  )
];
