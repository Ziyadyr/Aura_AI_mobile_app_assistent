import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    
    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 57.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 45.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 36.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.29,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.33,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  // Pre-defined text styles for convenience
  static TextStyle get h1 => textTheme.displayLarge!;
  static TextStyle get h2 => textTheme.displayMedium!;
  static TextStyle get h3 => textTheme.displaySmall!;
  static TextStyle get h4 => textTheme.headlineLarge!;
  static TextStyle get h5 => textTheme.headlineMedium!;
  static TextStyle get h6 => textTheme.headlineSmall!;
  
  static TextStyle get subtitle1 => textTheme.titleLarge!;
  static TextStyle get subtitle2 => textTheme.titleMedium!;
  static TextStyle get subtitle3 => textTheme.titleSmall!;
  
  static TextStyle get bodyLarge => textTheme.bodyLarge!;
  static TextStyle get bodyMedium => textTheme.bodyMedium!;
  static TextStyle get bodySmall => textTheme.bodySmall!;
  static TextStyle get caption => textTheme.bodySmall!.copyWith(
    fontSize: 11.sp,
    color: const Color(0xFF6B7280),
  );
  
  static TextStyle get button => textTheme.labelLarge!;
  static TextStyle get overline => textTheme.labelSmall!;
  
  static TextStyle get labelLarge => textTheme.labelLarge!;
  static TextStyle get labelMedium => textTheme.labelMedium!;
  static TextStyle get labelSmall => textTheme.labelSmall!;
}