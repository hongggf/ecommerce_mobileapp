import 'package:ecommerce_urban/modules/auth/splash/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    colorScheme.background,
                    colorScheme.surface,
                  ]
                : [
                    colorScheme.background,
                    colorScheme.primary.withOpacity(0.05),
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container with Animation Effect
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_bag_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // App Name
              Text(
                "Urban Shop",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                  letterSpacing: 1.2,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Tagline
              Text(
                "Your Style, Your Choice",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.6),
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Loading Indicator
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                "Loading...",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}