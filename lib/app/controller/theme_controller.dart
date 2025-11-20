// import 'package:ecommerce_urban/app/services/theme_services.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../theme/dark_theme.dart';
// import '../theme/light_theme.dart';

// class ThemeController extends GetxController {
//   final ThemeService _service = ThemeService();

//   var isDarkMode = false.obs;

//   ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

//   @override
//   void onInit() {
//     super.onInit();
//     loadTheme();
//   }

//   void loadTheme() async {
//     isDarkMode.value = await _service.getTheme();
//   }

//   void toggleTheme() {
//     isDarkMode.value = !isDarkMode.value;
//     _service.saveTheme(isDarkMode.value);
//     Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
//   }
// }
import 'package:ecommerce_urban/app/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../theme/light_theme.dart';
import '../theme/dark_theme.dart';

class ThemeController extends GetxController {
  final ThemeService _service = ThemeService();

  RxBool isDarkMode = false.obs;

  ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    bool savedTheme = await _service.getTheme();

    // update observable
    isDarkMode.value = savedTheme;

    // apply theme immediately
    Get.changeTheme(savedTheme ? darkTheme : lightTheme);
  }

  void toggleTheme() async {
    bool newTheme = !isDarkMode.value;

    // update reactive value
    isDarkMode.value = newTheme;

    // save to SharedPreferences
    await _service.saveTheme(newTheme);

    // apply updated theme
    Get.changeTheme(newTheme ? darkTheme : lightTheme);
  }
}
