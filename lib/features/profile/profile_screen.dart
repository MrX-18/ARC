import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_card.dart';
import 'achievements_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import '../journey/journey_screen.dart';
import '../community/community_screen.dart';
import '../pro/pro_paywall_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserRepository().user;
    final arcRepo = ArcRepository();
    final sub = arcRepo.subscription;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
              const SizedBox(height: 24),

              // Profile Header: Photo/Avatar + Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderGold, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                          cacheWidth: 150,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 44,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user.name, style: AppTypography.titleMedium.copyWith(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      sub.isPro ? 'ARC PRO MEMBER' : 'ARC MEMBER',
                      style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // YOUR JOURNEY Stats Card
              Text(
                'YOUR JOURNEY',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),

              ArcCard(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('4', 'ARCS COMPLETED'),
                    _buildDivider(),
                    _buildStat('173', 'DAYS'),
                    _buildDivider(),
                    _buildStat('82%', 'CONSISTENCY'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Navigation Links: ACHIEVEMENTS, JOURNEY, FRIENDS, SETTINGS, NOTIFICATIONS, ARC PRO
              Text(
                'EXPLORE & MANAGE',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),

              ArcCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildLinkTile(
                      context,
                      icon: Icons.verified_rounded,
                      title: 'ACHIEVEMENTS',
                      subtitle: 'Meaningful milestone badges',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    _buildLinkTile(
                      context,
                      icon: Icons.history_edu_rounded,
                      title: 'JOURNEY',
                      subtitle: 'Long-term completed chapters & reflections',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const JourneyScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    _buildLinkTile(
                      context,
                      icon: Icons.people_outline_rounded,
                      title: 'FRIENDS & COMMUNITY',
                      subtitle: 'Accountability circles, group Arcs & challenges',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CommunityScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    _buildLinkTile(
                      context,
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
                    _buildLinkTile(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'SETTINGS',
                      subtitle: 'Account, appearance & data',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border),
                    _buildLinkTile(
                      context,
                      icon: Icons.workspace_premium_rounded,
                      title: 'ARC PRO',
                      subtitle: sub.isPro ? 'Active membership' : 'Unlock unlimited Arcs, AI Coach & insights',
                      titleColor: AppColors.gold,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProPaywallScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelUppercase.copyWith(
            fontSize: 8,
            color: AppColors.textTertiary,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: AppColors.border);
  }

  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.gold, size: 20),
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
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
