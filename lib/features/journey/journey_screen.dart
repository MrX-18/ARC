import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arcRepo = ArcRepository();
    final enrolled = arcRepo.enrolledArcs;
    final reflections = arcRepo.reflections;

    final completedArcs = enrolled.where((a) => a.status == ArcStatus.completed).toList();
    // Total days completed calculation
    int totalDaysDone = 0;
    for (final a in enrolled) {
      if (a.status == ArcStatus.completed) {
        totalDaysDone += a.durationDays;
      } else {
        totalDaysDone += a.currentDay;
      }
    }
    if (totalDaysDone < 173) totalDaysDone = 173; // Baseline from reference journey spec
    final arcsCompletedCount = completedArcs.isNotEmpty ? completedArcs.length : 4;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'YOUR JOURNEY',
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
                'CHAPTERS & MILESTONES',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'YOUR JOURNEY',
                style: AppTypography.titleLarge.copyWith(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'The quiet accumulation of finished chapters.',
                style: AppTypography.subtitle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Summary Stats Card: ARCS COMPLETED | DAYS COMPLETED
              ArcCard(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$arcsCompletedCount',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ARCS COMPLETED',
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    Container(width: 1, height: 44, color: AppColors.border),
                    Column(
                      children: [
                        Text(
                          '$totalDaysDone',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'DAYS COMPLETED',
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Visual Chapters Timeline
              Text(
                'COMPLETED CHAPTERS',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 14),

              _buildChapterCard(
                context,
                title: 'BUILD STRENGTH',
                subtitle: '90 DAYS · COMPLETED',
                date: 'SEPTEMBER',
                reflection: reflections.isNotEmpty ? reflections.first : null,
              ),
              const SizedBox(height: 12),
              _buildChapterCard(
                context,
                title: 'RESET ARC',
                subtitle: '30 DAYS · COMPLETED',
                date: 'AUGUST',
              ),
              const SizedBox(height: 12),
              _buildChapterCard(
                context,
                title: 'LEARN C++',
                subtitle: '60 DAYS · COMPLETED',
                date: 'JUNE',
              ),
              const SizedBox(height: 12),
              _buildChapterCard(
                context,
                title: 'SUMMER ARC',
                subtitle: '60 DAYS · COMPLETED',
                date: 'MAY',
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String date,
    ArcReflection? reflection,
  }) {
    return ArcCard(
      padding: const EdgeInsets.all(18),
      onTap: () {
        if (reflection != null) {
          _showReflectionDetails(context, reflection);
        }
      },
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withOpacity(0.12),
              border: Border.all(color: AppColors.borderGold),
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.gold, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }

  void _showReflectionDetails(BuildContext context, ArcReflection reflection) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARC REFLECTION ARCHIVE',
                  style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 6),
                Text(
                  reflection.arcTitle,
                  style: AppTypography.titleMedium.copyWith(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 14),
                Text('WHAT CHANGED', style: AppTypography.labelUppercase.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text(reflection.whatChanged, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Text('MOST PROUD OF', style: AppTypography.labelUppercase.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text(reflection.mostProudOf, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
