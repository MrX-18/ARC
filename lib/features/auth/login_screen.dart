import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/arc_button.dart';
import '../onboarding/goal_selection_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final notifier = ref.read(authProvider.notifier);
    if (_isSignUp) {
      await notifier.signUpWithEmail(email, password, name);
    } else {
      await notifier.signInWithEmail(email, password);
    }

    final authState = ref.read(authProvider);
    if (authState.errorMessage == null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GoalSelectionScreen()),
      );
    }
  }

  Future<void> _continueAsGuest() async {
    await ref.read(authProvider.notifier).signInAsGuest();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GoalSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isSignUp ? 'CREATE ACCOUNT' : 'WELCOME BACK',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'ARC',
                  style: AppTypography.brandWordmark.copyWith(fontSize: 32),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp
                    ? 'Start your transformation chapter today.'
                    : 'Sign in to access your active Arc and missions.',
                textAlign: TextAlign.center,
                style: AppTypography.subtitle,
              ),
              const SizedBox(height: 32),

              // Error Banner
              if (authState.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          authState.errorMessage!,
                          style: AppTypography.bodySmall.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

              // Sign Up Name Field
              if (_isSignUp) ...[
                Text('YOUR NAME', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: AppTypography.subtitle.copyWith(fontSize: 12),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderGold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Email Field
              Text('EMAIL ADDRESS', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'name@domain.com',
                  hintStyle: AppTypography.subtitle.copyWith(fontSize: 12),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderGold)),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              Text('PASSWORD', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: '••••••••••••',
                  hintStyle: AppTypography.subtitle.copyWith(fontSize: 12),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderGold)),
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              ArcButton(
                label: authState.isLoading
                    ? 'PROCESSING...'
                    : _isSignUp
                        ? 'CREATE ACCOUNT'
                        : 'SIGN IN',
                onPressed: authState.isLoading ? () {} : _submit,
              ),

              const SizedBox(height: 20),

              // Or Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                  ),
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                ],
              ),
              const SizedBox(height: 20),

              // Guest Button
              OutlinedButton.icon(
                icon: const Icon(Icons.person_outline_rounded, color: AppColors.gold, size: 18),
                label: Text(
                  'CONTINUE AS GUEST',
                  style: AppTypography.labelUppercaseGold.copyWith(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.borderGold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: _continueAsGuest,
              ),

              const SizedBox(height: 24),

              // Toggle Sign In / Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignUp ? 'Already have an account? ' : "Don't have an account? ",
                    style: AppTypography.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Text(
                      _isSignUp ? 'LOG IN' : 'SIGN UP',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
