
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class AppTheme{
  ThemeData loadTheme(bool useLightTheme){
    if(useLightTheme){
      return lightTheme;
    }else{
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
      primaryVariant: ThemeColors.primaryColor,
      secondary: ThemeColors.secondaryColor,
      secondaryVariant: ThemeColors.secondaryColor,
      background: AppColors.backgroundColor,
      brightness: Brightness.light,
      onBackground: AppColors.black,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onError: AppColors.white,
      onSurface: AppColors.black, 
      surface: AppColors.white,
      error: AppColors.errorColor
    ), 
  );
  ThemeData darkTheme = ThemeData();
}