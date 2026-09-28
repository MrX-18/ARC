import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/engine/arc_engine.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/state_views.dart';
import 'arc_details_screen.dart';
import 'custom_arc_builder_screen.dart';

class ArcsScreen extends StatefulWidget {
  const ArcsScreen({super.key});

  @override
  State<ArcsScreen> createState() => _ArcsScreenState();
}

class _ArcsScreenState extends State<ArcsScreen> {
  String _selectedCategory = 'ALL';
  late final List<ArcTemplate> _allTemplates;
  final List<String> _categories = [
    'ALL',
    'FITNESS',
    'LIFESTYLE',
    'LEARNING',
    'SKILLS',
    'PERSONAL',
  ];

  @override
  void initState() {
    super.initState();
    _allTemplates = ArcEngine.getCuratedTemplates();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = _selectedCategory == 'ALL'
        ? _allTemplates
        : _allTemplates.where((t) => t.category.toUpperCase() == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: Text(
                  'ARC',
                  style: AppTypography.brandWordmark.copyWith(fontSize: 18),
                ),
              ),
            ),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DISCOVER',
                    style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'FIND YOUR NEXT ARC.',
                    style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Curated transformation chapters or design your own.',
                    style: AppTypography.subtitle.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Categories Filter Chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelected = _selectedCategory == cat;

                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.gold,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.gold : AppColors.border,
                      width: 1,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Main Virtualized List
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: filteredTemplates.isEmpty ? 2 : filteredTemplates.length + 1,
                itemBuilder: (context, idx) {
                  if (idx == 0) {
                    // Create Custom Arc Banner
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ArcCard(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CustomArcBuilderScreen(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surfaceElevated,
                                border: Border.all(color: AppColors.borderGold),
                              ),
                              child: const Icon(Icons.add_rounded, color: AppColors.gold, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CREATE CUSTOM ARC',
                                    style: AppTypography.labelUppercaseGold.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Design an Arc tailored to your unique goals and missions.',
                                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.gold),
                          ],
                        ),
                      ),
                    );
                  }

                  if (filteredTemplates.isEmpty) {
                    return const EmptyView(
                      title: 'NO ARCS IN CATEGORY',
                      message: 'Try selecting another category or create a custom Arc.',
                    );
                  }

                  final template = filteredTemplates[idx - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _buildArcLibraryCard(context, template),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArcLibraryCard(BuildContext context, ArcTemplate template) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArcDetailsScreen(template: template),
          ),
        );
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Artwork
            Positioned.fill(
              child: Image.asset(
                template.coverImage.isNotEmpty ? template.coverImage : 'assets/images/card_strength.png',
                fit: BoxFit.cover,
                cacheWidth: 700,
                errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceElevated),
              ),
            ),

            // Cinematic Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x220B0B0D),
                      Color(0xBB0B0B0D),
                      Color(0xF50B0B0D),
                    ],
                    stops: [0.0, 0.5, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderGold),
                        ),
                        child: Text(
                          template.category.toUpperCase(),
                          style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          '${template.durationDays} DAYS',
                          style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),

                  // Bottom Title & Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.title,
                        style: AppTypography.titleLarge.copyWith(fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        template.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subtitle.copyWith(fontSize: 12, height: 1.3),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${template.dailyCommitment} · ${template.weeklyFrequency}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.goldLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'EXPLORE',
                                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.gold),
                            ],
                          ),
                        ],
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
}
