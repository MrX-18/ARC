import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../activation/activation_screen.dart';

class PreviewScreen extends StatelessWidget {
  final Arc arc;

  const PreviewScreen({super.key, required this.arc});

  void _showConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
              const SizedBox(height: 24),
              Text(
                'READY TO START?',
                style: AppTypography.titleSmall.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${arc.title} • ${arc.durationDays} DAYS',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 12),
              Text(
                'Your first day starts today.',
                style: AppTypography.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ArcButton(
                label: 'START MY ARC',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ActivationScreen(arc: arc),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'NOT YET',
                  style: AppTypography.labelUppercase.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                    const SizedBox(height: 10),
                    Text(
                      'REVIEW YOUR ARC',
                      textAlign: TextAlign.center,
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Everything you need to know before you begin.',
                      textAlign: TextAlign.center,
                      style: AppTypography.subtitle,
                    ),
                    const SizedBox(height: 20),

                    // Hero Arc Card
                    _buildHeroCard(),

                    const SizedBox(height: 24),

                    // What You'll Do Section
                    _buildWhatYoullDoSection(),

                    const SizedBox(height: 24),

                    // Your Week Preview Section
                    _buildWeekPreviewSection(),

                    const SizedBox(height: 20),

                    // Rules & Milestones Side by Side Cards
                    _buildRulesAndMilestonesRow(),

                    const SizedBox(height: 16),

                    // Built Around Your Routine Card
                    _buildBuiltAroundCard(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTA
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
                label: 'START MY ARC',
                onPressed: () => _showConfirmationSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
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
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGold.withOpacity(0.5)),
              ),
              child: Text(
                'EDIT',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGold, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderGoldGlow.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: -4,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/hero_strength.png',
              fit: BoxFit.cover,
              cacheWidth: 700,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.surfaceElevated),
            ),
          ),
          // Horizontal readability fade (darker on left for text, open on right for artwork)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xF20B0B0D),
                    Color(0xD90B0B0D),
                    Color(0x770B0B0D),
                    Color(0x220B0B0D),
                  ],
                  stops: [0.0, 0.40, 0.70, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          // Vertical bottom vignette for pill metrics
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0x440B0B0D),
                    Color(0xFA0B0B0D),
                  ],
                  stops: [0.0, 0.55, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR ARC',
                  style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  arc.title,
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${arc.durationDays} DAY ARC',
                  style: AppTypography.labelUppercase.copyWith(
                    color: AppColors.goldLight,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  arc.description,
                  style: AppTypography.subtitle.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _HeroPill(
                        icon: Icons.access_time_rounded,
                        top: arc.dailyCommitment.toUpperCase(),
                        bottom: 'PER DAY',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroPill(
                        icon: Icons.calendar_today_rounded,
                        top: arc.weeklyFrequency.toUpperCase(),
                        bottom: 'PER WEEK',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroPill(
                        icon: Icons.bar_chart_rounded,
                        top: arc.difficulty.toUpperCase(),
                        bottom: 'LEVEL',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatYoullDoSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "WHAT YOU'LL DO",
              style: AppTypography.labelUppercase.copyWith(fontSize: 11),
            ),
            Row(
              children: [
                Text(
                  'View Details',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded,
                    size: 12, color: AppColors.gold),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...arc.missions.map((m) {
          IconData icon = Icons.fitness_center_rounded;
          if (m.type == 'hydration') icon = Icons.water_drop_rounded;
          if (m.type == 'sleep') icon = Icons.nightlight_round;
          if (m.type == 'study') icon = Icons.code_rounded;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ArcCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceElevated,
                    ),
                    child: Icon(icon, size: 18, color: AppColors.gold),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.title,
                          style: AppTypography.labelUppercase.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          m.description,
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        fontSize: 9,
                        letterSpacing: 0.8,
                        color: AppColors.goldLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildWeekPreviewSection() {
    const week = [
      {'day': 'MON', 'type': 'Train', 'isTrain': true},
      {'day': 'TUE', 'type': 'Rest', 'isTrain': false},
      {'day': 'WED', 'type': 'Train', 'isTrain': true},
      {'day': 'THU', 'type': 'Rest', 'isTrain': false},
      {'day': 'FRI', 'type': 'Train', 'isTrain': true},
      {'day': 'SAT', 'type': 'Rest', 'isTrain': false},
      {'day': 'SUN', 'type': 'Rest', 'isTrain': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'YOUR WEEK ',
              style: AppTypography.labelUppercase.copyWith(fontSize: 11),
            ),
            Text(
              '(PREVIEW)',
              style: AppTypography.labelUppercase.copyWith(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: week.map((w) {
              final isTrain = w['isTrain'] as bool;
              return Column(
                children: [
                  Text(
                    w['day'] as String,
                    style: AppTypography.labelUppercase.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isTrain ? AppColors.gold : Colors.transparent,
                      border: Border.all(
                        color: isTrain ? AppColors.gold : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    w['type'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: isTrain
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRulesAndMilestonesRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3 Core Rules Card
        Expanded(
          child: ArcCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description_outlined,
                            size: 14, color: AppColors.gold),
                        const SizedBox(width: 6),
                        Text(
                          '3 CORE RULES',
                          style: AppTypography.labelUppercase
                              .copyWith(fontSize: 9),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 12, color: AppColors.textTertiary),
                  ],
                ),
                const SizedBox(height: 10),
                ...arc.rules.take(3).map((r) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 12, color: AppColors.gold),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            r,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Your Milestones Card
        Expanded(
          child: ArcCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flag_outlined,
                            size: 14, color: AppColors.gold),
                        const SizedBox(width: 6),
                        Text(
                          'YOUR MILESTONES',
                          style: AppTypography.labelUppercase
                              .copyWith(fontSize: 9),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 12, color: AppColors.textTertiary),
                  ],
                ),
                const SizedBox(height: 14),
                // Timeline progress bar
                Row(
                  children: List.generate(4, (i) {
                    return Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == 0
                                  ? AppColors.gold
                                  : AppColors.border,
                            ),
                          ),
                          if (i < 3)
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color: AppColors.border,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Day 1\nStart',
                        style: TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                    Text('Day 30\nHabits',
                        style: TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                    Text('Day 60\nProgress',
                        style: TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                    Text('Day 90\nComplete',
                        style: TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuiltAroundCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceElevated,
            ),
            child: const Icon(Icons.track_changes_rounded,
                size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BUILT AROUND YOUR ROUTINE',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 9),
                ),
                const SizedBox(height: 2),
                Text(
                  '${arc.dailyCommitment}  •  ${arc.weeklyFrequency}  •  ${arc.difficulty}',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String top;
  final String bottom;

  const _HeroPill({
    required this.icon,
    required this.top,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.gold),
          const SizedBox(height: 4),
          Text(
            top,
            textAlign: TextAlign.center,
            style: AppTypography.labelUppercase.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            bottom,
            style: AppTypography.labelUppercase.copyWith(
              fontSize: 8,
              letterSpacing: 0.8,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
