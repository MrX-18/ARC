import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/engine/arc_engine.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../arcs/arc_details_screen.dart';
import '../arcs/custom_arc_builder_screen.dart';
import '../shell/app_shell.dart';

class NextArcScreen extends StatelessWidget {
  final Arc? previousArc;

  const NextArcScreen({super.key, this.previousArc});

  @override
  Widget build(BuildContext context) {
    final curated = ArcEngine.getCuratedTemplates();
    // Recommend Arcs complementary to previous
    final recommendations = curated.where((t) => t.id != previousArc?.id).take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'ARC',
                  style: AppTypography.brandWordmark.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(height: 28),

              Text(
                'YOUR NEXT CHAPTER',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                "WHAT'S YOUR NEXT ARC?",
                style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Transformation never ends. Choose where you want to channel your discipline next.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Recommended Cards
                    ...recommendations.map((template) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ArcCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ArcDetailsScreen(template: template),
                              ),
                            );
                          },
                          padding: const EdgeInsets.all(18),
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
                                child: const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      template.title,
                                      style: AppTypography.titleSmall.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${template.durationDays} DAYS · ${template.category.toUpperCase()}',
                                      style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.gold),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Create Custom Arc
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ArcCard(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CustomArcBuilderScreen(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surfaceElevated,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(Icons.add_rounded, color: AppColors.gold, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CREATE YOUR OWN ARC',
                                    style: AppTypography.titleSmall.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'CUSTOM TIMELINE & MISSIONS',
                                    style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.gold),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Primary CTA: EXPLORE ARCS →
              ArcButton(
                label: 'EXPLORE ARCS →',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AppShell(initialIndex: 2)),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AppShell(initialIndex: 0)),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'RETURN HOME',
                    style: AppTypography.labelUppercase.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
