import 'package:flutter/material.dart';

class PSColors{
  PSColors._();

  // App Basic Colors
  static const Color primaryColor = Color(0xFF4868FF);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color scanBackground = Color(0x66DEE1E6);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  //Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = PSColors.white.withOpacity(0.1);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C7570);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Colors

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF232323);

  static const Color darkGrey = Color(0xFFA9A9A9);
  static const Color grey = Color(0xFF808080);


  static const Color accentPurpleColor = Color(0xFF6A53A1);
  static const Color accentPinkColor = Color(0xFFF99BBD);
  static const Color accentYellowColor = Color(0xFFFFB612);
}