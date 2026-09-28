import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/pricing_config.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';

class ProPaywallScreen extends StatefulWidget {
  const ProPaywallScreen({super.key});

  @override
  State<ProPaywallScreen> createState() => _ProPaywallScreenState();
}

class _ProPaywallScreenState extends State<ProPaywallScreen> {
  final ArcRepository _arcRepo = ArcRepository();
  bool _isAnnualSelected = true;
  bool _isProcessing = false;

  Future<void> _handleStartPro() async {
    setState(() => _isProcessing = true);

    final plan = SubscriptionPlan(
      isPro: true,
      planType: _isAnnualSelected ? 'annual' : 'monthly',
      expiresAt: DateTime.now().add(
        _isAnnualSelected ? const Duration(days: 365) : const Duration(days: 30),
      ),
    );

    await _arcRepo.updateSubscription(plan);

    if (mounted) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.surfaceElevated,
          content: Text(
            '✓ WELCOME TO ARC PRO',
            style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAlreadyPro = _arcRepo.subscription.isPro;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ARC PRO',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceElevated,
                    border: Border.all(color: AppColors.borderGold, width: 1.5),
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 28),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'GO FURTHER WITH ARC PRO',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Unshakable accountability, unlimited chapters, and contextual intelligence.',
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle.copyWith(fontSize: 13),
                ),
              ),
              const SizedBox(height: 28),

              // Feature Highlights
              ArcCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildFeatureItem(Icons.all_inclusive_rounded, 'UNLIMITED ARCS', 'Run simultaneous chapters or switch anytime'),
                    const SizedBox(height: 14),
                    _buildFeatureItem(Icons.auto_awesome_rounded, 'AI ARC COACH', 'Contextual advice based on real completion stats'),
                    const SizedBox(height: 14),
                    _buildFeatureItem(Icons.build_rounded, 'CUSTOM ARC BUILDER', 'Design time-bound chapters tailored to your goals'),
                    const SizedBox(height: 14),
                    _buildFeatureItem(Icons.analytics_outlined, 'DEEP INSIGHTS', 'Consistency metrics, fitness & lifestyle trends'),
                    const SizedBox(height: 14),
                    _buildFeatureItem(Icons.cloud_sync_rounded, 'CLOUD SYNC & BACKUP', 'Safeguard your transformation logs across devices'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (isAlreadyPro) ...[
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold),
                    ),
                    child: Text(
                      'YOU ARE CURRENTLY AN ARC PRO MEMBER',
                      style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ] else ...[
                // Pricing Selector Cards
                Row(
                  children: [
                    // Annual (Highlighted)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnnualSelected = true),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isAnnualSelected ? AppColors.surfaceElevated : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isAnnualSelected ? AppColors.gold : AppColors.border,
                              width: _isAnnualSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  PricingConfig.annualSavings,
                                  style: AppTypography.labelUppercase.copyWith(
                                    fontSize: 8,
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('ANNUAL', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                              const SizedBox(height: 4),
                              Text(PricingConfig.annualPrice, style: AppTypography.titleMedium.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                              Text(PricingConfig.annualPerMonthEquivalent, style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Monthly
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnnualSelected = false),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: !_isAnnualSelected ? AppColors.surfaceElevated : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: !_isAnnualSelected ? AppColors.gold : AppColors.border,
                              width: !_isAnnualSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FLEXIBLE', style: AppTypography.labelUppercase.copyWith(fontSize: 8, color: AppColors.textTertiary)),
                              const SizedBox(height: 14),
                              Text('MONTHLY', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                              const SizedBox(height: 4),
                              Text(PricingConfig.monthlyPrice, style: AppTypography.titleMedium.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                              Text('/ month', style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // CTA
                ArcButton(
                  label: _isProcessing
                      ? 'ACTIVATING...'
                      : 'START PRO (${_isAnnualSelected ? PricingConfig.annualPrice : PricingConfig.monthlyPrice}) →',
                  isLoading: _isProcessing,
                  onPressed: _handleStartPro,
                ),
                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'CONTINUE WITH FREE',
                      style: AppTypography.labelUppercase.copyWith(color: AppColors.textTertiary, fontSize: 11),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(width: 14),
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
                description,
                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
