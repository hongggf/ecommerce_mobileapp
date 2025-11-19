import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/controller/theme_controller.dart';
import 'package:ecommerce_urban/app/widgets/item_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/profile/profile_controller.dart';
import 'package:ecommerce_urban/modules/profile/widgets/user_header_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final RxString userName = "John Doe".obs;
  final RxBool isDarkMode = false.obs;

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingSM),
          child: Column(
            children: [
              _profileSection(),
              SizedBox(height: AppSpacing.paddingXXL),
              Expanded(
                child: ListView(
                  children: [
                    _userInfoSection(),
                    SizedBox(height: AppSpacing.paddingXL),
                    _orderHistorySection(),
                    SizedBox(height: AppSpacing.paddingXL),
                    _logoutSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileSection(){
    return UserHeaderCardWidget(
      name: userName,
      rightIcons: [
        UserHeaderRightIcon(
          icon: themeController.isDarkMode.value
              ? Icons.dark_mode
              : Icons.light_mode,
          onTap: themeController.toggleTheme,
        ),
        UserHeaderRightIcon(
          icon: Icons.settings,
          onTap: () => print("Settings clicked"),
        ),
      ],
    );
  }

  Widget _userInfoSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: "User Information"),
        ItemWidget(
          item: CardItem(
            icon: Icons.key,
            title: "00001",
            description: "User ID",
            rightIcon: Icons.edit,
            onTapCard: () => print("Account tapped"),
            onTapRightIcon: () => print("Right icon tapped"),
          ),
        ),
        ItemWidget(
          item: CardItem(
            icon: Icons.person,
            title: "LIM HONG",
            description: "Username",
            rightIcon: Icons.edit,
            onTapCard: () => print("Account tapped"),
            onTapRightIcon: () => print("Right icon tapped"),
          ),
        ),
        ItemWidget(
          item: CardItem(
            icon: Icons.alternate_email,
            title: "limhong@gmail.com",
            description: "Email",
            rightIcon: Icons.edit,
            onTapCard: () => print("Account tapped"),
            onTapRightIcon: () => print("Right icon tapped"),
          ),
        ),
      ],
    );
  }

  Widget _orderHistorySection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: "Order"),
        ItemWidget(
          item: CardItem(
            icon: Icons.delivery_dining,
            title: "Your Order",
            rightIcon: Icons.arrow_forward_rounded,
            onTapCard: () => print("Account tapped"),
          ),
        ),
      ],
    );
  }

  Widget _logoutSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: "Logout"),
        ItemWidget(
          item: CardItem(
            icon: Icons.login,
            title: "Logout",
            onTapCard: () => print("Account tapped"),
          ),
        ),
      ],
    );
  }
}
