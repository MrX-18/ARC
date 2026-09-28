import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import 'arc_reflection_screen.dart';
import 'next_arc_screen.dart';

class ArcCompletionScreen extends StatefulWidget {
  final Arc arc;

  const ArcCompletionScreen({super.key, required this.arc});

  @override
  State<ArcCompletionScreen> createState() => _ArcCompletionScreenState();
}

class _ArcCompletionScreenState extends State<ArcCompletionScreen> {
  final ArcRepository _arcRepo = ArcRepository();

  @override
  void initState() {
    super.initState();
    _finalizeArcCompletion();
  }

  Future<void> _finalizeArcCompletion() async {
    // If active arc matches this, atomically complete it in the engine
    if (_arcRepo.activeArc?.id == widget.arc.id) {
      await _arcRepo.completeActiveArc();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arc = widget.arc;
    final totalDays = arc.durationDays;
    // Emotional restrained summary
    final daysCompleted = (totalDays * 0.91).round();
    final missionsCompleted = (daysCompleted * 2.6).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'ARC',
                  style: AppTypography.brandWordmark.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(height: 36),

              // Arc Complete Header
              Text(
                'ARC COMPLETE',
                style: AppTypography.labelUppercaseGold.copyWith(
                  fontSize: 12,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                arc.title,
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalDays DAYS',
                style: AppTypography.labelUppercase.copyWith(
                  fontSize: 14,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Quiet Emotional Statement
              Text(
                'YOU FINISHED IT.',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 26,
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You showed up when it was hard. You built consistency day by day. This chapter is sealed.',
                style: AppTypography.subtitle.copyWith(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 36),

              // Simple Restrained Summary
              ArcCard(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('$totalDays', 'TOTAL DAYS'),
                    _buildStatDivider(),
                    _buildStatItem('$daysCompleted', 'DAYS DONE'),
                    _buildStatDivider(),
                    _buildStatItem('$missionsCompleted', 'MISSIONS'),
                  ],
                ),
              ),
              const Spacer(),

              // Primary Actions
              ArcButton(
                label: 'REFLECT ON YOUR ARC →',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArcReflectionScreen(arc: arc),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ArcButton(
                label: 'START NEXT ARC →',
                isOutlined: true,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NextArcScreen(previousArc: arc),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelUppercase.copyWith(
            fontSize: 9,
            color: AppColors.textTertiary,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 36, color: AppColors.border);
  }
}
