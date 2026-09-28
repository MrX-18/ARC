import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/engine/arc_engine.dart';
import '../../core/models/models.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/arc_glow_halo.dart';
import 'preview_screen.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final UserRepository _userRepo = UserRepository();
  late Arc _recommendedArc;

  @override
  void initState() {
    super.initState();
    final u = _userRepo.user;
    // Generate deterministic recommendation from user's onboarding profile
    _recommendedArc = ArcEngine.recommendArc(
      selectedAreas: u.selectedAreas,
      primaryGoal: u.primaryGoal,
      dailyCommitment: u.dailyCommitment,
      weeklyFrequency: u.weeklyFrequency,
      experienceLevel: u.experienceLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

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
                          'YOUR ARC IS READY.',
                          textAlign: TextAlign.center,
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Built around your goals, your routine, and your pace.',
                          textAlign: TextAlign.center,
                          style: AppTypography.subtitle,
                        ),
                        const SizedBox(height: 20),

                        // Hero Arc Card
                        _buildHeroCard(),

                        const SizedBox(height: 24),

                        // Your Details Section
                        _buildDetailsSection(),

                        const SizedBox(height: 24),

                        // Your Core Rules Section
                        _buildCoreRulesSection(),

                        const SizedBox(height: 24),

                        // Your First Missions Preview Section
                        _buildMissionsPreviewSection(),

                        const SizedBox(height: 24),
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
                    label: 'REVIEW YOUR ARC',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PreviewScreen(arc: _recommendedArc),
                        ),
                      );
                    },
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

          // Progress Dots: 4 / 4
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 3 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.gold,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '4 / 4',
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
          // Background Hero Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/hero_strength.png',
              fit: BoxFit.cover,
              cacheWidth: 700,
              errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceElevated),
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

          // Content
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
                  _recommendedArc.title,
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_recommendedArc.durationDays} DAY ARC',
                  style: AppTypography.labelUppercase.copyWith(
                    color: AppColors.goldLight,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _recommendedArc.description,
                  style: AppTypography.subtitle.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 20),

                // 3 Compact Details Pills
                Row(
                  children: [
                    Expanded(
                      child: _HeroPill(
                        icon: Icons.access_time_rounded,
                        top: _recommendedArc.dailyCommitment.toUpperCase(),
                        bottom: 'PER DAY',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroPill(
                        icon: Icons.calendar_today_rounded,
                        top: _recommendedArc.weeklyFrequency.toUpperCase(),
                        bottom: 'PER WEEK',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroPill(
                        icon: Icons.bar_chart_rounded,
                        top: _recommendedArc.difficulty.toUpperCase(),
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

  Widget _buildDetailsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'YOUR DETAILS',
              style: AppTypography.labelUppercase.copyWith(fontSize: 11),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 14, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Text(
                    'EDIT ARC',
                    style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DetailBox(
                icon: Icons.track_changes_rounded,
                label: 'GOAL',
                value: _recommendedArc.title,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DetailBox(
                icon: Icons.calendar_month_rounded,
                label: 'DURATION',
                value: '${_recommendedArc.durationDays} Days',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _DetailBox(
                icon: Icons.access_time_rounded,
                label: 'COMMITMENT',
                value: '${_recommendedArc.dailyCommitment}\n${_recommendedArc.weeklyFrequency}',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DetailBox(
                icon: Icons.bar_chart_rounded,
                label: 'EXPERIENCE',
                value: _recommendedArc.difficulty,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoreRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR CORE RULES',
          style: AppTypography.labelUppercase.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.2,
          ),
          itemCount: _recommendedArc.rules.length,
          itemBuilder: (context, index) {
            final rule = _recommendedArc.rules[index];
            final number = (index + 1).toString().padLeft(2, '0');
            IconData icon = Icons.fitness_center_rounded;
            if (index == 1) icon = Icons.spa_rounded;
            if (index == 2) icon = Icons.autorenew_rounded;
            if (index == 3) icon = Icons.check_circle_outline_rounded;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Text(
                    number,
                    style: AppTypography.labelUppercase.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, size: 16, color: AppColors.gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rule,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMissionsPreviewSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'YOUR FIRST MISSIONS',
              style: AppTypography.labelUppercase.copyWith(fontSize: 11),
            ),
            Text(
              'Preview',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._recommendedArc.missions.map((m) {
          IconData icon = Icons.fitness_center_rounded;
          if (m.type == 'hydration') icon = Icons.water_drop_rounded;
          if (m.type == 'sleep') icon = Icons.nightlight_round;
          if (m.type == 'study') icon = Icons.code_rounded;
          if (m.type == 'reading') icon = Icons.menu_book_rounded;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ArcCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.gold),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      m.title,
                      style: AppTypography.labelUppercase.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: AppColors.gold,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
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

class _DetailBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelUppercase.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.0,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
