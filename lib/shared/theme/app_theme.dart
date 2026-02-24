/// App-wide MaterialTheme configuration.
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Provides the Beespoke dark MaterialTheme.
abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.onSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          color: AppColors.surfaceVariant,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          titleMedium: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          bodySmall: TextStyle(
            color: AppColors.onSurface,
            fontSize: 12,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIconColor: Colors.white38,
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primary,
          labelStyle: const TextStyle(color: AppColors.onSurface, fontSize: 12),
          side: const BorderSide(color: AppColors.cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}
