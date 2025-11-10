import 'package:ecommerce_urban/app/modules/splash_screen/controller/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
  final  SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEAF3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 100, color: Colors.black),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Urban Shop",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
