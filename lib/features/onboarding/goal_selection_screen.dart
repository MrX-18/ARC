import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/arc_glow_halo.dart';
import 'main_goal_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final UserRepository _userRepo = UserRepository();
  final Set<String> _selectedAreas = {};

  final List<Map<String, dynamic>> _areaOptions = const [
    {
      'id': 'FITNESS',
      'label': 'FITNESS',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'id': 'ENDURANCE',
      'label': 'ENDURANCE',
      'icon': Icons.directions_run_rounded,
    },
    {
      'id': 'BETTER SLEEP',
      'label': 'BETTER SLEEP',
      'icon': Icons.nightlight_round,
    },
    {
      'id': 'MENTAL WELLBEING',
      'label': 'MENTAL WELLBEING',
      'icon': Icons.psychology_rounded,
    },
    {
      'id': 'DISCIPLINE',
      'label': 'DISCIPLINE',
      'icon': Icons.access_time_filled_rounded,
    },
    {
      'id': 'LEARNING',
      'label': 'LEARNING',
      'icon': Icons.menu_book_rounded,
    },
    {
      'id': 'SKILLS',
      'label': 'SKILLS',
      'icon': Icons.laptop_mac_rounded,
    },
    {
      'id': 'PERSONAL GOAL',
      'label': 'PERSONAL GOAL',
      'icon': Icons.track_changes_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Preload user's existing selections if any
    _selectedAreas.addAll(_userRepo.user.selectedAreas);
    // If empty initially, seed default recommendation selections matching reference
    if (_selectedAreas.isEmpty) {
      _selectedAreas.addAll(['FITNESS', 'MENTAL WELLBEING', 'DISCIPLINE']);
    }
  }

  void _toggleArea(String id) {
    setState(() {
      if (_selectedAreas.contains(id)) {
        _selectedAreas.remove(id);
      } else {
        _selectedAreas.add(id);
      }
    });
  }

  void _continue() {
    if (_selectedAreas.isEmpty) return;

    _userRepo.setSelectedAreas(_selectedAreas.toList());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MainGoalScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient glowing halo
          const ArcGlowHalo(radius: 260, centerOffset: Offset(0, -50)),

          SafeArea(
            child: Column(
              children: [
                // Top Header with Back, ARC logo, and step progress
                _buildHeader(context),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'WHAT ARE YOU\nWORKING ON?',
                          textAlign: TextAlign.center,
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose everything you want to improve.',
                          textAlign: TextAlign.center,
                          style: AppTypography.subtitle,
                        ),
                        const SizedBox(height: 24),

                        // 2-column cards grid
                        _buildGrid(),

                        const SizedBox(height: 24),

                        // Selected areas count & chips
                        if (_selectedAreas.isNotEmpty) ...[
                          _buildSelectedSummary(),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button
                Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    bottomInset > 0 ? bottomInset + 8 : 20,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      top: BorderSide(color: AppColors.borderSubtle, width: 1.0),
                    ),
                  ),
                  child: ArcButton(
                    label: 'CONTINUE',
                    onPressed: _selectedAreas.isNotEmpty ? _continue : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppColors.textPrimary),
                onPressed: () {
                  _userRepo.setSelectedAreas(_selectedAreas.toList());
                  Navigator.of(context).pop();
                },
              ),
              Text(
                'ARC',
                style: AppTypography.brandWordmark.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 48), // balance back button
            ],
          ),
          const SizedBox(height: 8),

          // Progress Dots: 1 / 4
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isCurrent = index == 0;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isCurrent ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isCurrent ? AppColors.gold : AppColors.border,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '1 / 4',
            style: AppTypography.labelStepProgress.copyWith(fontSize: 11),
          ),
          Text(
            'PERSONALIZE YOUR ARC',
            style: AppTypography.labelUppercase.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: _areaOptions.length,
      itemBuilder: (context, index) {
        final item = _areaOptions[index];
        final id = item['id'] as String;
        final isSelected = _selectedAreas.contains(id);

        return ArcCard(
          isSelected: isSelected,
          onTap: () => _toggleArea(id),
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              if (isSelected)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: AppColors.gold,
                  ),
                ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 26,
                      color: isSelected ? AppColors.gold : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item['label'] as String,
                      textAlign: TextAlign.center,
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 11,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedSummary() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.borderSubtle)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '${_selectedAreas.length} AREAS SELECTED',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.borderSubtle)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _selectedAreas.map((areaId) {
            // Find proper display label
            final match = _areaOptions.firstWhere(
              (o) => o['id'] == areaId,
              orElse: () => {'label': areaId},
            );
            final label = match['label'] as String;
            final formatted = label
                .split(' ')
                .map((word) => word.isNotEmpty
                    ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                    : '')
                .join(' ');

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.chipBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatted,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _toggleArea(areaId),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
