import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/arc_button.dart';
import '../onboarding/goal_selection_screen.dart';
import '../auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top ARC Branding
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Center(
                child: Text(
                  'ARC',
                  style: AppTypography.brandWordmark.copyWith(fontSize: 20),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Hero Artwork
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/hero_welcome.png',
                            fit: BoxFit.cover,
                            cacheWidth: 700,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.surface,
                              child: const Icon(Icons.terrain_rounded,
                                  size: 80, color: AppColors.goldMuted),
                            ),
                          ),
                          // Subtle bottom vignette fade
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 60,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, AppColors.background],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Headings
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'YOUR NEXT CHAPTER',
                            textAlign: TextAlign.center,
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.goldTextGradient.createShader(bounds),
                            child: Text(
                              'STARTS HERE.',
                              textAlign: TextAlign.center,
                              style: AppTypography.titleLarge.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Build yourself one day at a time.',
                            textAlign: TextAlign.center,
                            style: AppTypography.subtitle.copyWith(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 3 Value Proposition Steps with vertical connector
                          const _ValuePropSteps(),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions
            Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, bottomInset > 0 ? bottomInset + 8 : 24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.borderSubtle, width: 1.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ArcButton(
                    label: 'GET STARTED',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GoalSelectionScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Clean log-in modal sheet
                          _showLoginSheet(context);
                        },
                        child: Text(
                          'LOG IN',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.gold,
                          ),
                        ),
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

  void _showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
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
              const SizedBox(height: 20),
              Text('WELCOME BACK', style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              Text(
                'Resume your journey and continue your Arc.',
                style: AppTypography.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ArcButton(
                label: 'SIGN IN OR REGISTER',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ValuePropSteps extends StatelessWidget {
  const _ValuePropSteps();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepItem(
          icon: Icons.track_changes_rounded,
          title: 'CHOOSE YOUR GOALS.',
          description: 'Pick what you want to improve.',
          isLast: false,
        ),
        _StepItem(
          icon: Icons.calendar_today_outlined,
          title: 'BUILD YOUR ARC.',
          description: 'Get a personalized plan.',
          isLast: false,
        ),
        _StepItem(
          icon: Icons.bar_chart_rounded,
          title: 'COMPLETE YOUR MISSIONS.',
          description: 'Make progress every day.',
          isLast: true,
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  const _StepItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.borderGold, width: 1.2),
              ),
              child: Icon(icon, size: 20, color: AppColors.gold),
            ),
            if (!isLast)
              Container(
                width: 1.2,
                height: 34,
                color: AppColors.borderGold.withOpacity(0.5),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelUppercase.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: AppTypography.subtitle.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
