import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';

class ProgressCalendarScreen extends StatefulWidget {
  const ProgressCalendarScreen({super.key});

  @override
  State<ProgressCalendarScreen> createState() => _ProgressCalendarScreenState();
}

class _ProgressCalendarScreenState extends State<ProgressCalendarScreen> {
  final ArcRepository _arcRepo = ArcRepository();

  @override
  Widget build(BuildContext context) {
    final active = _arcRepo.activeArc;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'JOURNEY CALENDAR',
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
                'GLOBAL CALENDAR',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'ALL CHAPTERS',
                style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Your entire transformation timeline across past and active Arcs.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Active Arc Chapter Marker
              if (active != null) ...[
                ArcCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ACTIVE CHAPTER: ${active.title}',
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        'DAY ${active.currentDay} / ${active.durationDays}',
                        style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // September Month Grid
              _buildMonthBlock('SEPTEMBER', 30, activeDay: active?.currentDay ?? 27),
              const SizedBox(height: 20),

              // August Month Grid (Past Arc)
              _buildMonthBlock('AUGUST (RESET ARC)', 31, isCompletedMonth: true),
              const SizedBox(height: 20),

              // July Month Grid (Past Arc)
              _buildMonthBlock('JULY (SUMMER ARC)', 31, isCompletedMonth: true),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthBlock(String monthName, int daysInMonth, {int? activeDay, bool isCompletedMonth = false}) {
    return ArcCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthName,
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.2),
              ),
              Text(
                isCompletedMonth ? '100% RECORDED' : 'CURRENT',
                style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(d, style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 8,
            alignment: WrapAlignment.spaceAround,
            children: List.generate(daysInMonth, (i) {
              final dayNum = i + 1;
              final isCurrent = dayNum == activeDay;
              final isCompleted = isCompletedMonth || (activeDay != null && dayNum < activeDay && dayNum % 7 != 3);

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent
                      ? AppColors.gold
                      : isCompleted
                          ? AppColors.gold.withOpacity(0.18)
                          : Colors.transparent,
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.gold
                        : isCompleted
                            ? AppColors.borderGold
                            : AppColors.borderSubtle,
                  ),
                ),
                child: Center(
                  child: Text(
                    dayNum.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                      color: isCurrent ? AppColors.textDark : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
