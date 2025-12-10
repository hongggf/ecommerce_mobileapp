import 'package:ecommerce_urban/modules/customer_profile_management/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileManagementController extends GetxController {
  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;

  // Form controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final RxString selectedGender = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.onClose();
  }

  void loadUserProfile() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      userProfile.value = UserProfileModel(
        userId: '00001',
        username: 'LIM HONG',
        email: 'limhong@gmail.com',
        fullName: 'Lim Hong Sovannarith',
        phoneNumber: '+855 12 345 678',
        bio: 'Love shopping and technology enthusiast',
        avatarUrl: 'https://ui-avatars.com/api/?name=Lim+Hong&size=200',
        dateOfBirth: DateTime(1995, 5, 15),
        gender: 'Male',
      );
      _populateForm();
      isLoading.value = false;
    });
  }

  void _populateForm() {
    if (userProfile.value != null) {
      usernameController.text = userProfile.value!.username;
      emailController.text = userProfile.value!.email;
      fullNameController.text = userProfile.value!.fullName;
      phoneController.text = userProfile.value!.phoneNumber;
      bioController.text = userProfile.value?.bio ?? '';
      selectedGender.value = userProfile.value?.gender ?? '';
      selectedDate.value = userProfile.value?.dateOfBirth;
    }
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      _populateForm(); // Reset form if cancel editing
    }
  }

  void updateProfile() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      userProfile.value = userProfile.value!.copyWith(
        username: usernameController.text,
        email: emailController.text,
        fullName: fullNameController.text,
        phoneNumber: phoneController.text,
        bio: bioController.text,
        gender: selectedGender.value.isEmpty ? null : selectedGender.value,
        dateOfBirth: selectedDate.value,
      );
      isEditing.value = false;
      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  void deleteAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Account Deleted',
                'Your account has been deleted',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              // Navigate to login or home
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(1995),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C63FF),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }
}
