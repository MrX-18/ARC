import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ArcCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const ArcCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16,
    this.isSelected = false,
    this.onTap,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final border = isSelected
        ? Border.all(color: AppColors.borderGold, width: 1.4)
        : Border.all(color: AppColors.border, width: 1.0);

    final boxShadow = isSelected
        ? [
            BoxShadow(
              color: AppColors.borderGoldGlow.withOpacity(0.25),
              blurRadius: 16,
              spreadRadius: -2,
            ),
          ]
        : null;

    final content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Padding(
        padding: margin,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: AppColors.gold.withOpacity(0.08),
            highlightColor: AppColors.gold.withOpacity(0.04),
            child: content,
          ),
        ),
      );
    }

    return Padding(
      padding: margin,
      child: content,
    );
  }
}
