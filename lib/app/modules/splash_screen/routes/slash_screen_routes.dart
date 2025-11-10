
import 'package:ecommerce_urban/app/modules/splash_screen/bindings/splash_screen_bindings.dart';
import 'package:ecommerce_urban/app/modules/splash_screen/view/splash_screen.dart';

import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final splashRoutes = [
 GetPage(
    name: AppRoutes.splash,
    page: () => SplashScreen(),
    binding: SplashBinding(),
    transition: Transition.fadeIn,
  ),
 
];
