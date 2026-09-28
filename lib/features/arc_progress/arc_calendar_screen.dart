import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/state_views.dart';

class ArcCalendarScreen extends StatefulWidget {
  final String arcId;

  const ArcCalendarScreen({super.key, required this.arcId});

  @override
  State<ArcCalendarScreen> createState() => _ArcCalendarScreenState();
}

class _ArcCalendarScreenState extends State<ArcCalendarScreen> {
  final ArcRepository _arcRepo = ArcRepository();
  int _selectedDay = 27;

  @override
  Widget build(BuildContext context) {
    final arc = _arcRepo.getArcById(widget.arcId);

    if (arc == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: EmptyView(
          title: 'ARC NOT FOUND',
          message: 'Unable to load calendar for this Arc chapter.',
          actionLabel: 'GO BACK',
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    final progress = _arcRepo.getArcProgress(arc.id);
    final currentDay = arc.currentDay;
    final totalDays = arc.durationDays;
    final completedDays = progress.completedDays.toSet();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ARC CALENDAR',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                arc.title,
                style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'DAY $currentDay / $totalDays',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 12, letterSpacing: 1.2),
              ),
              const SizedBox(height: 24),

              // Calendar Card
              ArcCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month Label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CURRENT MONTH',
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                        ),
                        Text(
                          '${completedDays.length} DAYS COMPLETED',
                          style: AppTypography.labelUppercase.copyWith(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Day of Week Header: M T W T F S S
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                        return SizedBox(
                          width: 36,
                          child: Center(
                            child: Text(
                              day,
                              style: AppTypography.labelUppercase.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 12),

                    // 4-5 Weeks Grid
                    _buildDaysGrid(currentDay, totalDays, completedDays),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Selected Day Mission Summary
              Text(
                'DAY $_selectedDay SUMMARY',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),
              _buildSelectedDayCard(arc, _selectedDay, currentDay, completedDays),

              const SizedBox(height: 24),

              // Legend
              ArcCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem(AppColors.gold, 'COMPLETED', true),
                    _buildLegendItem(AppColors.border, 'MISSED', false),
                    _buildLegendItem(AppColors.goldLight, 'CURRENT', true, isCurrent: true),
                    _buildLegendItem(AppColors.surfaceElevated, 'FUTURE', false),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysGrid(int currentDay, int totalDays, Set<int> completedDays) {
    // Generate up to 35 day cells
    const int totalCells = 35;

    return Wrap(
      spacing: 6,
      runSpacing: 12,
      alignment: WrapAlignment.spaceAround,
      children: List.generate(totalCells, (index) {
        final dayNumber = index + 1;
        final isPast = dayNumber < currentDay;
        final isCurrent = dayNumber == currentDay;
        final isFuture = dayNumber > currentDay;
        final isCompleted = completedDays.contains(dayNumber);
        final isSelected = dayNumber == _selectedDay;

        Color dotColor;
        Color borderColor;

        if (isCurrent) {
          dotColor = AppColors.gold;
          borderColor = AppColors.gold;
        } else if (isPast && isCompleted) {
          dotColor = AppColors.gold;
          borderColor = AppColors.gold;
        } else if (isPast && !isCompleted) {
          dotColor = Colors.transparent;
          borderColor = AppColors.border;
        } else {
          // Future
          dotColor = Colors.transparent;
          borderColor = AppColors.borderSubtle;
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = dayNumber;
            });
          },
          child: Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.surfaceElevated : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? Border.all(color: AppColors.borderGold, width: 1.2) : null,
            ),
            child: Column(
              children: [
                Text(
                  dayNumber.toString().padLeft(2, '0'),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                    color: isCurrent
                        ? AppColors.gold
                        : isFuture
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSelectedDayCard(Arc arc, int day, int currentDay, Set<int> completedDays) {
    final isDone = completedDays.contains(day);
    final isFuture = day > currentDay;

    String statusText;
    if (isFuture) {
      statusText = 'UPCOMING';
    } else if (isDone) {
      statusText = 'COMPLETED';
    } else {
      statusText = 'MISSED MISSIONS';
    }

    return ArcCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DAY ${day.toString().padLeft(2, '0')}',
                style: AppTypography.titleSmall.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.completedBadge.withOpacity(0.15)
                      : isFuture
                          ? AppColors.surfaceElevated
                          : AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDone
                        ? AppColors.completedBadge
                        : isFuture
                            ? AppColors.border
                            : AppColors.error,
                  ),
                ),
                child: Text(
                  statusText,
                  style: AppTypography.labelUppercase.copyWith(
                    fontSize: 9,
                    color: isDone
                        ? AppColors.completedBadge
                        : isFuture
                            ? AppColors.textTertiary
                            : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isFuture
                ? 'Missions for this day will unlock as your Arc reaches Day $day.'
                : isDone
                    ? 'All scheduled missions for this day were completed successfully.'
                    : '1 or more missions were skipped. Your Arc continues forward without penalty.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, bool isFilled, {bool isCurrent = false}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? color : Colors.transparent,
            border: Border.all(color: color, width: isCurrent ? 2 : 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelUppercase.copyWith(fontSize: 8, color: AppColors.textTertiary),
        ),
      ],
    );
  }
}
