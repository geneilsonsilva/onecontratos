import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFff5101);
  static const Color secondaryColor = Colors.orange;
  static const Color backgroundColor = Color.fromARGB(255, 224, 213, 213);
  static const Color accentColor = Color(0xFF000000);
  static const Color white = Colors.white;
  static const Color textColor = Color.fromARGB(255, 243, 243, 243);
  static const Color backgroundRox = Color(0xFF5B6AD0);
  static const Color cardDash = Color(0xFFF8F8F8);
  static const Color menu = Color(0xFF555555);
  static const Color decoretionMenu = Color(0xFFd7d7d7);

  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.yellow;
  static const Color successColor = Colors.teal;
}

class ThemeConfig {
  static ThemeModel defaultTheme = ThemeModel(
    primaryColor: const Color.fromARGB(255, 245, 142, 57),
    secondaryColor: Colors.orange,
    backgroundColor: const Color.fromARGB(255, 224, 213, 213),
    textColor: const Color.fromARGB(255, 243, 243, 243),
    headlineStyle: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: Color(0xFFAFB1B5),
    ),
    subtitleStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Color(0xFF404D61),
    ),
    subtitleSearchStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: Color(0xFF404D61),
    ),
    bodyTextStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Color(0xFF757D8A),
    ),
    valueTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF404D61),
    ),
    textStyleNormal: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF404D61),
    ),
  );
}

class ThemeModel {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle headlineStyle;
  final TextStyle subtitleStyle;
  final TextStyle subtitleSearchStyle;
  final TextStyle bodyTextStyle;
  final TextStyle valueTextStyle;
  final TextStyle textStyleNormal;

  ThemeModel({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.headlineStyle,
    required this.subtitleStyle,
    required this.subtitleSearchStyle,
    required this.bodyTextStyle,
    required this.valueTextStyle,
    required this.textStyleNormal,
  });
}