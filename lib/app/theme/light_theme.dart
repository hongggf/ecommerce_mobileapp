import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/theme/constant/text_theme.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.lightTextPrimary,
    onSurface: AppColors.lightTextPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  
  textTheme: AppTextTheme.lightTextTheme,
  cardColor: AppColors.lightSurface,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey,
    elevation: 8.0,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
);
