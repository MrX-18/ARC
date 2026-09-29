import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/arc_providers.dart';
import '../../core/providers/user_provider.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/state_views.dart';
import '../onboarding/goal_selection_screen.dart';
import '../mission/mission_detail_screen.dart';
import '../ai_coach/ai_coach_screen.dart';
import '../arc_progress/arc_progress_screen.dart';
import '../arc_progress/arc_milestones_screen.dart';
import '../analytics/progress_overview_screen.dart';
import '../profile/notifications_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToCards;
  final VoidCallback? onNavigateToArcs;

  const HomeScreen({
    super.key,
    this.onNavigateToCards,
    this.onNavigateToArcs,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final activeArc = ref.watch(activeArcProvider);
    final userProfile = ref.watch(userProfileProvider);
    final userName = userProfile?.name ?? 'Gorank';

    if (activeArc == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: EmptyView(
            title: 'NO ACTIVE ARC',
            message: 'Your next chapter is waiting.\nChoose an Arc and begin your journey.',
            actionLabel: 'START AN ARC',
            onAction: () {
              if (widget.onNavigateToArcs != null) {
                widget.onNavigateToArcs!();
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GoalSelectionScreen()),
                );
              }
            },
          ),
        ),
      );
    }

    final missions = ref.watch(dailyMissionsProvider);
    final completedCount = missions.where((m) => m.completed).length;
    final totalCount = missions.length;
    final progressPct = (activeArc.progress * 100).round();
    final dayStr = activeArc.currentDay.toString().padLeft(2, '0');
    final totalDaysStr = activeArc.durationDays.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopBar(context),

            // Main Scrollable Dashboard
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Greeting
                    Text(
                      'Good morning, $userName.',
                      style: AppTypography.subtitle.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Active Arc Hero Panel
                    _buildActiveArcHero(activeArc, dayStr, totalDaysStr, progressPct),

                    const SizedBox(height: 20),

                    // Today's Focus Card
                    _buildTodayFocusCard(),

                    const SizedBox(height: 22),

                    // Today's Missions Header & Interactive List
                    _buildMissionsHeader(totalCount),
                    const SizedBox(height: 12),
                    _buildMissionsList(missions),

                    const SizedBox(height: 20),

                    // Today's Progress & Motivational Quote Card
                    _buildTodayProgressCard(completedCount, totalCount, dayStr),

                    const SizedBox(height: 16),

                    // Next Milestone Card
                    _buildNextMilestoneCard(activeArc.id),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ARC',
            style: AppTypography.brandWordmark.copyWith(fontSize: 20),
          ),
          Row(
            children: [
              // AI Coach Icon Button
              IconButton(
                icon: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: AppColors.gold,
                ),
                tooltip: 'AI Arc Coach',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AiCoachScreen()),
                  );
                },
              ),
              const SizedBox(width: 4),

              // Notification Bell with badge
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.notificationDot,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderGold, width: 1.2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                    cacheWidth: 100,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      size: 22,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveArcHero(
    dynamic activeArc,
    String dayStr,
    String totalDaysStr,
    int progressPct,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArcProgressScreen(arcId: activeArc.id),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderSubtle),
          color: AppColors.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Artwork
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 190,
              child: Image.asset(
                'assets/images/hero_strength.png',
                fit: BoxFit.cover,
                cacheWidth: 450,
                errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceLight),
              ),
            ),

            // Left-to-right fade gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0B0B0D),
                      Color(0xF00B0B0D),
                      Color(0x990B0B0D),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.45, 0.7, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR ARC',
                    style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activeArc.title,
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DAY $dayStr / $totalDaysStr',
                    style: AppTypography.labelUppercase.copyWith(
                      color: AppColors.goldLight,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Progress Bar & Day Markers
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: activeArc.progress.clamp(0.01, 1.0),
                          minHeight: 5,
                          backgroundColor: AppColors.progressTrack,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(AppColors.gold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Day $dayStr',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          Text(
                            'Day $totalDaysStr',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          Text(
                            '$progressPct% complete',
                            style: AppTypography.labelUppercaseGold.copyWith(
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayFocusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceElevated,
              border: Border.all(color: AppColors.borderGold.withOpacity(0.5)),
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: AppColors.gold,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TODAY'S FOCUS",
                  style: AppTypography.labelUppercase.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Strength + Recovery',
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Start your training, stay hydrated and get a good night's sleep.",
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "TODAY'S MISSIONS",
          style: AppTypography.labelUppercase.copyWith(
            fontSize: 11,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          '$count tasks',
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionsList(List<dynamic> missions) {
    return Column(
      children: missions.map((m) {
        final isCompleted = m.completed as bool;

        IconData icon = Icons.fitness_center_rounded;
        if (m.type == 'hydration') icon = Icons.water_drop_rounded;
        if (m.type == 'sleep') icon = Icons.nightlight_round;
        if (m.type == 'study') icon = Icons.code_rounded;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ArcCard(
            isSelected: isCompleted,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MissionDetailScreen(mission: m),
                ),
              );
            },
            child: Row(
              children: [
                // Interactive Checkbox Ring via Riverpod Provider
                GestureDetector(
                  onTap: () {
                    ref.read(dailyMissionsProvider.notifier).toggleMission(m.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppColors.gold : Colors.transparent,
                      border: Border.all(
                        color: isCompleted ? AppColors.gold : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: AppColors.textDark,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.gold.withOpacity(0.15)
                        : AppColors.surfaceElevated,
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isCompleted ? AppColors.gold : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isCompleted
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        m.description,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Frequency Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    m.frequency,
                    style: AppTypography.labelUppercase.copyWith(
                      fontSize: 8,
                      letterSpacing: 0.8,
                      color: AppColors.goldLight,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodayProgressCard(int completed, int total, String dayStr) {
    final isDone = completed == total && total > 0;

    return ArcCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProgressOverviewScreen()),
        );
      },
      child: Row(
        children: [
          // Circular Progress indicator
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: total > 0 ? completed / total : 0,
                  strokeWidth: 5,
                  backgroundColor: AppColors.progressTrack,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
                Text(
                  '$completed/$total',
                  style: AppTypography.labelUppercaseGold.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TODAY'S PROGRESS",
                  style: AppTypography.labelUppercase.copyWith(fontSize: 9),
                ),
                const SizedBox(height: 4),
                Text(
                  isDone ? 'TODAY COMPLETE' : '$completed / $total',
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDone ? AppColors.gold : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isDone
                      ? 'DAY $dayStr COMPLETE.'
                      : 'Missions complete',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 44,
            width: 1,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          // Quote
          Column(
            children: [
              const Icon(Icons.terrain_rounded, size: 18, color: AppColors.gold),
              const SizedBox(height: 4),
              Text(
                'ONE DAY\nAT A TIME.',
                textAlign: TextAlign.center,
                style: AppTypography.labelUppercaseGold.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextMilestoneCard(String arcId) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArcMilestonesScreen(arcId: arcId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceElevated,
              ),
              child: const Icon(Icons.flag_rounded, size: 18, color: AppColors.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEXT MILESTONE',
                    style: AppTypography.labelUppercase.copyWith(fontSize: 9),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'First Week',
                    style: AppTypography.titleSmall.copyWith(fontSize: 14),
                  ),
                  Text(
                    '6 days to go',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Trail dot indicator
            Row(
              children: List.generate(4, (i) {
                return Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == 0 ? AppColors.gold : AppColors.border,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
