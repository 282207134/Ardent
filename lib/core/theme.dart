import 'package:flutter/material.dart';

abstract final class AppColors {
  static const red = Color(0xFFD03030);
  static const blue = Color(0xFF5888F6);
  static const ink = Color(0xFF191919);
  static const muted = Color(0xFF909090);
  static const pale = Color(0xFFE7F1F8);
  static const surface = Color(0xFFF1F1F1);
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'SourceSans',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.blue,
    primary: AppColors.blue,
    secondary: AppColors.red,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.ink, height: 1.2),
    bodySmall: TextStyle(fontSize: 13, color: AppColors.muted),
    titleLarge: TextStyle(fontSize: 24, height: 1.1),
    titleMedium: TextStyle(fontSize: 20, height: 1.2),
  ),
  dividerColor: const Color(0xFFE5E5E5),
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
    labelStyle: TextStyle(color: AppColors.muted),
    contentPadding: EdgeInsets.symmetric(vertical: 10),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.muted),
    ),
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.ink,
    unselectedLabelColor: AppColors.muted,
    indicatorColor: AppColors.blue,
    indicatorSize: TabBarIndicatorSize.tab,
    labelStyle: TextStyle(fontFamily: 'SourceSans', fontSize: 15),
  ),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
);
