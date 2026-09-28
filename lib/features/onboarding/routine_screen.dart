import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/repositories/user_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/arc_glow_halo.dart';
import 'recommendation_screen.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final UserRepository _userRepo = UserRepository();

  String _selectedTime = '30 MINUTES';
  String _selectedDays = '3 DAYS';
  String _selectedExperience = "I'M JUST STARTING";

  final List<Map<String, dynamic>> _timeOptions = const [
    {
      'title': '15',
      'unit': 'MINUTES',
      'desc': 'Small daily\nactions.',
      'icon': Icons.wb_sunny_outlined,
    },
    {
      'title': '30',
      'unit': 'MINUTES',
      'desc': 'A realistic\ndaily routine.',
      'icon': Icons.access_time_rounded,
    },
    {
      'title': '45',
      'unit': 'MINUTES',
      'desc': 'More\nstructured.',
      'icon': Icons.access_time_rounded,
    },
    {
      'title': '60',
      'unit': 'MINUTES',
      'desc': 'Room for\ndeeper sessions.',
      'icon': Icons.access_time_rounded,
    },
    {
      'title': '90+',
      'unit': 'MINUTES',
      'desc': 'For more\navailable time.',
      'icon': Icons.timer_outlined,
    },
  ];

  final List<Map<String, dynamic>> _daysOptions = const [
    {'days': '2', 'label': 'DAYS', 'desc': 'A lighter\nstart.'},
    {'days': '3', 'label': 'DAYS', 'desc': 'A sustainable\nroutine.'},
    {'days': '4', 'label': 'DAYS', 'desc': 'Good\nbalance.'},
    {'days': '5', 'label': 'DAYS', 'desc': 'For faster\nprogress.'},
    {'days': '6', 'label': 'DAYS', 'desc': 'A higher\ncommitment.'},
    {'days': '7', 'label': 'EVERY DAY', 'desc': 'Maximum\nconsistency.'},
  ];

  final List<Map<String, dynamic>> _experienceOptions = const [
    {
      'title': "I'M JUST\nSTARTING",
      'value': "I'M JUST STARTING",
      'desc': "I'm new to\nthis.",
      'icon': Icons.eco_rounded,
    },
    {
      'title': "I'VE DONE\nTHIS BEFORE",
      'value': "I'VE DONE THIS BEFORE",
      'desc': 'I have some\nexperience.',
      'icon': Icons.bar_chart_rounded,
    },
    {
      'title': "I'M FAIRLY\nCONSISTENT",
      'value': "I'M FAIRLY CONSISTENT",
      'desc': 'I already have\na routine.',
      'icon': Icons.workspace_premium_rounded,
    },
    {
      'title': "I'M\nEXPERIENCED",
      'value': "I'M EXPERIENCED",
      'desc': 'I understand\nthis well.',
      'icon': Icons.star_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    final u = _userRepo.user;
    if (u.dailyCommitment != null) _selectedTime = u.dailyCommitment!;
    if (u.weeklyFrequency != null) _selectedDays = u.weeklyFrequency!;
    if (u.experienceLevel != null) _selectedExperience = u.experienceLevel!;
  }

  void _continue() {
    _userRepo.setRoutine(
      dailyCommitment: _selectedTime,
      weeklyFrequency: _selectedDays,
      experienceLevel: _selectedExperience,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RecommendationScreen(),
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
          const ArcGlowHalo(radius: 260, centerOffset: Offset(0, -50)),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'HOW MUCH CAN YOU\nREALISTICALLY COMMIT?',
                          textAlign: TextAlign.center,
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Build a routine you can actually maintain.',
                          textAlign: TextAlign.center,
                          style: AppTypography.subtitle,
                        ),
                        const SizedBox(height: 24),

                        // Question 1: Daily Time
                        _buildSectionHeader(
                          number: '1',
                          icon: Icons.access_time_rounded,
                          title: 'HOW MUCH TIME CAN YOU\nGIVE YOUR ARC EACH DAY?',
                          subtitle: 'Choose the time that fits your daily routine.',
                        ),
                        const SizedBox(height: 12),
                        _buildTimeRow(),

                        const SizedBox(height: 28),

                        // Question 2: Weekly Days
                        _buildSectionHeader(
                          number: '2',
                          icon: Icons.calendar_today_rounded,
                          title: 'HOW MANY DAYS A WEEK\nCAN YOU COMMIT?',
                          subtitle: 'Choose the number of days that feels realistic.',
                        ),
                        const SizedBox(height: 12),
                        _buildDaysRow(),

                        const SizedBox(height: 28),

                        // Question 3: Experience
                        _buildSectionHeader(
                          number: '3',
                          icon: Icons.bar_chart_rounded,
                          title: "WHAT'S YOUR CURRENT EXPERIENCE?",
                          subtitle: 'This helps us create the right starting point for you.',
                        ),
                        const SizedBox(height: 12),
                        _buildExperienceRow(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Action
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
                      top: BorderSide(
                        color: AppColors.borderSubtle,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ArcButton(
                    label: 'CONTINUE',
                    onPressed: _continue,
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
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                'ARC',
                style: AppTypography.brandWordmark.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Dots: 3 / 4
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isHighlighted = index <= 2;
              final isCurrent = index == 2;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isCurrent ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isHighlighted ? AppColors.gold : AppColors.border,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '3 / 4',
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

  Widget _buildSectionHeader({
    required String number,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceElevated,
            border: Border.all(color: AppColors.goldDark, width: 1.0),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTypography.labelUppercaseGold.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelUppercase.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _timeOptions.map((opt) {
          final title = opt['title'] as String;
          final unit = opt['unit'] as String;
          final desc = opt['desc'] as String;
          final icon = opt['icon'] as IconData;
          final value = '$title $unit';
          final isSelected = _selectedTime == value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 86,
              height: 124,
              child: ArcCard(
                isSelected: isSelected,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                onTap: () {
                  setState(() {
                    _selectedTime = value;
                  });
                },
                child: Stack(
                  children: [
                    if (isSelected)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppColors.gold,
                        ),
                      ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 18,
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            title,
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            unit,
                            style: AppTypography.labelUppercase.copyWith(
                              fontSize: 9,
                              letterSpacing: 0.8,
                              color: isSelected
                                  ? AppColors.gold
                                  : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            desc,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                              height: 1.15,
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
        }).toList(),
      ),
    );
  }

  Widget _buildDaysRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _daysOptions.map((opt) {
          final days = opt['days'] as String;
          final label = opt['label'] as String;
          final desc = opt['desc'] as String;
          final value = days == '7' ? 'EVERY DAY' : '$days DAYS';
          final isSelected = _selectedDays == value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 82,
              height: 120,
              child: ArcCard(
                isSelected: isSelected,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                onTap: () {
                  setState(() {
                    _selectedDays = value;
                  });
                },
                child: Stack(
                  children: [
                    if (isSelected)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppColors.gold,
                        ),
                      ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            size: 18,
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            days == '7' ? '7' : days,
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            label,
                            style: AppTypography.labelUppercase.copyWith(
                              fontSize: 9,
                              letterSpacing: 0.8,
                              color: isSelected
                                  ? AppColors.gold
                                  : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            desc,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                              height: 1.15,
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
        }).toList(),
      ),
    );
  }

  Widget _buildExperienceRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _experienceOptions.map((opt) {
          final title = opt['title'] as String;
          final value = opt['value'] as String;
          final desc = opt['desc'] as String;
          final icon = opt['icon'] as IconData;
          final isSelected = _selectedExperience == value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 96,
              height: 128,
              child: ArcCard(
                isSelected: isSelected,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                onTap: () {
                  setState(() {
                    _selectedExperience = value;
                  });
                },
                child: Stack(
                  children: [
                    if (isSelected)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppColors.gold,
                        ),
                      ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 18,
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppTypography.labelUppercase.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            desc,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                              height: 1.15,
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
        }).toList(),
      ),
    );
  }
}
