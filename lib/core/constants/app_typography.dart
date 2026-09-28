import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Primary Font: Outfit (cinematic, clean geometric sans) - cached statically for performance
  static final TextStyle titleLarge = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  static final TextStyle titleMedium = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static final TextStyle titleSmall = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  // Subtitles / Body
  static final TextStyle subtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static final TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  // Labels (Uppercase with generous letter spacing)
  static final TextStyle labelUppercase = GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: AppColors.textSecondary,
  );

  static final TextStyle labelUppercaseGold = GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: AppColors.gold,
  );

  static final TextStyle labelStepProgress = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  // Buttons
  static final TextStyle buttonCta = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.8,
    color: AppColors.ctaText,
  );

  static final TextStyle buttonSecondary = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.gold,
  );

  // Card Content
  static final TextStyle cardTitle = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static final TextStyle cardSubtitle = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ARC Branding Wordmark
  static final TextStyle brandWordmark = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 6.0,
    color: AppColors.textPrimary,
  );

  static final TextStyle brandTagline = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 3.5,
    color: AppColors.gold,
  );
}
