import 'package:ecommerce_urban/modules/profile_management/profile_management_controller.dart';
import 'package:ecommerce_urban/modules/profile_management/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileManagementView extends GetView<ProfileManagementController> {
  const ProfileManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Profile Management',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isEditing.value ? Icons.close : Icons.edit,
                  color: const Color(0xFF1A1A1A),
                ),
                onPressed: controller.toggleEditMode,
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.userProfile.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
          );
        }

        final profile = controller.userProfile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(profile),
              const SizedBox(height: 24),
              Obx(() => controller.isEditing.value
                  ? _buildEditForm(context)
                  : _buildViewMode(profile)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(UserProfileModel profile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6C63FF),
                    width: 3,
                  ),
                  image: profile.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(profile.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profile.avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF6C63FF),
                      )
                    : null,
              ),
              Obx(() => controller.isEditing.value
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C63FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${profile.username}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                profile.bio!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildViewMode(UserProfileModel profile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.badge,
            title: 'User ID',
            value: profile.userId,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.person,
            title: 'Username',
            value: profile.username,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.email,
            title: 'Email',
            value: profile.email,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.person_outline,
            title: 'Full Name',
            value: profile.fullName,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.phone,
            title: 'Phone Number',
            value: profile.phoneNumber,
          ),
          if (profile.gender != null) ...[
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.wc,
              title: 'Gender',
              value: profile.gender!,
            ),
          ],
          if (profile.dateOfBirth != null) ...[
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.cake,
              title: 'Date of Birth',
              value:
                  '${profile.dateOfBirth!.day}/${profile.dateOfBirth!.month}/${profile.dateOfBirth!.year}',
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: controller.deleteAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
            ),
            child: const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C63FF), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              controller: controller.usernameController,
              label: 'Username',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.fullNameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.bioController,
              label: 'Bio',
              icon: Icons.info_outline,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildGenderSelector(),
            const SizedBox(height: 16),
            _buildDateSelector(context),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.toggleEditMode,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'Male',
                      groupValue: controller.selectedGender.value,
                      onChanged: (value) {
                        controller.selectedGender.value = value ?? '';
                      },
                      title: const Text('Male'),
                      activeColor: const Color(0xFF6C63FF),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'Female',
                      groupValue: controller.selectedGender.value,
                      onChanged: (value) {
                        controller.selectedGender.value = value ?? '';
                      },
                      title: const Text('Female'),
                      activeColor: const Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => InkWell(
              onTap: () => controller.selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cake, color: Color(0xFF6C63FF)),
                    const SizedBox(width: 16),
                    Text(
                      controller.selectedDate.value != null
                          ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                          : 'Select date of birth',
                      style: TextStyle(
                        fontSize: 16,
                        color: controller.selectedDate.value != null
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
