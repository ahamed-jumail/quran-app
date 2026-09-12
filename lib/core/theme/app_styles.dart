// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const String displayFont = 'Fraunces';
const String bodyFont = 'Manrope';

extension CustomTextTheme on TextTheme {
  TextStyle get fraunces18SemiBold => TextStyle(
    fontFamily: displayFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get fraunces20Medium => TextStyle(
    fontFamily: displayFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get fraunces20SemiBold => TextStyle(
    fontFamily: displayFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get fraunces22SemiBold => TextStyle(
    fontFamily: displayFont,
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get fraunces24SemiBold => TextStyle(
    fontFamily: displayFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get fraunces24Bold => TextStyle(
    fontFamily: displayFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get fraunces28Medium => TextStyle(
    fontFamily: displayFont,
    fontSize: 28.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get fraunces28SemiBold => TextStyle(
    fontFamily: displayFont,
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get fraunces32SemiBold => TextStyle(
    fontFamily: displayFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get fraunces32Bold => TextStyle(
    fontFamily: displayFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get fraunces36Bold => TextStyle(
    fontFamily: displayFont,
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get fraunces40Bold => TextStyle(
    fontFamily: displayFont,
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get fraunces52Bold => TextStyle(
    fontFamily: displayFont,
    fontSize: 52.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope10Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope12Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope13Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope14Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope16Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope18Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope20Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope22Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope24Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope30Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 30.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope32Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope36Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope40Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 40.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope52Regular => TextStyle(
    fontFamily: bodyFont,
    fontSize: 52.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle get manrope10Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 10.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope12Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope14Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope16Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope18Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope20Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope24Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope32Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope36Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 36.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope40Light => TextStyle(
    fontFamily: bodyFont,
    fontSize: 40.sp,
    fontWeight: FontWeight.w300,
  );

  TextStyle get manrope10Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope12Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope14Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope16Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope18Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope20Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope24Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope28Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 28.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope32Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope36Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 36.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope40Medium => TextStyle(
    fontFamily: bodyFont,
    fontSize: 40.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle get manrope10SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope12SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope13SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope14SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope16SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope18SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope20SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope24SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope32SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope36SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope40SemiBold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle get manrope8Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 8.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope10Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope12Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope13Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope14Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope16Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope18Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope20Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope24Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope32Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope34Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 34.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope36Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope40Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle get manrope60Bold => TextStyle(
    fontFamily: bodyFont,
    fontSize: 60.sp,
    fontWeight: FontWeight.w700,
  );
}
