import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/providers/ai_service_provider.dart';
import '../../core/providers/arc_providers.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../shell/app_shell.dart';

class AiArcGeneratorScreen extends ConsumerStatefulWidget {
  const AiArcGeneratorScreen({super.key});

  @override
  ConsumerState<AiArcGeneratorScreen> createState() => _AiArcGeneratorScreenState();
}

class _AiArcGeneratorScreenState extends ConsumerState<AiArcGeneratorScreen> {
  final TextEditingController _promptController = TextEditingController(
    text: 'I want to learn Blender 3D modeling and rendering in 60 days',
  );
  Arc? _generatedArc;
  bool _isGenerating = false;
  bool _isActivating = false;

  Future<void> _generateArc() async {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isGenerating = true);
    try {
      final aiService = ref.read(aiServiceProvider);
      final arc = await aiService.generateArcFromPrompt(text);
      if (mounted) {
        setState(() {
          _generatedArc = arc;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Generation error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _approveAndActivate() async {
    if (_generatedArc == null) return;
    setState(() => _isActivating = true);

    await ref.read(activeArcProvider.notifier).activateArc(_generatedArc!);

    if (mounted) {
      setState(() => _isActivating = false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AppShell(initialIndex: 0)),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AI ARC GENERATOR',
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
                'NATURAL LANGUAGE SYNTHESIS',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'DESCRIBE YOUR GOAL',
                style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'AI synthesizes a complete time-bound Arc, core rules, daily missions, and milestones.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Prompt Input Field
              TextField(
                controller: _promptController,
                maxLines: 3,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. I want to learn Python in 30 days and build 2 automation tools.',
                  hintStyle: AppTypography.subtitle,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.borderGold)),
                ),
              ),
              const SizedBox(height: 16),

              // Generate Action
              ArcButton(
                label: _isGenerating ? 'SYNTHESIZING ARC WITH AI...' : 'GENERATE ARC →',
                isLoading: _isGenerating,
                onPressed: _generateArc,
              ),
              const SizedBox(height: 28),

              // Generated Arc Review Section
              if (_generatedArc != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGold),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.gold, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Review before activation. AI changes are never activated silently.',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.goldLight),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'GENERATED ARC PREVIEW',
                  style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),

                ArcCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _generatedArc!.category.toUpperCase(),
                            style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9),
                          ),
                          Text(
                            '${_generatedArc!.durationDays} DAYS',
                            style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _generatedArc!.title,
                        style: AppTypography.titleLarge.copyWith(fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _generatedArc!.description,
                        style: AppTypography.subtitle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 12),

                      Text('DAILY MISSIONS', style: AppTypography.labelUppercase.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                      const SizedBox(height: 8),
                      ..._generatedArc!.missions.map((m) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: AppColors.gold, size: 14),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(m.title, style: AppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.textPrimary)),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 14),

                      Text('MILESTONES', style: AppTypography.labelUppercase.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                      const SizedBox(height: 8),
                      ..._generatedArc!.milestones.map((ms) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ms.title, style: AppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                              Text('DAY ${ms.targetDay}', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Approve & Activate CTA
                ArcButton(
                  label: _isActivating ? 'ACTIVATING...' : 'APPROVE & START ARC →',
                  isLoading: _isActivating,
                  onPressed: _approveAndActivate,
                ),
                const SizedBox(height: 36),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
