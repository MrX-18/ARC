import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/arc_glow_halo.dart';
import 'routine_screen.dart';

class MainGoalScreen extends StatefulWidget {
  const MainGoalScreen({super.key});

  @override
  State<MainGoalScreen> createState() => _MainGoalScreenState();
}

class _MainGoalScreenState extends State<MainGoalScreen> {
  final UserRepository _userRepo = UserRepository();
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = _userRepo.user.primaryGoal ?? 'BUILD STRENGTH';
  }

  List<Map<String, dynamic>> _getDynamicGoals(List<String> areas) {
    final list = <Map<String, dynamic>>[];
    final upperAreas = areas.map((e) => e.toUpperCase()).toList();

    // If Fitness is selected
    if (upperAreas.contains('FITNESS') || upperAreas.isEmpty) {
      list.addAll([
        {
          'title': 'BUILD STRENGTH',
          'subtitle': 'Get stronger through consistent training and recovery.',
          'icon': Icons.fitness_center_rounded,
        },
        {
          'title': 'IMPROVE STAMINA',
          'subtitle': 'Increase your endurance and cardiovascular fitness.',
          'icon': Icons.directions_run_rounded,
        },
        {
          'title': 'BECOME MORE ACTIVE',
          'subtitle': 'Move more and build a healthier, more active lifestyle.',
          'icon': Icons.bar_chart_rounded,
        },
        {
          'title': 'IMPROVE BODY COMPOSITION',
          'subtitle': 'Build lean muscle and improve your overall health.',
          'icon': Icons.local_fire_department_rounded,
        },
        {
          'title': 'BUILD A CONSISTENT ROUTINE',
          'subtitle': 'Create sustainable habits that last.',
          'icon': Icons.track_changes_rounded,
        },
        {
          'title': 'GENERAL FITNESS',
          'subtitle': 'Improve overall fitness and well-being.',
          'icon': Icons.star_rounded,
        },
      ]);
    } else if (upperAreas.contains('LEARNING') || upperAreas.contains('SKILLS')) {
      list.addAll([
        {
          'title': 'LEARN PROGRAMMING',
          'subtitle': 'Master core coding fundamentals and build software.',
          'icon': Icons.terminal_rounded,
        },
        {
          'title': 'STUDY CONSISTENTLY',
          'subtitle': 'Establish dedicated, distraction-free study blocks.',
          'icon': Icons.menu_book_rounded,
        },
        {
          'title': 'BUILD A PORTFOLIO',
          'subtitle': 'Develop impactful real-world projects daily.',
          'icon': Icons.laptop_mac_rounded,
        },
        {
          'title': 'MASTER A SKILL',
          'subtitle': 'Progress systematically through focused practice.',
          'icon': Icons.psychology_rounded,
        },
      ]);
    } else if (upperAreas.contains('BETTER SLEEP') || upperAreas.contains('DISCIPLINE')) {
      list.addAll([
        {
          'title': 'BUILD A CONSISTENT LIFESTYLE',
          'subtitle': 'Establish calm morning and evening daily anchors.',
          'icon': Icons.nightlight_round,
        },
        {
          'title': 'SLEEP MORE CONSISTENTLY',
          'subtitle': 'Fall asleep and wake up at the same hour each day.',
          'icon': Icons.bedtime_rounded,
        },
        {
          'title': 'PRIORITIZE RECOVERY',
          'subtitle': 'Recharge your mental and physical energy reserves.',
          'icon': Icons.self_improvement_rounded,
        },
      ]);
    }

    // Always add 'SOMETHING ELSE'
    list.add({
      'title': 'SOMETHING ELSE',
      'subtitle': 'Tell us your specific goal.',
      'icon': Icons.add_rounded,
    });

    return list;
  }

  void _continue() {
    if (_selectedGoal == null) return;
    _userRepo.setPrimaryGoal(_selectedGoal!);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RoutineScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final selectedAreas = _userRepo.user.selectedAreas;
    final goals = _getDynamicGoals(selectedAreas);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ArcGlowHalo(radius: 260, centerOffset: Offset(0, -50)),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "WHAT'S YOUR\nMAIN GOAL?",
                          textAlign: TextAlign.center,
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose the result you want to focus on most.',
                          textAlign: TextAlign.center,
                          style: AppTypography.subtitle,
                        ),
                        const SizedBox(height: 20),

                        // Selected Areas horizontal chips bar
                        _buildSelectedAreasBar(selectedAreas),

                        const SizedBox(height: 20),

                        // Goal Cards list
                        ...goals.map((g) {
                          final title = g['title'] as String;
                          final subtitle = g['subtitle'] as String;
                          final icon = g['icon'] as IconData;
                          final isSelected = _selectedGoal == title;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ArcCard(
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedGoal = title;
                                });
                              },
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.surfaceLight
                                          : AppColors.surface,
                                    ),
                                    child: Icon(
                                      icon,
                                      size: 20,
                                      color: isSelected
                                          ? AppColors.gold
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: AppTypography.labelUppercase
                                              .copyWith(
                                            color: AppColors.textPrimary,
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          subtitle,
                                          style: AppTypography.bodySmall
                                              .copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.gold
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.gold
                                            : AppColors.border,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 15,
                                            color: AppColors.textDark,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Bottom Action
                Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    bottomInset > 0 ? bottomInset + 8 : 20,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.borderSubtle,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ArcButton(
                    label: 'CONTINUE',
                    onPressed: _selectedGoal != null ? _continue : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                'ARC',
                style: AppTypography.brandWordmark.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Dots: 2 / 4
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isCurrent = index == 1;
              final isPast = index < 1;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isCurrent ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isCurrent || isPast
                      ? AppColors.gold
                      : AppColors.border,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '2 / 4',
            style: AppTypography.labelStepProgress.copyWith(fontSize: 11),
          ),
          Text(
            'PERSONALIZE YOUR ARC',
            style: AppTypography.labelUppercase.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAreasBar(List<String> areas) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR SELECTED AREAS',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Edit',
                  style: AppTypography.labelUppercaseGold.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: areas.map((a) {
              IconData icon = Icons.check_circle_outline_rounded;
              if (a.contains('FITNESS')) icon = Icons.fitness_center_rounded;
              if (a.contains('SLEEP')) icon = Icons.nightlight_round;
              if (a.contains('DISCIPLINE')) icon = Icons.access_time_rounded;
              if (a.contains('LEARNING')) icon = Icons.menu_book_rounded;
              if (a.contains('SKILLS')) icon = Icons.laptop_mac_rounded;

              final formatted = a
                  .split(' ')
                  .map((w) => w.isNotEmpty
                      ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
                      : '')
                  .join(' ');

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.chipBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      formatted,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
