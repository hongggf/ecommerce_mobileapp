// import 'package:ecommerce_urban/modules/auth/register/register_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({super.key});

//   late final RegisterController controller = Get.find<RegisterController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 50),
//               const Text(
//                 "Create\nyour Account",
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 30),
//               _buildInputField(
//                   controller.fullnameController, "Name", "Enter your name"),
//               const SizedBox(height: 15),
//               _buildInputField(
//                   controller.emailController, "Email", "Enter your email"),
//               const SizedBox(height: 15),
//               _buildInputField(controller.passwordController, "Password",
//                   "Enter your password"),
//               const SizedBox(height: 40),
//               Center(
//                 child: Column(
//                   children: [
//                     _buildRegisterButton(),
//                     const SizedBox(height: 30),
//                     GestureDetector(
//                       onTap: controller.goToLogin,
//                       child: const Text(
//                         "Already have an account? Log In",
//                         style: TextStyle(
//                           color: Colors.pinkAccent,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(
//       TextEditingController controller, String label, String hint) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.white,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: const BorderSide(color: Colors.grey, width: 2),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.zero,
//           borderSide: BorderSide(color: Colors.black, width: 1.9),
//         ),
//       ),
//     );
//   }

//   Widget _buildRegisterButton() {
//     return GestureDetector(
//       child: Container(
//         height: 50,
//         width: 160,
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(800),
//         ),
//         child: const Center(
//           child: Text(
//             "SIGN UP",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:ecommerce_urban/modules/auth/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  late final RegisterController controller = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // --- Title ---
              Text(
                "Create\nYour Account",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Sign up to get started",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),

              // --- Input Fields ---
              _buildInputField(context, controller.fullNameController,
                  "Fullname", "Enter Fullname", Icons.person),
              const SizedBox(height: 15),
              _buildInputField(context, controller.emailController, "Email",
                  "Enter your email", Icons.email),
              const SizedBox(height: 15),
              _buildInputField(context, controller.phoneController, "Email",
                  "Enter your Phone Number", Icons.phone),
              const SizedBox(height: 15),
              _buildInputField(context, controller.passwordController,
                  "Password", "Enter your password", Icons.lock,
                  obscure: true),

              const SizedBox(height: 15),
              _buildInputField(context, controller.confirmPasswordController,
                  "confirm Password", "comfirm your password", Icons.lock,
                  obscure: true),

              const SizedBox(height: 15),

              // --- Sign Up Button ---
              Obx(
                () => Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.register();
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
                        : const Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Login Link ---
              Center(
                child: GestureDetector(
                  onTap: controller.goToLogin,
                  child: Text(
                    "Already have an account? Log In",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context,
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
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
        hintText: hint,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onBackground.withOpacity(0.8),
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onBackground.withOpacity(0.5),
        ),
        prefixIcon: Icon(icon,
            color: colorScheme.onBackground.withOpacity(isDark ? 0.8 : 0.6)),
        filled: true,
        fillColor: isDark ? Colors.white12 : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
