import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/arc_card.dart';

class FitnessLifestyleAnalyticsScreen extends StatelessWidget {
  const FitnessLifestyleAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ANALYTICS',
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
              // Screen 24: Fitness Analytics Section
              Text(
                'FITNESS ANALYTICS',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'TRAINING CONSISTENCY',
                style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Workouts completed and weekly volume trends.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Weekly Bar Trend (Workouts)
              ArcCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('WORKOUT SESSIONS', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                        Text('12 THIS MONTH', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // 7-day Bar Chart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar('M', 0.8, '45m'),
                        _buildBar('T', 0.0, '-'),
                        _buildBar('W', 0.9, '50m'),
                        _buildBar('T', 0.0, '-'),
                        _buildBar('F', 0.75, '40m'),
                        _buildBar('S', 0.95, '55m'),
                        _buildBar('S', 0.0, '-'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Fitness summary specs
              Row(
                children: [
                  Expanded(
                    child: ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AVG DURATION', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
                          const SizedBox(height: 4),
                          Text('48 MIN', style: AppTypography.titleSmall.copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
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
                          Text('WEEKLY TARGET', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
                          const SizedBox(height: 4),
                          Text('4 SESSIONS', style: AppTypography.titleSmall.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.goldLight)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Screen 25: Lifestyle Analytics Section
              Text(
                'LIFESTYLE ANALYTICS',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'RECOVERY & SLEEP',
                style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Hydration, circadian consistency, and routine habits.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Hydration Card
              ArcCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('HYDRATION DISCIPLINE', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                        Text('2.6L DAILY AVG', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.88,
                        minHeight: 8,
                        backgroundColor: AppColors.progressTrack,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Target: 2.5L/day · 6 of 7 days target met this week',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sleep Consistency Card
              ArcCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SLEEP CONSISTENCY', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                        Text('7h 45m AVG', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSleepDot('MON', true),
                        _buildSleepDot('TUE', true),
                        _buildSleepDot('WED', true),
                        _buildSleepDot('THU', true),
                        _buildSleepDot('FRI', false),
                        _buildSleepDot('SAT', true),
                        _buildSleepDot('SUN', true),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Bedtime before 11:30 PM maintained on 6 nights.',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
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

  Widget _buildBar(String day, double heightPct, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.labelUppercase.copyWith(fontSize: 8, color: AppColors.textTertiary)),
        const SizedBox(height: 6),
        Container(
          width: 18,
          height: 90,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            height: 90 * heightPct,
            decoration: BoxDecoration(
              color: heightPct > 0 ? AppColors.gold : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: AppTypography.labelUppercase.copyWith(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSleepDot(String day, bool met) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: met ? AppColors.gold : Colors.transparent,
            border: Border.all(color: met ? AppColors.gold : AppColors.border),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: AppTypography.labelUppercase.copyWith(fontSize: 8, color: AppColors.textTertiary)),
      ],
    );
  }
}
