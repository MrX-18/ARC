import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/state_views.dart';

class ArcRulesScreen extends StatefulWidget {
  final String arcId;

  const ArcRulesScreen({super.key, required this.arcId});

  @override
  State<ArcRulesScreen> createState() => _ArcRulesScreenState();
}

class _ArcRulesScreenState extends State<ArcRulesScreen> {
  final ArcRepository _arcRepo = ArcRepository();

  void _showAddOrEditRuleDialog(BuildContext context, {int? index, String? existingRule}) {
    final controller = TextEditingController(text: existingRule ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            index == null ? 'ADD RULE' : 'EDIT RULE',
            style: AppTypography.titleSmall,
          ),
          content: TextField(
            controller: controller,
            maxLines: 3,
            autofocus: true,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter rule statement...',
              hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderGold),
              ),
            ),
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
                backgroundColor: AppColors.ctaBackground,
                foregroundColor: AppColors.ctaText,
              ),
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  final arc = _arcRepo.getArcById(widget.arcId);
                  if (arc != null) {
                    final updatedRules = List<String>.from(arc.rules);
                    if (index == null) {
                      updatedRules.add(text);
                    } else {
                      updatedRules[index] = text;
                    }
                    await _arcRepo.updateArcRules(arc.id, updatedRules);
                    setState(() {});
                  }
                }
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: Text(index == null ? 'ADD' : 'SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arc = _arcRepo.getArcById(widget.arcId);

    if (arc == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: EmptyView(
          title: 'ARC NOT FOUND',
          message: 'Unable to load rules for this chapter.',
          actionLabel: 'GO BACK',
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    final rules = arc.rules;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ARC RULES',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.gold),
            onPressed: () => _showAddOrEditRuleDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: rules.isEmpty
            ? EmptyView(
                title: 'NO RULES DEFINED',
                message: 'Add your non-negotiables for this Arc.',
                actionLabel: 'ADD A RULE',
                onAction: () => _showAddOrEditRuleDialog(context),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arc.title,
                      style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Non-negotiables and principles for your transformation.',
                      style: AppTypography.subtitle.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 32),

                    // Editorial Numbered Rules List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rules.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 28),
                      itemBuilder: (context, idx) {
                        final ruleNumber = (idx + 1).toString().padLeft(2, '0');
                        final ruleText = rules[idx];

                        return InkWell(
                          onTap: () => _showAddOrEditRuleDialog(
                            context,
                            index: idx,
                            existingRule: ruleText,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ruleNumber,
                                style: AppTypography.labelUppercaseGold.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ruleText,
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 1,
                                color: AppColors.borderSubtle,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                    ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_clock_rounded, color: AppColors.gold, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Rules shape your identity. Editing rules preserves all historical daily logs.',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                            ),
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
}
