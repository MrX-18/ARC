import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/state_views.dart';

class ArcMilestonesScreen extends StatefulWidget {
  final String arcId;

  const ArcMilestonesScreen({super.key, required this.arcId});

  @override
  State<ArcMilestonesScreen> createState() => _ArcMilestonesScreenState();
}

class _ArcMilestonesScreenState extends State<ArcMilestonesScreen> {
  final ArcRepository _arcRepo = ArcRepository();

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
          message: 'Unable to load milestones for this Arc chapter.',
          actionLabel: 'GO BACK',
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    final milestones = arc.milestones;
    final currentDay = arc.currentDay;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ARC MILESTONES',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: milestones.isEmpty
            ? EmptyView(
                title: 'NO MILESTONES',
                message: 'No milestones defined for this chapter.',
                actionLabel: 'GO BACK',
                onAction: () => Navigator.of(context).pop(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR MILESTONES',
                      style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      arc.title,
                      style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Meaningful checkpoints along your ${arc.durationDays}-day journey.',
                      style: AppTypography.subtitle.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 36),

                    // Milestones Vertical Timeline
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: milestones.length,
                      itemBuilder: (context, idx) {
                        final milestone = milestones[idx];
                        final isCompleted = milestone.completed || currentDay >= milestone.targetDay;
                        final isNext = !isCompleted && (idx == 0 || (currentDay >= milestones[idx - 1].targetDay));
                        final isLast = idx == milestones.length - 1;

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Indicator column with line
                              Column(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCompleted
                                          ? AppColors.gold
                                          : isNext
                                              ? AppColors.surfaceElevated
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: isCompleted
                                            ? AppColors.gold
                                            : isNext
                                                ? AppColors.borderGold
                                                : AppColors.border,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: isCompleted
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 16,
                                              color: AppColors.textDark,
                                            )
                                          : Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isNext ? AppColors.gold : AppColors.border,
                                              ),
                                            ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 1.5,
                                        color: isCompleted ? AppColors.goldDark.withOpacity(0.5) : AppColors.border,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 18),

                              // Content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 32),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            milestone.title.toUpperCase(),
                                            style: AppTypography.titleSmall.copyWith(
                                              fontSize: 16,
                                              fontWeight: isCompleted || isNext
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isCompleted
                                                  ? AppColors.textPrimary
                                                  : isNext
                                                      ? AppColors.goldLight
                                                      : AppColors.textTertiary,
                                            ),
                                          ),
                                          Text(
                                            'DAY ${milestone.targetDay}',
                                            style: AppTypography.labelUppercase.copyWith(
                                              fontSize: 10,
                                              color: isCompleted
                                                  ? AppColors.gold
                                                  : AppColors.textTertiary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isCompleted
                                            ? 'Achieved'
                                            : currentDay < milestone.targetDay
                                                ? '${milestone.targetDay - currentDay} days remaining'
                                                : 'In progress',
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 12,
                                          color: isCompleted
                                              ? AppColors.goldDark
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
