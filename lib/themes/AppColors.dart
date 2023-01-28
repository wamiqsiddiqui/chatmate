import 'package:flutter/material.dart';

class AppColors {
  static const white = Colors.white;
  static const black = Colors.black;
  static const primaryColor = Color(0xFF8C1749);
  static const secondaryColor = Color(0xFFFFA500);
  static const tertiaryColor = Color(0xFFD4D4D4);
  static const errorColor = Color(0xFFF55353);
  static const successGreenColor = Color(0xFF0FC982);
  static const dividerGrey = Color(0xFFCFD8DC);
  static const disabledGrey = Color(0xFFC1C5D2);
  static const bgGrey = Color(0xFFC1C5DC);
  static const backgroundColor = Color(0xFFFFFFFF);
  static const scaffoldBackgroundColor = Color(0xFFF6F6F9);
  static const transparent = Colors.transparent;
  static const MaterialColor customPrimary =
      MaterialColor(0xFFb9a80d, <int, Color>{
    50: Color.fromRGBO(78, 177, 203, .1),
    100: Color.fromRGBO(78, 177, 203, .2),
    200: Color.fromRGBO(78, 177, 203, .3),
    300: Color.fromRGBO(78, 177, 203, .4),
    400: Color.fromRGBO(78, 177, 203, .5),
    500: Color.fromRGBO(78, 177, 203, .6),
    600: Color.fromRGBO(78, 177, 203, .7),
    700: Color.fromRGBO(78, 177, 203, .8),
    800: Color.fromRGBO(78, 177, 203, .9),
    900: Color.fromRGBO(78, 177, 203, 1),
  });
}

class ThemeColors {
  static const white = Colors.white;
  static const black = Colors.black;
  static const primaryColor = Color.fromARGB(255, 185, 168, 13); //#E84E4E
  static const secondaryColor = Color.fromARGB(255, 255, 255, 255);
  static const senderColor = Color.fromARGB(255, 184, 175, 93); //#FF5A3C
  static const receiverColor2 = Color(0xFF4AB471);
  static const receiverColor = Color.fromARGB(255, 146, 161, 165);
  static const senderColor2 = Color(0xFFD96383);
  static const gradient1 = Color.fromARGB(255, 151, 153, 14);
  static const gradient2 = Color.fromARGB(255, 203, 248, 0);
}
