import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/state_views.dart';
import 'arc_calendar_screen.dart';
import 'arc_rules_screen.dart';
import 'arc_milestones_screen.dart';
import '../mission/mission_detail_screen.dart';
import '../journey/arc_completion_screen.dart';

class ArcProgressScreen extends StatefulWidget {
  final String arcId;

  const ArcProgressScreen({super.key, required this.arcId});

  @override
  State<ArcProgressScreen> createState() => _ArcProgressScreenState();
}

class _ArcProgressScreenState extends State<ArcProgressScreen> {
  final ArcRepository _arcRepo = ArcRepository();
  final bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _arcRepo.addListener(_onRepoUpdated);
  }

  @override
  void dispose() {
    _arcRepo.removeListener(_onRepoUpdated);
    super.dispose();
  }

  void _onRepoUpdated() {
    if (mounted) setState(() {});
  }

  void _showOptionsMenu(BuildContext context, Arc arc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_month_rounded, color: AppColors.gold),
                  title: Text('ARC CALENDAR', style: AppTypography.labelUppercase),
                  subtitle: Text('View daily journey matrix', style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArcCalendarScreen(arcId: arc.id),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book_rounded, color: AppColors.gold),
                  title: Text('ARC RULES', style: AppTypography.labelUppercase),
                  subtitle: Text('Review & calibrate non-negotiables', style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArcRulesScreen(arcId: arc.id),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_rounded, color: AppColors.gold),
                  title: Text('ARC MILESTONES', style: AppTypography.labelUppercase),
                  subtitle: Text('Track meaningful chapter checkpoints', style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArcMilestonesScreen(arcId: arc.id),
                      ),
                    );
                  },
                ),
                const Divider(color: AppColors.border),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline_rounded, color: AppColors.gold),
                  title: Text('COMPLETE ARC', style: AppTypography.labelUppercaseGold),
                  subtitle: Text('Mark final day & proceed to reflection', style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArcCompletionScreen(arc: arc),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingView(message: 'Loading Arc progress...'),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: ErrorView(
          title: 'SOMETHING WENT WRONG.',
          message: _errorMessage!,
          onRetry: () => setState(() => _errorMessage = null),
        ),
      );
    }

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
          message: 'The requested Arc chapter is not available.',
          actionLabel: 'GO BACK',
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    final progress = _arcRepo.getArcProgress(arc.id);
    final totalDays = arc.durationDays;
    final currentDay = arc.currentDay;
    final daysRemaining = (totalDays - currentDay).clamp(0, totalDays);
    final pct = (arc.progress * 100).round();

    final missions = arc.missions.isNotEmpty
        ? arc.missions
        : _arcRepo.todayMissions;
    final completedMissions = missions.where((m) => m.completed).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          arc.title,
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
            onPressed: () => _showOptionsMenu(context, arc),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Arc Identity
              Text(
                '${arc.durationDays} DAY ARC',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 6),
              Text(
                arc.title,
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                arc.description,
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 28),

              // Hero Block: DAY 27 / 90, 30%, ARC COMPLETE, 63 DAYS REMAINING
              ArcCard(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'DAY $currentDay / $totalDays',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          '$pct%',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 36,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress Track
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: arc.progress.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppColors.progressTrack,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ARC COMPLETE',
                          style: AppTypography.labelUppercase.copyWith(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          '$daysRemaining DAYS REMAINING',
                          style: AppTypography.labelUppercaseGold.copyWith(
                            fontSize: 10,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Small Summary Row: DAYS DONE | STREAK | MISSIONS
              ArcCard(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('${progress.daysCompleted}', 'DAYS DONE'),
                    _buildSummaryDivider(),
                    _buildSummaryItem('${progress.currentStreak}', 'STREAK'),
                    _buildSummaryDivider(),
                    _buildSummaryItem('${progress.missionsCompleted}', 'MISSIONS'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // THIS WEEK: M T W T F S S ● ● ● ○ ● ● ○
              Text(
                'THIS WEEK',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),
              ArcCard(
                padding: const EdgeInsets.all(18),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArcCalendarScreen(arcId: arc.id),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _WeekDayDot(dayLabel: 'M', isFilled: true),
                        _WeekDayDot(dayLabel: 'T', isFilled: true),
                        _WeekDayDot(dayLabel: 'W', isFilled: true),
                        _WeekDayDot(dayLabel: 'T', isFilled: false),
                        _WeekDayDot(dayLabel: 'F', isFilled: true),
                        _WeekDayDot(dayLabel: 'S', isFilled: true),
                        _WeekDayDot(dayLabel: 'S', isFilled: false),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5 / 7 DAYS',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'VIEW CALENDAR',
                              style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.gold),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // NEXT MILESTONE
              Text(
                'NEXT MILESTONE',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),
              ArcCard(
                padding: const EdgeInsets.all(18),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArcMilestonesScreen(arcId: arc.id),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceElevated,
                        border: Border.all(color: AppColors.borderGold),
                      ),
                      child: const Icon(Icons.flag_rounded, size: 20, color: AppColors.gold),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HALF WAY THERE',
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '18 DAYS REMAINING',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.goldLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.gold),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // TODAY'S MISSIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TODAY'S MISSIONS",
                    style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                  ),
                  Text(
                    '$completedMissions / ${missions.length} COMPLETE',
                    style: AppTypography.labelUppercase.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ArcCard(
                padding: const EdgeInsets.all(18),
                onTap: () {
                  if (missions.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MissionDetailScreen(mission: missions.first),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceElevated,
                      ),
                      child: const Icon(Icons.check_circle_rounded, size: 22, color: AppColors.gold),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            missions.isNotEmpty ? missions.first.title : 'NO ACTIVE MISSIONS',
                            style: AppTypography.labelUppercase.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            missions.isNotEmpty
                                ? '${missions.length} missions scheduled today'
                                : 'Check back tomorrow',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'VIEW MISSIONS',
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.gold),
                      ],
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

  Widget _buildSummaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontSize: 24,
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

  Widget _buildSummaryDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.border,
    );
  }
}

class _WeekDayDot extends StatelessWidget {
  final String dayLabel;
  final bool isFilled;

  const _WeekDayDot({required this.dayLabel, required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dayLabel,
          style: AppTypography.labelUppercase.copyWith(
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.gold : Colors.transparent,
            border: Border.all(
              color: isFilled ? AppColors.gold : AppColors.border,
              width: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
