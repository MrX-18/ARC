import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../shell/app_shell.dart';

class ArcDetailsScreen extends StatefulWidget {
  final ArcTemplate template;

  const ArcDetailsScreen({super.key, required this.template});

  @override
  State<ArcDetailsScreen> createState() => _ArcDetailsScreenState();
}

class _ArcDetailsScreenState extends State<ArcDetailsScreen> {
  final ArcRepository _arcRepo = ArcRepository();
  bool _isActivating = false;

  Future<void> _startThisArc() async {
    setState(() => _isActivating = true);
    final arc = widget.template.toArc();
    final success = await _arcRepo.activateArc(arc);

    if (mounted) {
      setState(() => _isActivating = false);
      if (success) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AppShell(initialIndex: 0)),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.surfaceElevated,
            content: Text('Failed to activate Arc. Please try again.', style: TextStyle(color: AppColors.error)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.template;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Hero Image Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  t.coverImage.isNotEmpty ? t.coverImage : 'assets/images/card_strength.png',
                  fit: BoxFit.cover,
                  cacheWidth: 700,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceElevated),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0x880B0B0D),
                        AppColors.background,
                      ],
                      stops: [0.0, 0.5, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Layer
          SafeArea(
            child: Column(
              children: [
                // Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textPrimary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      if (t.isMarketplace && t.price != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.gold),
                          ),
                          child: Text(
                            t.price!,
                            style: AppTypography.labelUppercaseGold.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                    ],
                  ),
                ),

                // Main Scrollable Details
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),

                        // Category & Marketplace Creator
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderGold),
                              ),
                              child: Text(
                                t.category.toUpperCase(),
                                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.2),
                              ),
                            ),
                            if (t.creator != null) ...[
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'BY ${t.creator!.toUpperCase()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelUppercase.copyWith(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Title
                        Text(
                          t.title,
                          style: AppTypography.titleLarge.copyWith(fontSize: 32, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          t.description,
                          style: AppTypography.subtitle.copyWith(fontSize: 14, height: 1.4),
                        ),
                        const SizedBox(height: 24),

                        // Specs Row: Duration, Difficulty, Daily Commitment, Weekly Frequency
                        ArcCard(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                          child: Row(
                            children: [
                              _buildSpecItem('${t.durationDays}D', 'DURATION'),
                              _buildSpecDivider(),
                              _buildSpecItem(t.difficulty.toUpperCase(), 'DIFFICULTY'),
                              _buildSpecDivider(),
                              _buildSpecItem(t.dailyCommitment.toUpperCase(), 'DAILY'),
                              _buildSpecDivider(),
                              _buildSpecItem(t.weeklyFrequency.toUpperCase(), 'FREQUENCY'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // WHAT YOU'LL DO
                        if (t.activities.isNotEmpty) ...[
                          Text(
                            "WHAT YOU'LL DO",
                            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 12),
                          ArcCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: t.activities.map((act) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.circle, size: 6, color: AppColors.gold),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          act,
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],

                        // WHAT YOU'LL BUILD
                        if (t.outcomes.isNotEmpty) ...[
                          Text(
                            "WHAT YOU'LL BUILD",
                            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 12),
                          ArcCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: t.outcomes.map((out) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_rounded, size: 16, color: AppColors.gold),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          out,
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],

                        // CORE RULES
                        if (t.rules.isNotEmpty) ...[
                          Text(
                            'CORE RULES',
                            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 12),
                          ArcCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: t.rules.asMap().entries.map((entry) {
                                final idx = entry.key + 1;
                                final rule = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        idx.toString().padLeft(2, '0'),
                                        style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          rule,
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],

                        // MILESTONES
                        if (t.milestones.isNotEmpty) ...[
                          Text(
                            'MILESTONES',
                            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 12),
                          ArcCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: t.milestones.map((m) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.flag_outlined, size: 14, color: AppColors.gold),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                m.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTypography.bodySmall.copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'DAY ${m.targetDay}',
                                        style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 36),
                        ],

                        // START THIS ARC BUTTON
                        ArcButton(
                          label: _isActivating ? 'ACTIVATING...' : 'START THIS ARC →',
                          isLoading: _isActivating,
                          onPressed: _startThisArc,
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: AppTypography.titleSmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: AppTypography.labelUppercase.copyWith(
                  fontSize: 8,
                  letterSpacing: 1.0,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecDivider() {
    return Container(width: 1, height: 24, color: AppColors.border);
  }
}
