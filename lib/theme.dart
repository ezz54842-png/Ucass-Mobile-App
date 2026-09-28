import 'package:flutter/material.dart';

class Brand {
  static const blue = Color(0xFF1767B1);
  static const green = Color(0xFF72BF44);
  static const charcoal = Color(0xFF343033);
  static const bg = Color(0xFFF5F8FC);
  static const border = Color(0xFFE1E8F0);
  static const softBlue = Color(0xFFEAF4FF);
  static const softGreen = Color(0xFFEEF8E8);
}

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Brand.blue).copyWith(primary: Brand.blue, secondary: Brand.green, surface: Colors.white),
      scaffoldBackgroundColor: Brand.bg,
      appBarTheme: const AppBarTheme(backgroundColor: Brand.bg, surfaceTintColor: Colors.transparent, centerTitle: false),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Brand.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Brand.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Brand.blue, width: 1.4)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Brand.border)),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
    );
