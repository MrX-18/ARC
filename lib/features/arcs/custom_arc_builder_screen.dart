import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../shell/app_shell.dart';

class CustomArcBuilderScreen extends StatefulWidget {
  const CustomArcBuilderScreen({super.key});

  @override
  State<CustomArcBuilderScreen> createState() => _CustomArcBuilderScreenState();
}

class _CustomArcBuilderScreenState extends State<CustomArcBuilderScreen> {
  final ArcRepository _arcRepo = ArcRepository();
  int _currentStep = 0; // 0 to 7 (Review is step 7)

  // Step 1: Name
  final TextEditingController _nameController = TextEditingController(text: '30 Day Coding Sprint');
  // Step 2: Goal
  final TextEditingController _goalController = TextEditingController(text: 'Learn Python & algorithms');
  // Step 3: Duration
  int _selectedDuration = 30;
  // Step 4: Commitment
  String _dailyCommitment = '45 min/day';
  String _weeklyFrequency = '5 days/week';
  // Step 5: Missions
  final List<String> _missions = [
    'Code for 30 minutes',
    'Complete one lesson / read docs',
  ];
  final TextEditingController _newMissionController = TextEditingController();
  // Step 6: Rules
  final List<String> _rules = [
    'Protect your deep focus block.',
    'No phone notifications during sessions.',
    'Never skip two days in a row.',
  ];
  final TextEditingController _newRuleController = TextEditingController();
  // Step 7: Milestones
  late List<Milestone> _milestones;

  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    _recomputeMilestones();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _newMissionController.dispose();
    _newRuleController.dispose();
    super.dispose();
  }

  void _recomputeMilestones() {
    final half = (_selectedDuration / 2).round();
    _milestones = [
      Milestone(id: 'm1', arcId: 'custom', title: 'First Week', targetDay: 7),
      Milestone(id: 'm2', arcId: 'custom', title: 'Half Way There', targetDay: half),
      Milestone(id: 'm3', arcId: 'custom', title: 'Arc Complete', targetDay: _selectedDuration),
    ];
  }

  void _nextStep() {
    if (_currentStep < 7) {
      setState(() => _currentStep++);
    } else {
      _startCustomArc();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _startCustomArc() async {
    setState(() => _isStarting = true);
    final arcId = 'custom_${DateTime.now().millisecondsSinceEpoch}';

    final arcMissions = _missions.map((m) {
      return Mission(
        id: 'cm_${DateTime.now().millisecondsSinceEpoch}_${m.hashCode}',
        arcId: arcId,
        title: m.toUpperCase(),
        description: 'Daily custom mission',
        type: 'study',
        frequency: 'DAILY',
        date: '',
      );
    }).toList();

    final arcMilestones = _milestones.map((ms) {
      return ms.copyWith(arcId: arcId);
    }).toList();

    final customArc = Arc(
      id: arcId,
      title: _nameController.text.trim().toUpperCase(),
      category: 'custom',
      description: _goalController.text.trim(),
      durationDays: _selectedDuration,
      status: ArcStatus.notStarted,
      difficulty: 'Intermediate',
      dailyCommitment: _dailyCommitment,
      weeklyFrequency: _weeklyFrequency,
      coverImage: 'assets/images/card_reset.png',
      rules: _rules,
      missions: arcMissions,
      milestones: arcMilestones,
    );

    await _arcRepo.createCustomArc(customArc, activateImmediately: true);

    if (mounted) {
      setState(() => _isStarting = false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AppShell(initialIndex: 0)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const totalSteps = 8;
    final progress = (_currentStep + 1) / totalSteps;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: _prevStep,
        ),
        title: Text(
          'CUSTOM ARC',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STEP ${_currentStep + 1} OF $totalSteps',
                        style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: AppTypography.labelUppercase.copyWith(fontSize: 10, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppColors.progressTrack,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                    ),
                  ),
                ],
              ),
            ),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _buildCurrentStepContent(),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ArcButton(
                label: _currentStep == 7
                    ? (_isStarting ? 'STARTING...' : 'START ARC →')
                    : 'CONTINUE →',
                isLoading: _isStarting,
                onPressed: _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Name();
      case 1:
        return _buildStep2Goal();
      case 2:
        return _buildStep3Duration();
      case 3:
        return _buildStep4Commitment();
      case 4:
        return _buildStep5Missions();
      case 5:
        return _buildStep6Rules();
      case 6:
        return _buildStep7Milestones();
      case 7:
        return _buildStep8Review();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1Name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NAME YOUR ARC', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Give your transformation chapter a clear, inspiring title.', style: AppTypography.subtitle),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          autofocus: true,
          style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary, fontSize: 18),
          decoration: InputDecoration(
            hintText: 'e.g. 30 Day Coding Sprint',
            hintStyle: AppTypography.subtitle,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.borderGold)),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Goal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WHAT IS YOUR GOAL?', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Describe what success looks like at the end of this Arc.', style: AppTypography.subtitle),
        const SizedBox(height: 24),
        TextField(
          controller: _goalController,
          maxLines: 3,
          autofocus: true,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'e.g. Learn Python and build two web scrapers and solve 30 algorithmic challenges.',
            hintStyle: AppTypography.subtitle,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.borderGold)),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Duration() {
    final options = [7, 14, 30, 60, 90];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HOW LONG?', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Arcs are time-bound chapters. Select your timeline.', style: AppTypography.subtitle),
        const SizedBox(height: 24),
        Column(
          children: options.map((days) {
            final isSelected = _selectedDuration == days;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ArcCard(
                isSelected: isSelected,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                onTap: () {
                  setState(() {
                    _selectedDuration = days;
                    _recomputeMilestones();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$days DAYS', style: AppTypography.titleSmall.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 20)
                    else
                      const Icon(Icons.circle_outlined, color: AppColors.border, size: 20),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep4Commitment() {
    final dailyOptions = ['30 min/day', '45 min/day', '60 min/day', '90 min/day'];
    final weeklyOptions = ['3 days/week', '4 days/week', '5 days/week', '6 days/week', 'DAILY'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HOW MUCH CAN YOU COMMIT?', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Set realistic daily volume and weekly frequency.', style: AppTypography.subtitle),
        const SizedBox(height: 20),
        Text('DAILY TIME COMMITMENT', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: dailyOptions.map((opt) {
            final isSelected = _dailyCommitment == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: AppColors.gold,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              onSelected: (_) => setState(() => _dailyCommitment = opt),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text('WEEKLY FREQUENCY', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weeklyOptions.map((opt) {
            final isSelected = _weeklyFrequency == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: AppColors.gold,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              onSelected: (_) => setState(() => _weeklyFrequency = opt),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep5Missions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ADD YOUR MISSIONS', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Daily actionable micro-goals that compound toward the Arc.', style: AppTypography.subtitle),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newMissionController,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. Read 20 pages',
                  hintStyle: AppTypography.subtitle,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                final text = _newMissionController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _missions.add(text);
                    _newMissionController.clear();
                  });
                }
              },
              icon: const Icon(Icons.add_circle_rounded, color: AppColors.gold, size: 36),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: _missions.asMap().entries.map((entry) {
            final idx = entry.key;
            final m = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ArcCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.gold, size: 18),
                    const SizedBox(width: 12),
                    Expanded(child: Text(m, style: AppTypography.titleSmall.copyWith(fontSize: 14))),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textTertiary),
                      onPressed: () => setState(() => _missions.removeAt(idx)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep6Rules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ADD CORE RULES', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Define non-negotiables that will govern your Arc chapter.', style: AppTypography.subtitle),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newRuleController,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. No phone before breakfast',
                  hintStyle: AppTypography.subtitle,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                final text = _newRuleController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _rules.add(text);
                    _newRuleController.clear();
                  });
                }
              },
              icon: const Icon(Icons.add_circle_rounded, color: AppColors.gold, size: 36),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: _rules.asMap().entries.map((entry) {
            final idx = entry.key;
            final r = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ArcCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text((idx + 1).toString().padLeft(2, '0'), style: AppTypography.labelUppercaseGold),
                    const SizedBox(width: 14),
                    Expanded(child: Text(r, style: AppTypography.bodySmall.copyWith(fontSize: 13, color: AppColors.textPrimary))),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textTertiary),
                      onPressed: () => setState(() => _rules.removeAt(idx)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep7Milestones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MILESTONES', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Target milestones mapped automatically to your $_selectedDuration-day timeline.', style: AppTypography.subtitle),
        const SizedBox(height: 20),
        Column(
          children: _milestones.map((ms) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ArcCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flag_rounded, color: AppColors.gold, size: 18),
                        const SizedBox(width: 12),
                        Text(ms.title, style: AppTypography.titleSmall.copyWith(fontSize: 14)),
                      ],
                    ),
                    Text('DAY ${ms.targetDay}', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep8Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('REVIEW YOUR ARC', style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Check your parameters before launching this chapter.', style: AppTypography.subtitle),
        const SizedBox(height: 24),
        ArcCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ARC TITLE', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
              const SizedBox(height: 4),
              Text(_nameController.text.trim().toUpperCase(), style: AppTypography.titleLarge.copyWith(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              Text('GOAL', style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
              const SizedBox(height: 4),
              Text(_goalController.text.trim(), style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DURATION', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                  Text('$_selectedDuration DAYS', style: AppTypography.labelUppercaseGold),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('COMMITMENT', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                  Text(_dailyCommitment, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FREQUENCY', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                  Text(_weeklyFrequency, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DAILY MISSIONS', style: AppTypography.labelUppercase.copyWith(fontSize: 10)),
                  Text('${_missions.length} CONFIGURED', style: AppTypography.bodySmall.copyWith(color: AppColors.goldLight)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
