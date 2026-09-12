import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_styles.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: bodyFont,
    scaffoldBackgroundColor: AppColors.surfaceBase,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.emerald,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.gold,
      onSecondary: AppColors.surfaceBase,
      tertiary: AppColors.goldLight,
      onTertiary: AppColors.surfaceBase,
      surface: AppColors.surfaceRaised,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.surfaceBase,
      outline: AppColors.divider,
    ),
    textTheme: TextTheme(
      displayLarge: const TextTheme().fraunces40Bold,
      displayMedium: const TextTheme().fraunces36Bold,
      displaySmall: const TextTheme().fraunces32Bold,
      headlineLarge: const TextTheme().fraunces28Medium,
      headlineMedium: const TextTheme().fraunces24SemiBold,
      headlineSmall: const TextTheme().fraunces20SemiBold,
      titleLarge: const TextTheme().fraunces20Medium,
      titleMedium: const TextTheme().manrope16SemiBold,
      titleSmall: const TextTheme().manrope14SemiBold,
      bodyLarge: const TextTheme().manrope16Regular,
      bodyMedium: const TextTheme().manrope14Regular,
      bodySmall: const TextTheme().manrope12Regular,
      labelLarge: const TextTheme().manrope14Medium,
      labelMedium: const TextTheme().manrope12Medium,
      labelSmall: const TextTheme().manrope10Medium,
    ).apply(
      displayColor: AppColors.textPrimary,
      bodyColor: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceRaised,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceOverlay,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surfaceOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.surfaceBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.surfaceBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceRaised,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.emerald),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.emerald),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.goldLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.divider),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceOverlay,
      contentTextStyle: const TextStyle(color: AppColors.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.textSecondary),
  );
}
