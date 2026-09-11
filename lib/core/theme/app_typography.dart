import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.regular,
    required this.medium,
    required this.semiBold,
    required this.bold,
  });

  final TextStyle regular;
  final TextStyle medium;
  final TextStyle semiBold;
  final TextStyle bold;

  @override
  AppTypography copyWith({
    TextStyle? regular,
    TextStyle? medium,
    TextStyle? semiBold,
    TextStyle? bold,
  }) {
    return AppTypography(
      regular: regular ?? this.regular,
      medium: medium ?? this.medium,
      semiBold: semiBold ?? this.semiBold,
      bold: bold ?? this.bold,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) {
      return this;
    }

    return AppTypography(
      regular: TextStyle.lerp(regular, other.regular, t) ?? regular,
      medium: TextStyle.lerp(medium, other.medium, t) ?? medium,
      semiBold: TextStyle.lerp(semiBold, other.semiBold, t) ?? semiBold,
      bold: TextStyle.lerp(bold, other.bold, t) ?? bold,
    );
  }
}
