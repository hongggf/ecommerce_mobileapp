import 'package:ecommerce_urban/modules/auth/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Create\nyour Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildInputField(controller.nameController, "Name", "Enter your name"),
              const SizedBox(height: 15),
              _buildInputField(controller.emailController, "Email", "Enter your email"),
              const SizedBox(height: 15),
              _buildInputField(controller.passwordController, "Password", "Enter your password"),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    _buildRegisterButton(),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: const Text(
                        "Already have an account? Log In",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 1.9),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      
      child: Container(
        height: 50,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(800),
        ),
        child: const Center(
          child: Text(
            "SIGN UP",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
