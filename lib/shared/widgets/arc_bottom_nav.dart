import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class ArcBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ArcBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1.0),
        ),
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom
            : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            index: 0,
            currentIndex: currentIndex,
            label: 'HOME',
            icon: Icons.home_rounded,
            onTap: () => onTap(0),
          ),
          _NavItem(
            index: 1,
            currentIndex: currentIndex,
            label: 'CARDS',
            icon: Icons.grid_view_rounded,
            onTap: () => onTap(1),
          ),
          _NavItem(
            index: 2,
            currentIndex: currentIndex,
            label: 'ARCS',
            icon: Icons.layers_rounded,
            onTap: () => onTap(2),
          ),
          _NavItem(
            index: 3,
            currentIndex: currentIndex,
            label: 'PROFILE',
            icon: Icons.person_outline_rounded,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final color = isSelected ? AppColors.gold : AppColors.textTertiary;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.labelUppercase.copyWith(
                fontSize: 10,
                letterSpacing: 1.5,
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 14,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}
