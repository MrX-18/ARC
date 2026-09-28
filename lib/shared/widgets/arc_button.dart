import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class ArcButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final bool isSecondary;
  final bool isOutlined;
  final bool isLoading;
  final double height;
  final EdgeInsetsGeometry margin;

  const ArcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = true,
    this.isSecondary = false,
    this.isOutlined = false,
    this.isLoading = false,
    this.height = 54,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSecondary = isSecondary || isOutlined;
    final enabled = onPressed != null && !isLoading;

    if (effectiveSecondary) {
      return Padding(
        padding: margin,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: enabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderGold, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height / 2),
              ),
              backgroundColor: Colors.transparent,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: AppTypography.buttonSecondary,
                      ),
                      if (showArrow) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 16, color: AppColors.gold),
                      ],
                    ],
                  ),
          ),
        ),
      );
    }

    return Padding(
      padding: margin,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled
                ? AppColors.ctaBackground
                : AppColors.ctaBackground.withOpacity(0.35),
            foregroundColor: AppColors.ctaText,
            elevation: enabled ? 3 : 0,
            shadowColor: AppColors.goldDark.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.textDark),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: AppTypography.buttonCta.copyWith(
                        color: enabled ? AppColors.ctaText : AppColors.textTertiary,
                      ),
                    ),
                    if (showArrow) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: enabled ? AppColors.ctaText : AppColors.textTertiary,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
