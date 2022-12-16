import 'package:chatmate/Utilities/colors.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';
class Decorations{

  static InputDecoration textBoxDecorations(BuildContext context,labelText,hintText){
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: ThemeColors.secondaryColor,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
          color: Colors.white54
      ),
      focusedBorder: Decorations.textBoxBorders(context),
      enabledBorder: Decorations.textBoxBorders(context),
      errorBorder: Decorations.textBoxBorders(context),
      disabledBorder: Decorations.textBoxBorders(context),
      focusedErrorBorder: Decorations.textBoxBorders(context),
    );
  }
  static InputBorder textBoxBorders(BuildContext context){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: ThemeColors.secondaryColor,
      ),
    );
  }

  static InputBorder textsBoxBorders(BuildContext context){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: ThemeColors.secondaryColor,
      ),
    );
  }
}
