import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';

class ArcDetailStubScreen extends StatelessWidget {
  final String arcId;

  const ArcDetailStubScreen({super.key, required this.arcId});

  @override
  Widget build(BuildContext context) {
    final arcRepo = ArcRepository();
    final arc = arcRepo.getArcById(arcId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ARC PROGRESS',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CHAPTER DETAILS',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 6),
              Text(
                arc?.title ?? arcId.toUpperCase(),
                style: AppTypography.titleLarge.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 4),
              Text(
                'Route: /cards/$arcId',
                style: AppTypography.labelUppercase.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 24),
              ArcCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STATUS',
                          style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                        ),
                        Text(
                          arc?.status.name ?? 'ACTIVE',
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DURATION',
                          style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                        ),
                        Text(
                          '${arc?.durationDays ?? 90} DAYS',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CURRENT PROGRESS',
                          style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                        ),
                        Text(
                          '${((arc?.progress ?? 0.3) * 100).round()}% COMPLETE',
                          style: AppTypography.labelUppercaseGold.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (arc?.progress ?? 0.3).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppColors.progressTrack,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.gold, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Full Screen 11 Detailed Arc Progress will connect to this route architecture.',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
