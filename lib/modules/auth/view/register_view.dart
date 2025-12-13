import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/register_controller.dart';

class RegisterView extends StatelessWidget {
  RegisterView({Key? key}) : super(key: key);

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingM),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _buildTitle(context),
              SizedBox(height: AppSpacing.paddingXXL),
              _buildFormFields(),
              SizedBox(height: AppSpacing.paddingXXL),
              _buildRegisterButton(),
              SizedBox(height: AppSpacing.paddingXS),
              _buildSignInLink(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Title Section
  Widget _buildTitle(BuildContext context) {
    return Text(
      'Create Account',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  /// Form
  Widget _buildFormFields() {
    return Column(
      children: [
        // Name
        TextFormField(
          controller: controller.nameController,
          decoration: const InputDecoration(
            hintText: 'Full Name',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) =>
          value == null || value.isEmpty ? 'Enter full name' : null,
        ),
        SizedBox(height: AppSpacing.paddingS),

        // Email
        TextFormField(
          controller: controller.emailController,
          decoration: const InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter email';
            if (!GetUtils.isEmail(value)) return 'Enter valid email';
            return null;
          },
        ),
        SizedBox(height: AppSpacing.paddingS),

        // Phone
        TextFormField(
          controller: controller.phoneController,
          decoration: const InputDecoration(
            hintText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) =>
          value == null || value.isEmpty ? 'Enter phone number' : null,
        ),
        SizedBox(height: AppSpacing.paddingS),

        // Password
        Obx(
              () => TextFormField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(controller.obscurePassword.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: controller.togglePassword,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter password';
              if (value.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),
        ),
        SizedBox(height: AppSpacing.paddingS),

        // Confirm Password
        Obx(
              () => TextFormField(
            controller: controller.confirmPasswordController,
            obscureText: controller.obscureConfirmPassword.value,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(controller.obscureConfirmPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: controller.toggleConfirmPassword,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Confirm your password';
              return null;
            },
          ),
        ),
      ],
    );
  }

  /// Register Button
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: controller.register,
        child: const Text('Register'),
      ),
    );
  }

  /// Sign In Link
  Widget _buildSignInLink(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Already have an account? ',
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
            text: 'Sign In',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
          ),
        ],
      ),
    );
  }
}