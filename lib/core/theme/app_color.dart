import 'package:flutter/material.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.background1,
    required this.background2,
    required this.background3,
    required this.background4,
    required this.background5,
  });
  final Color background1;
  final Color background2;
  final Color background3;
  final Color background4;
  final Color background5;
  @override
  AppColorScheme copyWith({
    Color? background1,
    Color? background2,
    Color? background3,
    Color? background4,
    Color? background5,
  }) {
    return AppColorScheme(
      background1: background1 ?? this.background1,
      background2: background2 ?? this.background2,
      background3: background3 ?? this.background3,
      background4: background4 ?? this.background4,
      background5: background5 ?? this.background5,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) {
      return this;
    }
    return AppColorScheme(
      background1: Color.lerp(background1, other.background1, t) ?? background1,
      background2: Color.lerp(background2, other.background2, t) ?? background2,
      background3: Color.lerp(background3, other.background3, t) ?? background3,
      background4: Color.lerp(background4, other.background4, t) ?? background4,
      background5: Color.lerp(background5, other.background5, t) ?? background5,
    );
  }
}
