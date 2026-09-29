import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/ai_coach_provider.dart';
import '../../core/providers/arc_providers.dart';
import 'ai_arc_generator_screen.dart';

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  final List<String> _quickPrompts = [
    'I missed a workout this week.',
    'How is my recovery & sleep?',
    'Analyze my Arc progress so far.',
    'Suggest a rest day calibration.',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messages = ref.read(aiCoachProvider);
      if (messages.isEmpty) {
        _seedInitialMessage();
      }
    });
  }

  void _seedInitialMessage() {
    final active = ref.read(activeArcProvider);
    final title = active?.title ?? 'my current Arc';
    ref.read(aiCoachProvider.notifier).sendStreamingMessage(
      'Hello Coach. I am ready to review my $title progress.',
      active,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty || _isSending) return;

    _textController.clear();
    setState(() => _isSending = true);

    final activeArc = ref.read(activeArcProvider);
    await ref.read(aiCoachProvider.notifier).sendStreamingMessage(clean, activeArc);

    if (mounted) {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(activeArcProvider);
    final messages = ref.watch(aiCoachProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AI ARC COACH',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.gold),
            tooltip: 'Generate Arc with AI',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AiArcGeneratorScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Active Arc Context Card
            if (active != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderGold),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TRACKING CONTEXT', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9)),
                        const SizedBox(height: 2),
                        Text(active.title, style: AppTypography.titleSmall.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Text(
                      'DAY ${active.currentDay} / ${active.durationDays} · ${(active.progress * 100).round()}%',
                      style: AppTypography.labelUppercase.copyWith(fontSize: 10, color: AppColors.goldLight),
                    ),
                  ],
                ),
              ),

            // Quick Prompt Chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickPrompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final prompt = _quickPrompts[idx];
                  return ActionChip(
                    label: Text(prompt),
                    backgroundColor: AppColors.surfaceElevated,
                    labelStyle: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textPrimary),
                    side: const BorderSide(color: AppColors.border),
                    onPressed: () => _sendMessage(prompt),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Chat Feed
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: messages.length,
                itemBuilder: (context, idx) {
                  final msg = messages[idx];
                  final isCoach = msg.role == 'coach';

                  return Align(
                    alignment: isCoach ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.82,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isCoach ? AppColors.surface : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCoach ? AppColors.border : AppColors.borderGold,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isCoach ? Icons.smart_toy_outlined : Icons.person_outline,
                                size: 12,
                                color: isCoach ? AppColors.gold : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isCoach ? 'ARC COACH' : 'YOU',
                                style: AppTypography.labelUppercase.copyWith(
                                  fontSize: 8,
                                  color: isCoach ? AppColors.gold : AppColors.textSecondary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            msg.text,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Ask your coach about your Arc...',
                        hintStyle: AppTypography.subtitle.copyWith(fontSize: 12),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.borderGold)),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward_rounded, color: AppColors.textDark, size: 20),
                      onPressed: () => _sendMessage(_textController.text),
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
}
