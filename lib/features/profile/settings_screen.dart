import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_card.dart';
import '../welcome/welcome_screen.dart';
import 'notifications_screen.dart';
import '../pro/pro_paywall_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserRepository _userRepo = UserRepository();
  final ArcRepository _arcRepo = ArcRepository();
  bool _isDarkTheme = true;

  void _confirmResetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('RESET ALL DATA?', style: AppTypography.titleSmall),
        content: Text(
          'This will clear all active Arcs, mission history, reflection archives, and preferences. You will restart from the beginning.',
          style: AppTypography.subtitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'CANCEL',
              style: AppTypography.labelUppercase.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _userRepo.resetData();
              await _arcRepo.init();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('RESET EVERYTHING'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('ABOUT ARC', style: AppTypography.titleSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ARC v1.0.0 (Build 1)',
              style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11),
            ),
            const SizedBox(height: 12),
            Text(
              '"Don\'t just track your habits. Complete your Arc."',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'A personal transformation platform built around time-bound chapters. Built for high agency, restraint, and focus.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CLOSE', style: AppTypography.labelUppercaseGold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _userRepo.user;
    final sub = _arcRepo.subscription;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SETTINGS',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Account Header
              ArcCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderGold),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                          cacheWidth: 150,
                          errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.gold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTypography.titleSmall.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(
                            sub.isPro ? 'ARC PRO MEMBER' : 'FREE PLAN',
                            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.gold),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'SYSTEM & PREFERENCES',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),

              ArcCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.workspace_premium_rounded,
                      title: 'ARC PRO & BILLING',
                      subtitle: sub.isPro ? 'Active subscription' : 'Upgrade to unlimited Arcs & AI Coach',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProPaywallScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    _buildSettingsTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'NOTIFICATIONS',
                      subtitle: 'Reminders & quiet hours',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    _buildSettingsTile(
                      icon: Icons.dark_mode_rounded,
                      title: 'APPEARANCE',
                      subtitle: _isDarkTheme ? 'Dark Mode (Cinematic)' : 'Light Mode',
                      trailing: Switch(
                        value: _isDarkTheme,
                        activeColor: AppColors.gold,
                        onChanged: (v) => setState(() => _isDarkTheme = v),
                      ),
                    ),
                    const Divider(color: AppColors.border),
                    _buildSettingsTile(
                      icon: Icons.security_rounded,
                      title: 'PRIVACY & SECURITY',
                      subtitle: 'Local-first encrypted storage',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'DATA & SUPPORT',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),

              ArcCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'ABOUT ARC',
                      subtitle: 'Manifesto, philosophy & version',
                      onTap: () => _showAboutDialog(context),
                    ),
                    const Divider(color: AppColors.border),
                    _buildSettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'HELP & SUPPORT',
                      subtitle: 'Frequently asked questions',
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.border),
                    _buildSettingsTile(
                      icon: Icons.delete_outline_rounded,
                      title: 'RESET DATA',
                      subtitle: 'Clear all history & restart onboarding',
                      titleColor: AppColors.error,
                      onTap: () => _confirmResetData(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.gold, size: 22),
      title: Text(
        title,
        style: AppTypography.labelUppercase.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textTertiary),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
