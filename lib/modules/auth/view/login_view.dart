import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/auth/controller/login_controller.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM, vertical: 200),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(context),
              const SizedBox(height: 30),
              _title(context),
              const SizedBox(height: 40),
              _form(),
              SizedBox(height: AppSpacing.paddingXS),
              _signUpText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo(BuildContext context){
    return Image.asset('assets/images/e_mart_logo.png', scale: 6);
  }

  Widget _title(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          'Welcome Back',
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          'Login to your account',
          style: textTheme.bodyMedium
        ),
      ],
    );
  }

  Widget _form(){
    return Column(
      children: [
        Form(
          key: controller.formKey,
          child: Column(
            children: [

              /// Email Field
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppSpacing.paddingS),

              /// Password Field
              Obx(
                    () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscurePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: controller.togglePassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),

              /// Login Button
              ElevatedButton(
                onPressed: controller.login,
                child: const Text('Login',),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _signUpText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: textTheme.bodyMedium,
        children: [
          TextSpan(
            text: 'Sign Up',
            style: textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.register);
              },
          ),
        ],
      ),
    );
  }
}