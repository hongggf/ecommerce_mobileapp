import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:ecommerce_urban/modules/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.marginL),

                // Logo Section
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      size: AppWidgetSize.iconXXL,
                      color: colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Welcome text
                Text(
                  "Welcome Back 👋",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: AppFontSize.displayMedium,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Log in to your account to continue",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: AppSpacing.paddingL,
                ),

                // Email field
                _buildTextField(
                  context,
                  controller: controller.emailController,
                  label: "Email Address",
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: AppSpacing.paddingL,
                ),

                // Password field with toggle
                Obx(
                  () => _buildTextField(
                    context,
                    controller: controller.passwordController,
                    label: "Password",
                    hint: "Enter your password",
                    icon: Icons.lock_outline,
                    obscure: controller.obscurePassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colorScheme.onBackground.withOpacity(0.5),
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.marginXL),

                // Login button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: colorScheme.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed:
                          controller.isLoading.value ? null : controller.login,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              "Log In",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Divider with OR
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: colorScheme.onBackground.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: colorScheme.onBackground.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.paddingXL),

                // Sign up link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.7),
                            fontSize: AppFontSize.titleMedium),
                      ),
                      GestureDetector(
                        onTap: controller.goToRegister,
                        child: Text(
                          "Sign Up",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontSize: AppFontSize.titleMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onBackground,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.4),
              ),
              prefixIcon: Icon(
                icon,
                color: colorScheme.onBackground.withOpacity(0.5),
                size: 22,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: isDark ? colorScheme.surface : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
