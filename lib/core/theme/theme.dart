import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';
import 'app_typography.dart';
import 'satoshi_text_styles.dart';
class AppTheme {
  AppTheme._();

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Geist',
    // ignore: always_specify_types
    extensions: <ThemeExtension>[
      AppTypography(
        regular: SatoshiTextStyles.regular(14.sp),
        medium: SatoshiTextStyles.medium(14.sp),
        semiBold: SatoshiTextStyles.semiBold(14.sp),
        bold: SatoshiTextStyles.bold(14.sp),
      ),
      const AppColorScheme(
        background1: Color(0xFFFFFFFF),
        background2: Color(0xFFF9F9F9),
        background3: Color(0xFFF2F2F2),
        background4: Color(0xFFE8E8E8),
        background5: Color(0xFFDADADA),
      ),
    ],
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Geist',
    // ignore: always_specify_types
    extensions: <ThemeExtension>[
      AppTypography(
        regular: SatoshiTextStyles.regular(14.sp),
        medium: SatoshiTextStyles.medium(14.sp),
        semiBold: SatoshiTextStyles.semiBold(14.sp),
        bold: SatoshiTextStyles.bold(14.sp),
      ),
      const AppColorScheme(
        background1: Color(0xFFFFFFFF),
        background2: Color(0xFFF9F9F9),
        background3: Color(0xFFF2F2F2),
        background4: Color(0xFFE8E8E8),
        background5: Color(0xFFDADADA),
      ),
    ],
  );
}
