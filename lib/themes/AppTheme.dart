import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class AppTheme {
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
          color: ThemeColors.secondaryColor,
        ),
        hintStyle: TextStyle(color: Colors.white54),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeColors.secondaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeColors.secondaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeColors.secondaryColor,
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
            color: ThemeColors.secondaryColor,
          ),
        ),
      ));
  ThemeData darkTheme = ThemeData();
}
