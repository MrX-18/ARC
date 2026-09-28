import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_logo.dart';
import '../shell/app_shell.dart';

class ActivationScreen extends StatefulWidget {
  final Arc arc;

  const ActivationScreen({super.key, required this.arc});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _arcProgress;
  late Animation<double> _fadeText;

  bool _isActivating = true;
  bool _activationFailed = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _arcProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeInOutCubic),
      ),
    );

    _fadeText = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _executeActivation();
  }

  Future<void> _executeActivation() async {
    setState(() {
      _isActivating = true;
      _activationFailed = false;
    });

    _animController.forward(from: 0.0);

    try {
      final arcRepo = ArcRepository();
      final userRepo = UserRepository();

      final success = await arcRepo.activateArc(widget.arc);
      if (success) {
        await userRepo.completeOnboarding();
      }

      await Future.delayed(const Duration(milliseconds: 2600));

      if (!mounted) return;

      if (success) {
        // Navigate atomically to Home Screen via AppShell
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AppShell(initialIndex: 0),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          _isActivating = false;
          _activationFailed = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isActivating = false;
          _activationFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_activationFailed) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.error),
                      color: AppColors.surface,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 28,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "YOUR ARC COULDN'T START.",
                    style: AppTypography.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your setup is safe.\nNothing was lost.',
                    style: AppTypography.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ArcButton(
                    label: 'TRY AGAIN',
                    onPressed: _executeActivation,
                    showArrow: false,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'GO BACK',
                      style: AppTypography.labelUppercase.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => !_isActivating,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ArcLogo(
                      size: 130,
                      showWordmark: false,
                      progress: _arcProgress.value,
                    ),
                    const SizedBox(height: 28),
                    Opacity(
                      opacity: _fadeText.value,
                      child: Column(
                        children: [
                          Text(
                            'YOUR ARC BEGINS NOW.',
                            style: AppTypography.labelUppercaseGold.copyWith(
                              fontSize: 12,
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.arc.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${widget.arc.durationDays} DAYS',
                            style: AppTypography.labelUppercase.copyWith(
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderGold.withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              'STARTING TODAY  •  DAY 01 / ${widget.arc.durationDays.toString().padLeft(2, '0')}',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
