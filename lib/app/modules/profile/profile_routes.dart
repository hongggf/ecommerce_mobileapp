import 'package:ecommerce_urban/app/modules/profile/profile_binding.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/modules/profile/profile_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';

final profileRoutes = [
  GetPage(
    name: AppRoutes.profile,
    page: () => const ProfileView(),
    binding: ProfileBinding()
  ),
];