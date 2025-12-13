import 'package:ecommerce_urban/modules/auth/view/login_view.dart';
import 'package:ecommerce_urban/modules/auth/view/register_view.dart';
import 'package:ecommerce_urban/modules/auth/view/splash_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class AuthRoute {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
    ),
  ];
}