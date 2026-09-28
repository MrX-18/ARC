import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arcRepo = ArcRepository();
    final achievements = arcRepo.achievements;
    final unlockedCount = achievements.where((a) => a.unlocked).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ACHIEVEMENTS',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRANSFORMATION MILESTONES',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'MEANINGFUL MOMENTS',
                style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                '$unlockedCount of ${achievements.length} milestones unlocked. Genuine consistency over gimmicks.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: achievements.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final ach = achievements[idx];

                  return ArcCard(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ach.unlocked
                                ? AppColors.gold.withOpacity(0.15)
                                : AppColors.surfaceElevated,
                            border: Border.all(
                              color: ach.unlocked ? AppColors.gold : AppColors.border,
                            ),
                          ),
                          child: Icon(
                            ach.unlocked ? Icons.verified_rounded : Icons.lock_outline_rounded,
                            color: ach.unlocked ? AppColors.gold : AppColors.textTertiary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ach.title,
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: ach.unlocked ? AppColors.textPrimary : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                ach.description,
                                style: AppTypography.bodySmall.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        if (ach.unlocked)
                          const Icon(Icons.check_rounded, color: AppColors.gold, size: 18)
                        else
                          Text(
                            'LOCKED',
                            style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
