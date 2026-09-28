import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/state_views.dart';
import '../arc_progress/arc_progress_screen.dart';

class CardsScreen extends StatefulWidget {
  final VoidCallback? onStartAnArc;

  const CardsScreen({super.key, this.onStartAnArc});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final ArcRepository _arcRepo = ArcRepository();

  @override
  void initState() {
    super.initState();
    _arcRepo.addListener(_onRepoUpdated);
  }

  @override
  void dispose() {
    _arcRepo.removeListener(_onRepoUpdated);
    super.dispose();
  }

  void _onRepoUpdated() {
    if (mounted) setState(() {});
  }

  void _onCardTap(String arcId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArcProgressScreen(arcId: arcId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = _arcRepo.enrolledArcs;

    if (cards.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: EmptyView(
            title: "YOUR JOURNEY\nHASN'T STARTED YET.",
            message:
                'Every Arc you choose will live here as a chapter of your personal transformation.',
            actionLabel: 'START AN ARC',
            onAction: widget.onStartAnArc,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopBar(context),

            // Scrollable Content with virtualized SliverGrid
            Expanded(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          // Main Heading
                          Row(
                            children: [
                              Text(
                                'YOUR ',
                                style: AppTypography.titleLarge.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'CARDS',
                                style: AppTypography.titleLarge.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.gold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Every Arc you've chosen, all in one place.",
                            style: AppTypography.subtitle.copyWith(fontSize: 13),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.64, // Exact portrait card ratio
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final card = cards[index];
                          return _ArcPortraitCard(
                            arc: card,
                            onTap: () => _onCardTap(card.id),
                          );
                        },
                        childCount: cards.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 32), // balance
          Column(
            children: [
              Text(
                'ARC',
                style: AppTypography.brandWordmark.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 2),
              Text(
                'CARDS',
                style: AppTypography.labelUppercaseGold.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                'YOUR ARC JOURNEY',
                style: AppTypography.labelUppercase.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.gold,
              size: 22,
            ),
            onPressed: () {
              // Contextual options sheet
              _showOptionsSheet(context);
            },
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
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
              const SizedBox(height: 16),
              Text('JOURNEY OPTIONS', style: AppTypography.labelUppercaseGold),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.sort_rounded, color: AppColors.gold),
                title: Text('Sort by Progress', style: AppTypography.body),
                onTap: () => Navigator.of(ctx).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined,
                    color: AppColors.textSecondary),
                title: Text('View Completed Arcs', style: AppTypography.body),
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArcPortraitCard extends StatelessWidget {
  final Arc arc;
  final VoidCallback onTap;

  const _ArcPortraitCard({
    required this.arc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = arc.status == ArcStatus.active;
    final isCompleted = arc.status == ArcStatus.completed;
    final progressPct = (arc.progress * 100).round();
    final dayStr = arc.currentDay.toString().padLeft(2, '0');
    final totalDaysStr = arc.durationDays.toString().padLeft(2, '0');

    // Dynamic image asset
    String imageAsset = arc.coverImage;
    if (imageAsset.isEmpty) {
      if (arc.id.contains('strength')) {
        imageAsset = 'assets/images/card_strength.png';
      } else if (arc.id.contains('reset')) {
        imageAsset = 'assets/images/card_reset.png';
      } else if (arc.id.contains('cpp')) {
        imageAsset = 'assets/images/card_cpp.png';
      } else if (arc.id.contains('winter')) {
        imageAsset = 'assets/images/card_winter.png';
      } else {
        imageAsset = 'assets/images/card_summer.png';
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.borderGold : AppColors.border,
            width: isActive ? 1.4 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.borderGoldGlow.withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Artwork
            Positioned.fill(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                cacheWidth: 400,
                errorBuilder: (_, __, ___) =>
                    Container(color: AppColors.surfaceElevated),
              ),
            ),

            // Cinematic dark gradient overlay (vibrant top, solid dark text background)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x220B0B0D),
                      Color(0x660B0B0D),
                      Color(0xDD0B0B0D),
                      Color(0xFF0B0B0D),
                    ],
                    stops: [0.0, 0.38, 0.72, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Top Status Badge (Active or Completed)
            Positioned(
              top: 12,
              left: 12,
              child: _buildBadge(isActive, isCompleted),
            ),

            // Bottom Content
            Positioned(
              left: 14,
              right: 14,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    arc.title,
                    style: AppTypography.titleSmall.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${arc.durationDays} DAY ARC',
                    style: AppTypography.labelUppercase.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.0,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Day progress label
                  if (!isCompleted)
                    Text(
                      'DAY $dayStr / $totalDaysStr',
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 6),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: arc.progress.clamp(0.01, 1.0),
                      minHeight: 4,
                      backgroundColor: AppColors.progressTrack,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.gold),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Percentage Text
                  Text(
                    '$progressPct% COMPLETE',
                    style: AppTypography.labelUppercaseGold.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(bool isActive, bool isCompleted) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGold.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'ACTIVE',
              style: AppTypography.labelUppercaseGold.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      );
    } else if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                size: 10, color: AppColors.gold),
            const SizedBox(width: 4),
            Text(
              'COMPLETED',
              style: AppTypography.labelUppercaseGold.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
