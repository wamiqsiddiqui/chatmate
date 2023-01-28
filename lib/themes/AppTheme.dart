import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._private();
  static final instance = AppTheme._private();
  factory AppTheme() => instance;
  ThemeData loadTheme(bool useLightTheme) {
    if (useLightTheme) {
      return lightTheme;
    } else {
      return darkTheme;
    }
  }

  ThemeData lightTheme = ThemeData(
      primarySwatch: AppColors.customPrimary,
      backgroundColor: AppColors.backgroundColor,
      errorColor: AppColors.errorColor,
      focusColor: AppColors.transparent,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      disabledColor: AppColors.disabledGrey,
      dividerColor: AppColors.dividerGrey,
      hintColor: AppColors.bgGrey.withOpacity(0.8),
      colorScheme: ColorScheme(
          primary: ThemeColors.primaryColor,
          secondary: ThemeColors.secondaryColor,
          background: AppColors.backgroundColor,
          brightness: Brightness.light,
          onBackground: AppColors.black,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onError: AppColors.white,
          onSurface: AppColors.black,
          surface: AppColors.white,
          error: AppColors.errorColor),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: ThemeColors.primaryColor,
        ),
        hintStyle: TextStyle(color: Colors.white54),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeColors.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeColors.primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeColors.secondaryColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
      ));
  ThemeData darkTheme = ThemeData();
}
