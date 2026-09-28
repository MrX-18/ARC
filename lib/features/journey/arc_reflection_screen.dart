import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_button.dart';
import 'next_arc_screen.dart';

class ArcReflectionScreen extends StatefulWidget {
  final Arc arc;

  const ArcReflectionScreen({super.key, required this.arc});

  @override
  State<ArcReflectionScreen> createState() => _ArcReflectionScreenState();
}

class _ArcReflectionScreenState extends State<ArcReflectionScreen> {
  final ArcRepository _arcRepo = ArcRepository();

  final TextEditingController _changedController = TextEditingController();
  final TextEditingController _proudController = TextEditingController();
  final TextEditingController _hardestController = TextEditingController();
  final TextEditingController _differentController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _changedController.dispose();
    _proudController.dispose();
    _hardestController.dispose();
    _differentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveReflection() async {
    setState(() => _isSaving = true);

    final reflection = ArcReflection(
      id: 'refl_${DateTime.now().millisecondsSinceEpoch}',
      arcId: widget.arc.id,
      arcTitle: widget.arc.title,
      date: DateTime.now(),
      whatChanged: _changedController.text.trim().isNotEmpty
          ? _changedController.text.trim()
          : 'Built discipline and consistent daily routine.',
      mostProudOf: _proudController.text.trim().isNotEmpty
          ? _proudController.text.trim()
          : 'Showing up on days when motivation was low.',
      hardestPart: _hardestController.text.trim().isNotEmpty
          ? _hardestController.text.trim()
          : 'Staying consistent during travel and fatigue.',
      doDifferently: _differentController.text.trim().isNotEmpty
          ? _differentController.text.trim()
          : 'Protect recovery and sleep earlier.',
      notes: _notesController.text.trim(),
    );

    await _arcRepo.saveReflection(reflection);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => NextArcScreen(previousArc: widget.arc),
        ),
      );
    }
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
          'ARC REFLECTION',
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
                'YOUR ARC IS COMPLETE.',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                widget.arc.title,
                style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Take a quiet moment to reflect before starting your next chapter.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 28),

              // Question 1: What changed?
              _buildQuestionField(
                number: '01',
                question: 'What changed?',
                hint: 'e.g. My morning habits, physical endurance, and focus.',
                controller: _changedController,
              ),
              const SizedBox(height: 24),

              // Question 2: What are you most proud of?
              _buildQuestionField(
                number: '02',
                question: 'What are you most proud of?',
                hint: 'e.g. Not skipping a single session in week 6.',
                controller: _proudController,
              ),
              const SizedBox(height: 24),

              // Question 3: What was hardest?
              _buildQuestionField(
                number: '03',
                question: 'What was hardest?',
                hint: 'e.g. Waking up early in cold mornings and prioritizing recovery.',
                controller: _hardestController,
              ),
              const SizedBox(height: 24),

              // Question 4: What would you do differently?
              _buildQuestionField(
                number: '04',
                question: 'What would you do differently?',
                hint: 'e.g. Hydrate more consistently during workdays.',
                controller: _differentController,
              ),
              const SizedBox(height: 24),

              // Optional Notes
              _buildQuestionField(
                number: '05',
                question: 'Final thoughts (Optional)',
                hint: 'Personal notes for your journey archive...',
                controller: _notesController,
              ),
              const SizedBox(height: 36),

              // Save CTA
              ArcButton(
                label: _isSaving ? 'SAVING...' : 'SAVE REFLECTION →',
                isLoading: _isSaving,
                onPressed: _saveReflection,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionField({
    required String number,
    required String question,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(number, style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
            const SizedBox(width: 8),
            Text(question, style: AppTypography.titleSmall.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 3,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 12),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderGold),
            ),
          ),
        ),
      ],
    );
  }
}
