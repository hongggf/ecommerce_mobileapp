import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminUsersController>();

    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final RxString selectedStatus = 'active'.obs;
    final RxBool showPassword = false.obs;
    final RxBool showConfirmPassword = false.obs;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create New User'),
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'User Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: const Icon(Icons.person, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: const Icon(Icons.email, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone (Optional)',
                  prefixIcon: const Icon(Icons.phone, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Password Section
              const Text(
                'Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Password
              Obx(() {
                return TextFormField(
                  controller: passwordController,
                  obscureText: !showPassword.value,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                      onPressed: () => showPassword.value = !showPassword.value,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),

              // Confirm Password
              Obx(() {
                return TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !showConfirmPassword.value,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password *',
                    prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirmPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                      onPressed: () => showConfirmPassword.value =
                          !showConfirmPassword.value,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 20),

              // Status Section
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                return DropdownButtonFormField<String>(
                  value: selectedStatus.value,
                  decoration: InputDecoration(
                    labelText: 'User Status',
                    prefixIcon:
                        const Icon(Icons.check_circle, color: Colors.purple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['active', 'inactive']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                                status == 'active' ? 'Active' : 'Inactive'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedStatus.value = value;
                    }
                  },
                );
              }),
              const SizedBox(height: 40),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isLoadingUsers.value
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              controller.createUser({
                                'full_name': fullNameController.text,
                                'email': emailController.text,
                                'phone': phoneController.text,
                                'password': passwordController.text,
                                'status': selectedStatus.value,
                              });

                              Future.delayed(const Duration(seconds: 2), () {
                                fullNameController.dispose();
                                emailController.dispose();
                                phoneController.dispose();
                                passwordController.dispose();
                                confirmPasswordController.dispose();
                                Get.back();
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoadingUsers.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Create User',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
