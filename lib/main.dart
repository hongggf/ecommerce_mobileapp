import 'package:ecommerce_urban/app/controller/ratio_controller.dart';
import 'package:ecommerce_urban/app/controller/theme_controller.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav_binding.dart';
import 'package:ecommerce_urban/route/app_pages.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(ThemeController(), permanent: true);
  Get.put(RatioController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.bottomNav,
          getPages: AppPages.pages,
          theme: Get.find<ThemeController>().theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialBinding: BottomNavBinding(),
        );
      },
    );
  }
}