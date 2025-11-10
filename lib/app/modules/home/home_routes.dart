import 'package:ecommerce_urban/app/modules/home/home_binding.dart';
import 'package:ecommerce_urban/app/modules/home/home_view.dart';

import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final homeRoutes = [
  GetPage(
    name: AppRoutes.home,
    page: () => Homepage(),
    binding: HomeBinding(),
  )
];
