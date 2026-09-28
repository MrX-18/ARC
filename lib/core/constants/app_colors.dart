import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFF0B0B0D);
  static const Color backgroundSecondary = Color(0xFF101014);

  // Surface / Cards
  static const Color surface = Color(0xFF141417);
  static const Color surfaceElevated = Color(0xFF1B1B20);
  static const Color surfaceLight = Color(0xFF222228);

  // Borders
  static const Color border = Color(0x1FFFFFFF); // 12% white
  static const Color borderSubtle = Color(0x0FFFFFFF); // 6% white
  static const Color borderGold = Color(0xFFE5C287);
  static const Color borderGoldGlow = Color(0x55E5C287);

  // Typography
  static const Color textPrimary = Color(0xFFF5F2EB);
  static const Color textSecondary = Color(0xFF8E8D92);
  static const Color textTertiary = Color(0xFF5E5D62);
  static const Color textDark = Color(0xFF0B0B0D);

  // Gold / Champagne Accents
  static const Color gold = Color(0xFFE5C287);
  static const Color goldLight = Color(0xFFF3DEC0);
  static const Color goldDark = Color(0xFFB59356);
  static const Color goldMuted = Color(0xFFDFB574);
  static const Color goldCorona = Color(0xFFE9CFA4);

  // Primary CTA Button
  static const Color ctaBackground = Color(0xFFF5E8D0);
  static const Color ctaText = Color(0xFF0B0B0D);

  // Chips & Badges
  static const Color chipBackground = Color(0xFF1C1B1F);
  static const Color chipBorder = Color(0x28FFFFFF);
  static const Color activeBadge = Color(0xFFD4A760);
  static const Color completedBadge = Color(0xFF75B97C);

  // Progress Bar
  static const Color progressTrack = Color(0xFF26262B);
  static const Color progressFill = Color(0xFFE5C287);

  // Status & Utility
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF81C784);
  static const Color notificationDot = Color(0xFFE53935);

  // Gradients
  static const LinearGradient goldTextGradient = LinearGradient(
    colors: [Color(0xFFFFF7ED), Color(0xFFE5C287)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldArcGradient = LinearGradient(
    colors: [Color(0xFFFFF2D9), Color(0xFFDFB574), Color(0x00DFB574)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC0B0B0D), Color(0xFA0B0B0D)],
    stops: [0.0, 0.65, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
