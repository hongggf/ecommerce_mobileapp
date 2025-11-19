import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/auth/auth_controller.dart';
import 'package:ecommerce_urban/modules/auth/login/login_controller.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();
  final AuthController auth = Get.find<AuthController>();
  final BottomNavController bottom=Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // --- Welcome text ---
                Text(
                  "Welcome Back 👋",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Log in to your account",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Username & password fields ---
                _buildTextField(
                    context, controller.usernameController, "Username", Icons.person),
                const SizedBox(height: 20),
                _buildTextField(
                  context,
                  controller.passwordController,
                  "Password",
                  Icons.lock,
                  obscure: true,
                ),
                const SizedBox(height: 30),

                // --- Login button ---
                Obx(
                  () => Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (controller.usernameController.text.isEmpty ||
                                  controller.passwordController.text.isEmpty) {
                                Get.snackbar("Error", "Please fill all fields",
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }

                              controller.isLoading.value = true;

                              // Simulate login delay (replace with API call if needed)
                              await Future.delayed(const Duration(seconds: 1));

                              // ✅ Save username using AuthController
                              await auth.login(
                                  controller.usernameController.text.trim());

                              controller.isLoading.value = false;

                              // ✅ Go to home screen
                              Get.offAllNamed('/bottom-nav');
                            },
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "LOG IN",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.darkTextPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- Signup link ---
                Center(
                  child: GestureDetector(
                    onTap: controller.goToRegister,
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground
                            .withOpacity(isDark ? 0.9 : 0.8),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String label, IconData icon,
      {bool obscure = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style:
          theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onBackground.withOpacity(0.8),
        ),
        prefixIcon: Icon(icon,
            color:
                colorScheme.onBackground.withOpacity(isDark ? 0.8 : 0.6)),
        filled: true,
        fillColor: isDark ? Colors.white12 : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
