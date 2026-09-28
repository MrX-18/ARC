import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/repositories/arc_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_logo.dart';
import '../../shared/widgets/state_views.dart';
import '../welcome/welcome_screen.dart';
import '../shell/app_shell.dart';
import '../onboarding/goal_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _arcProgress;
  late Animation<double> _fadeAnimation;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _arcProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeInOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _safePrecacheAssets();
      }
    });

    _initApp();
  }

  void _safePrecacheAssets() {
    try {
      precacheImage(const AssetImage('assets/images/hero_strength.png'), context);
      precacheImage(const AssetImage('assets/images/card_strength.png'), context);
      precacheImage(const AssetImage('assets/images/card_reset.png'), context);
      precacheImage(const AssetImage('assets/images/card_cpp.png'), context);
      precacheImage(const AssetImage('assets/images/card_summer.png'), context);
      precacheImage(const AssetImage('assets/images/card_winter.png'), context);
      precacheImage(const AssetImage('assets/images/avatar.png'), context);
    } catch (_) {
      // Safe fallback: non-critical asset preloading failure never blocks startup
    }
  }

  Future<void> _initApp() async {
    setState(() {
      _hasError = false;
    });

    _animController.forward(from: 0.0);

    try {
      final userRepo = UserRepository();
      final arcRepo = ArcRepository();

      await Future.wait([
        userRepo.init(),
        arcRepo.init(),
        Future.delayed(const Duration(milliseconds: 1800)),
      ]);

      if (!mounted) return;

      // Determine next route based on persistent state
      if (userRepo.isOnboardingCompleted && arcRepo.activeArc != null) {
        // Authenticated user with active arc -> Home
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AppShell(initialIndex: 0),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else if (!userRepo.isOnboardingCompleted &&
          userRepo.user.selectedAreas.isNotEmpty) {
        // User started onboarding -> Resume
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const GoalSelectionScreen(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        // New user -> Welcome screen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomeScreen(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Could not initialize ARC storage.';
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
    if (_hasError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: ErrorView(
          title: 'INITIALIZATION FAILED',
          message: _errorMessage,
          onRetry: _initApp,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ArcLogo(
                  size: 140,
                  showWordmark: false,
                  progress: _arcProgress.value,
                ),
                const SizedBox(height: 24),
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: const ArcLogo(
                    size: 0,
                    showWordmark: true,
                    showTagline: true,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
