import 'package:ecommerce_urban/modules/auth/login/login_binding.dart';
import 'package:ecommerce_urban/modules/auth/login/login_screen.dart';
import 'package:ecommerce_urban/modules/auth/register/register_binding.dart';
import 'package:ecommerce_urban/modules/auth/register/register_screen.dart';
import 'package:ecommerce_urban/modules/auth/splash/splash_screen.dart';
import 'package:ecommerce_urban/modules/auth/splash/splash_screen_bindings.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final authRoutes = [
  GetPage(
    name: AppRoutes.splash,
    page: () => SplashScreen(),
    binding: SplashBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: AppRoutes.register,
    page: () => RegisterScreen(),
    binding: RegisterBinding(),
  ),
];
