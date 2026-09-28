import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';
import 'fitness_lifestyle_analytics_screen.dart';
import 'progress_calendar_screen.dart';
import 'body_progress_screen.dart';
import 'weekly_review_screen.dart';

class ProgressOverviewScreen extends StatelessWidget {
  const ProgressOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arcRepo = ArcRepository();
    final active = arcRepo.activeArc;
    final enrolled = arcRepo.enrolledArcs;

    final completedArcs = enrolled.where((a) => a.status == ArcStatus.completed).length;
    final totalDaysDone = enrolled.fold<int>(0, (sum, a) => sum + (a.status == ArcStatus.completed ? a.durationDays : a.currentDay));
    final activeStreak = active != null ? (active.currentDay > 6 ? 6 : active.currentDay) : 0;
    final missionsCount = arcRepo.activityLogs.length + (totalDaysDone * 2);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'PROGRESS OVERVIEW',
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
                'TRANSFORMATION METRICS',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'YOUR PROGRESS',
                style: AppTypography.titleLarge.copyWith(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Measured by finished chapters, not arbitrary points.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Most Important Metric: ARCS COMPLETED
              ArcCard(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold.withOpacity(0.12),
                        border: Border.all(color: AppColors.borderGold, width: 1.5),
                      ),
                      child: const Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 28),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ARCS COMPLETED',
                            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedArcs CHAPTERS',
                            style: AppTypography.titleLarge.copyWith(fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Long-term personal milestones sealed',
                            style: AppTypography.bodySmall.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Secondary Metrics Grid: DAYS DONE | MISSIONS | STREAK | CONSISTENCY
              Row(
                children: [
                  Expanded(
                    child: ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DAYS COMPLETED', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Text('$totalDaysDone', style: AppTypography.titleLarge.copyWith(fontSize: 24, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MISSIONS DONE', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Text('$missionsCount', style: AppTypography.titleLarge.copyWith(fontSize: 24, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ACTIVE STREAK', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Text('$activeStreak DAYS', style: AppTypography.titleLarge.copyWith(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.goldLight)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('OVERALL CONSISTENCY', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Text('85%', style: AppTypography.titleLarge.copyWith(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.gold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Deep Analytics Nav Links
              Text(
                'DEEP EXPLORATION',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),

              ArcCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bar_chart_rounded, color: AppColors.gold),
                      title: Text('FITNESS & LIFESTYLE TRENDS', style: AppTypography.labelUppercase.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
                      subtitle: Text('Training volume, sleep & hydration curves', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textTertiary),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FitnessLifestyleAnalyticsScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    ListTile(
                      leading: const Icon(Icons.calendar_today_rounded, color: AppColors.gold),
                      title: Text('GLOBAL JOURNEY CALENDAR', style: AppTypography.labelUppercase.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
                      subtitle: Text('Full multi-month activity matrix', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textTertiary),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProgressCalendarScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    ListTile(
                      leading: const Icon(Icons.photo_camera_back_outlined, color: AppColors.gold),
                      title: Text('BODY & TRANSFORMATION LOG', style: AppTypography.labelUppercase.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
                      subtitle: Text('Optional, private before & current progress', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textTertiary),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BodyProgressScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    ListTile(
                      leading: const Icon(Icons.rate_review_outlined, color: AppColors.gold),
                      title: Text('WEEKLY REVIEW', style: AppTypography.labelUppercase.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
                      subtitle: Text('End of week reflection and calibration', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textTertiary),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WeeklyReviewScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
