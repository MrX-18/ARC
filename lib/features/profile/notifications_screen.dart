import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/state_views.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ArcRepository _arcRepo = ArcRepository();

  bool _notificationsEnabled = true;
  bool _morningReminder = true;
  bool _eveningReminder = true;
  bool _quietHours = true;

  @override
  Widget build(BuildContext context) {
    final notifications = _arcRepo.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'NOTIFICATIONS',
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
              Text(
                'PREFERENCES',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),

              // Preferences Controls
              ArcCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    _buildSwitchRow(
                      title: 'ENABLE NOTIFICATIONS',
                      subtitle: 'Only meaningful nudges, never spam.',
                      value: _notificationsEnabled,
                      onChanged: (v) => setState(() => _notificationsEnabled = v),
                    ),
                    const Divider(color: AppColors.border),
                    _buildSwitchRow(
                      title: 'MORNING ARC CALL',
                      subtitle: '07:30 AM · "Your Arc is waiting."',
                      value: _morningReminder && _notificationsEnabled,
                      onChanged: _notificationsEnabled ? (v) => setState(() => _morningReminder = v) : null,
                    ),
                    const Divider(color: AppColors.border),
                    _buildSwitchRow(
                      title: 'EVENING WRAP-UP',
                      subtitle: '09:00 PM · Protect recovery & complete day.',
                      value: _eveningReminder && _notificationsEnabled,
                      onChanged: _notificationsEnabled ? (v) => setState(() => _eveningReminder = v) : null,
                    ),
                    const Divider(color: AppColors.border),
                    _buildSwitchRow(
                      title: 'QUIET HOURS',
                      subtitle: '10:00 PM to 07:00 AM · Complete silence.',
                      value: _quietHours && _notificationsEnabled,
                      onChanged: _notificationsEnabled ? (v) => setState(() => _quietHours = v) : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Text(
                'RECENT ACTIVITY',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),

              if (notifications.isEmpty)
                const EmptyView(
                  title: 'NO NOTIFICATIONS',
                  message: 'You are completely caught up.',
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final notif = notifications[idx];

                    return ArcCard(
                      padding: const EdgeInsets.all(16),
                      onTap: () => _arcRepo.markNotificationAsRead(notif.id),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfaceElevated,
                            ),
                            child: Icon(
                              notif.type == 'milestone'
                                  ? Icons.flag_rounded
                                  : Icons.notifications_active_rounded,
                              size: 18,
                              color: notif.isRead ? AppColors.textTertiary : AppColors.gold,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      notif.title,
                                      style: AppTypography.titleSmall.copyWith(
                                        fontSize: 14,
                                        fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700,
                                        color: notif.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (!notif.isRead)
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.gold,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.body,
                                  style: AppTypography.bodySmall.copyWith(fontSize: 11, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelUppercase.copyWith(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.gold,
            activeTrackColor: AppColors.gold.withOpacity(0.3),
            inactiveThumbColor: AppColors.textTertiary,
            inactiveTrackColor: AppColors.surfaceElevated,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
