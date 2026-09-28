import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';

class WeeklyReviewScreen extends StatelessWidget {
  const WeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final active = ArcRepository().activeArc;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'WEEKLY REVIEW',
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
                'END OF WEEK REFLECTION',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'YOUR WEEK',
                style: AppTypography.titleLarge.copyWith(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'A quiet calibration of what worked, what slipped, and where to focus next.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Weekly Metrics Row
              ArcCard(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetric('19 / 21', 'MISSIONS'),
                    _buildDivider(),
                    _buildMetric('6 / 7', 'DAYS COMPLETED'),
                    _buildDivider(),
                    _buildMetric('6 DAYS', 'STREAK'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Biggest Win Card
              ArcCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'BIGGEST WIN',
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Zero missed hydration sessions. Maintained sleep schedule on 6 out of 7 evenings.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Missed Areas Card (Supportive, non-punishing)
              ArcCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.radar_rounded, color: AppColors.goldLight, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'CALIBRATION AREA',
                          style: AppTypography.labelUppercase.copyWith(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: AppColors.goldLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Thursday evening workout was postponed due to late work hours. Recovery was protected.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Next Week Focus
              Text(
                'WHAT SHOULD YOU FOCUS ON NEXT WEEK?',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),
              ArcCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_forward_rounded, color: AppColors.gold, size: 20),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        active != null
                          ? 'Prioritize consistent workout scheduling early in the day for ${active.title}.'
                          : 'Lock in morning routine consistency and protect recovery.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // CTA: CONTINUE YOUR ARC →
              ArcButton(
                label: 'CONTINUE YOUR ARC →',
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTypography.titleLarge.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: AppColors.border);
  }
}
