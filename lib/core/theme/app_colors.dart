import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF4A90D9);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE3F0FB);
  static const Color onPrimaryContainer = Color(0xFF0D3B66);
  
  static const Color secondary = Color(0xFF50C8A3);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE0F5EE);
  static const Color onSecondaryContainer = Color(0xFF0B4D3A);
  
  static const Color tertiary = Color(0xFF7B8CDE);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFE8EBFD);
  static const Color onTertiaryContainer = Color(0xFF1A2654);
  
  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A2E);
  static const Color surfaceVariant = Color(0xFFF5F7FA);
  static const Color onSurfaceVariant = Color(0xFF6B7280);
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color onBackground = Color(0xFF1A1A2E);
  
  // Semantic Colors
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Priority Colors
  static const Color priorityLow = Color(0xFF6B7280);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityCritical = Color(0xFFDC2626);
  
  // Status Colors
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFF6B7280);
  
  // Category Colors
  static const List<Color> categoryColors = [
    Color(0xFF4A90D9),
    Color(0xFF50C8A3),
    Color(0xFF7B8CDE),
    Color(0xFFFF8A5C),
    Color(0xFF9B59B6),
    Color(0xFF1ABC9C),
    Color(0xFFE74C3C),
    Color(0xFFF39C12),
  ];
  
  // Outline
  static const Color outline = Color(0xFFE5E7EB);
  static const Color outlineVariant = Color(0xFFF3F4F6);
  
  // Shadow
  static const Color shadow = Color(0x1A000000);
  static const Color scrim = Color(0x80000000);
  
  // Inverse
  static const Color inverseSurface = Color(0xFF1A1A2E);
  static const Color onInverseSurface = Color(0xFFF8FAFC);
  
  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF6BA3E0);
  static const Color onPrimaryDark = Color(0xFF0D3B66);
  static const Color surfaceDark = Color(0xFF252540);
  static const Color onSurfaceDark = Color(0xFFE8E8EF);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color onBackgroundDark = Color(0xFFE8E8EF);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A90D9), Color(0xFF50C8A3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFFE3F0FB), Color(0xFFE0F5EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}