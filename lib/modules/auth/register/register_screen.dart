import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:ecommerce_urban/modules/auth/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: colorScheme.onBackground,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.marginXXL),

              // Title
              Text(
                "Create Your\nAccount",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: AppFontSize.displaySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: AppSpacing.paddingM),
              Text(
                "Sign up to get started with shopping",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              SizedBox(height: AppSpacing.paddingM),

              // Full Name field
              _buildInputField(
                context,
                controller: controller.fullNameController,
                label: "Full Name",
                hint: "Enter your full name",
                fontSize: AppFontSize.headlineLarge,
                icon: Icons.person_outline,
              ),
              SizedBox(height: AppSpacing.paddingM),

              // Email field
              _buildInputField(
                context,
                controller: controller.emailController,
                fontSize: AppFontSize.headlineLarge,
                label: "Email Address",
                hint: "Enter your email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSpacing.paddingM),

              // Phone field
              _buildInputField(
                context,
                controller: controller.phoneController,
                fontSize: AppFontSize.headlineLarge,
                label: "Phone Number",
                hint: "Enter your phone number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: AppSpacing.paddingM),
              // Password field
              Obx(
                () => _buildInputField(
                  context,
                  controller: controller.passwordController,
                  label: "Password",
                  hint: "Create a password",
                  fontSize: AppFontSize.headlineLarge,
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

              SizedBox(height: AppSpacing.paddingM),
              // Confirm Password field
              Obx(
                () => _buildInputField(
                  context,
                  controller: controller.confirmPasswordController,
                  label: "Confirm Password",
                  hint: "Re-enter your password",
                  fontSize: AppFontSize.headlineLarge,
                  icon: Icons.lock_outline,
                  obscure: controller.obscureConfirmPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscureConfirmPassword.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: colorScheme.onBackground.withOpacity(0.5),
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.paddingM),
              // Sign Up button
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
                        controller.isLoading.value ? null : controller.register,
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
                            "Create Account",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.paddingM),

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

              SizedBox(
                height: AppSpacing.marginL,
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        "Log In",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.paddingM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required double fontSize,
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
            fontSize: AppFontSize.labelLarge,
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
                size: AppWidgetSize.iconM,
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

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
      child: Material(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: colorScheme.onBackground,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
