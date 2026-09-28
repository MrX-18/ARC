import '../models/models.dart';

class ArcEngine {
  ArcEngine._();

  /// Deterministic recommendation algorithm based on user onboarding inputs
  static Arc recommendArc({
    required List<String> selectedAreas,
    required String? primaryGoal,
    required String? dailyCommitment,
    required String? weeklyFrequency,
    required String? experienceLevel,
  }) {
    final areas = selectedAreas.map((e) => e.toUpperCase()).toList();
    final goal = (primaryGoal ?? '').toUpperCase();
    final commitment = dailyCommitment ?? '30 MINUTES';
    final frequency = weeklyFrequency ?? '3 DAYS';
    final experience = experienceLevel ?? "I'M JUST STARTING";

    String commitmentText = commitment.toLowerCase().replaceAll('minutes', 'min/day');
    String frequencyText = frequency.toLowerCase().replaceAll('days', 'days/week');
    String difficultyText = 'Beginner';
    if (experience.contains('EXPERIENCED')) {
      difficultyText = 'Advanced';
    } else if (experience.contains('FAIRLY') || experience.contains('DONE THIS')) {
      difficultyText = 'Intermediate';
    }

    // Rule 1: Learning or Skills
    if (areas.contains('LEARNING') ||
        areas.contains('SKILLS') ||
        goal.contains('PROGRAMMING') ||
        goal.contains('C++') ||
        goal.contains('STUDY')) {
      return Arc(
        id: 'learn_cpp',
        title: 'LEARN C++',
        category: 'skills',
        description: 'Master core systems programming through deliberate daily coding and practice.',
        durationDays: 60,
        status: ArcStatus.notStarted,
        difficulty: difficultyText,
        dailyCommitment: commitmentText,
        weeklyFrequency: frequencyText,
        coverImage: 'assets/images/card_cpp.png',
        rules: [
          'Code $frequencyText.',
          'Solve 1 algorithmic challenge daily.',
          'Build consistent momentum for 60 days.',
          'Complete your daily missions.',
        ],
        missions: [
          Mission(
            id: 'cpp_code',
            arcId: 'learn_cpp',
            title: '45 MIN C++ PRACTICE',
            description: 'Algorithms and memory management practice.',
            type: 'study',
            frequency: frequencyText.toUpperCase(),
            date: _todayString(),
            target: 45,
            unit: 'MIN',
            category: 'skills',
          ),
          Mission(
            id: 'cpp_doc',
            arcId: 'learn_cpp',
            title: 'READ 10 PAGES OF DOCS',
            description: 'Core concepts and standard library.',
            type: 'reading',
            frequency: 'DAILY',
            date: _todayString(),
            target: 10,
            unit: 'PAGES',
            category: 'learning',
          ),
          Mission(
            id: 'cpp_sleep',
            arcId: 'learn_cpp',
            title: 'SLEEP BEFORE 11:30 PM',
            description: 'Protect your cognitive recovery.',
            type: 'sleep',
            frequency: 'DAILY',
            date: _todayString(),
            target: 8,
            unit: 'HOURS',
            category: 'lifestyle',
          ),
        ],
        milestones: const [
          Milestone(id: 'm1', arcId: 'learn_cpp', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'learn_cpp', title: '25% Complete', targetDay: 15),
          Milestone(id: 'm3', arcId: 'learn_cpp', title: 'Half Way There', targetDay: 30),
          Milestone(id: 'm4', arcId: 'learn_cpp', title: '75% Complete', targetDay: 45),
          Milestone(id: 'm5', arcId: 'learn_cpp', title: 'Arc Complete', targetDay: 60),
        ],
      );
    }

    // Rule 2: Better Sleep or Discipline or Mental Wellbeing
    if ((areas.contains('BETTER SLEEP') || areas.contains('DISCIPLINE') || areas.contains('MENTAL WELLBEING')) &&
        !areas.contains('FITNESS')) {
      return Arc(
        id: 'reset_arc',
        title: 'RESET ARC',
        category: 'discipline',
        description: 'Reclaim your focus, optimize recovery, and build sustainable daily clarity.',
        durationDays: 30,
        status: ArcStatus.notStarted,
        difficulty: difficultyText,
        dailyCommitment: commitmentText,
        weeklyFrequency: frequencyText,
        coverImage: 'assets/images/card_reset.png',
        rules: [
          'Protect 8 hours of sleep each night.',
          'Zero screen time 45 min before bed.',
          'Stay consistent for 30 days.',
          'Complete your daily missions.',
        ],
        missions: [
          Mission(
            id: 'reset_morning',
            arcId: 'reset_arc',
            title: '20 MIN MORNING WALK',
            description: 'Natural sunlight and mental focus.',
            type: 'activity',
            frequency: 'DAILY',
            date: _todayString(),
            target: 20,
            unit: 'MIN',
            category: 'lifestyle',
          ),
          Mission(
            id: 'reset_water',
            arcId: 'reset_arc',
            title: 'DRINK 2.5L WATER',
            description: 'Stay hydrated for brain function.',
            type: 'hydration',
            frequency: 'DAILY',
            date: _todayString(),
            target: 2.5,
            unit: 'L',
            category: 'lifestyle',
          ),
          Mission(
            id: 'reset_sleep',
            arcId: 'reset_arc',
            title: 'SLEEP BEFORE 11:00 PM',
            description: 'Rebuild your circadian rhythm.',
            type: 'sleep',
            frequency: 'DAILY',
            date: _todayString(),
            target: 8,
            unit: 'HOURS',
            category: 'lifestyle',
          ),
        ],
        milestones: const [
          Milestone(id: 'm1', arcId: 'reset_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'reset_arc', title: 'Habit Foundation', targetDay: 14),
          Milestone(id: 'm3', arcId: 'reset_arc', title: 'Half Way There', targetDay: 15),
          Milestone(id: 'm4', arcId: 'reset_arc', title: 'Arc Complete', targetDay: 30),
        ],
      );
    }

    // Default / Fitness Arc: BUILD STRENGTH
    return Arc(
      id: 'build_strength',
      title: 'BUILD STRENGTH',
      category: 'fitness',
      description: 'Build strength through consistent training, recovery, and sustainable habits.',
      durationDays: 90,
      status: ArcStatus.notStarted,
      difficulty: difficultyText,
      dailyCommitment: commitmentText,
      weeklyFrequency: frequencyText,
      coverImage: 'assets/images/card_strength.png',
      rules: [
        'Train 3 days each week.',
        'Protect your recovery.',
        'Stay consistent for 90 days.',
        'Complete your daily missions.',
      ],
      missions: [
        Mission(
          id: 'str_session',
          arcId: 'build_strength',
          title: '30 MIN STRENGTH SESSION',
          description: 'Full body training, 3× per week.',
          type: 'workout',
          frequency: '3× / WEEK',
          date: _todayString(),
          target: 30,
          unit: 'MIN',
          category: 'fitness',
        ),
        Mission(
          id: 'str_water',
          arcId: 'build_strength',
          title: 'DRINK 2L WATER',
          description: 'Stay hydrated for better recovery.',
          type: 'hydration',
          frequency: 'DAILY',
          date: _todayString(),
          target: 2.0,
          unit: 'L',
          category: 'lifestyle',
        ),
        Mission(
          id: 'str_sleep',
          arcId: 'build_strength',
          title: 'SLEEP BEFORE 11:30 PM',
          description: 'Improve recovery and energy.',
          type: 'sleep',
          frequency: 'DAILY',
          date: _todayString(),
          target: 8,
          unit: 'HOURS',
          category: 'lifestyle',
        ),
      ],
      milestones: const [
        Milestone(id: 'm1', arcId: 'build_strength', title: 'First Week', targetDay: 7),
        Milestone(id: 'm2', arcId: 'build_strength', title: '25% Complete', targetDay: 23),
        Milestone(id: 'm3', arcId: 'build_strength', title: 'Half Way There', targetDay: 45),
        Milestone(id: 'm4', arcId: 'build_strength', title: '75% Complete', targetDay: 68),
        Milestone(id: 'm5', arcId: 'build_strength', title: 'Arc Complete', targetDay: 90),
      ],
    );
  }

  /// Curated Library Templates
  static List<ArcTemplate> getCuratedTemplates() {
    return [
      const ArcTemplate(
        id: 'winter_arc',
        title: 'WINTER ARC',
        category: 'FITNESS',
        description: 'Build discipline, strength, sleep and consistency through the colder months.',
        durationDays: 90,
        difficulty: 'Advanced',
        dailyCommitment: '45 min/day',
        weeklyFrequency: '5 days/week',
        coverImage: 'assets/images/card_winter.png',
        activities: [
          'Heavy compound resistance training',
          'Cold morning exposure & discipline walks',
          'Strict hydration & zero empty sugars',
          'Sleep hygiene in complete darkness',
        ],
        outcomes: [
          'Noticeable physical strength & mental armor',
          'Unyielding daily routine consistency',
          'Restored circadian rhythm',
        ],
        rules: [
          'No snoozing alarms under any circumstance.',
          'Train 5 days every single week.',
          'Zero alcohol for the 90 days.',
          'Complete all daily missions.',
        ],
        missions: [
          Mission(
            id: 'wa_lift',
            arcId: 'winter_arc',
            title: '45 MIN RESISTANCE WORKOUT',
            description: 'Compound lifts and hypertrophy.',
            type: 'workout',
            frequency: '5× / WEEK',
            date: '',
            target: 45,
            unit: 'MIN',
            category: 'fitness',
          ),
          Mission(
            id: 'wa_water',
            arcId: 'winter_arc',
            title: 'DRINK 3L WATER',
            description: 'Optimal cell hydration & recovery.',
            type: 'hydration',
            frequency: 'DAILY',
            date: '',
            target: 3.0,
            unit: 'L',
            category: 'lifestyle',
          ),
          Mission(
            id: 'wa_sleep',
            arcId: 'winter_arc',
            title: 'SLEEP BEFORE 10:30 PM',
            description: '8 hours of dark, uninterrupted sleep.',
            type: 'sleep',
            frequency: 'DAILY',
            date: '',
            target: 8,
            unit: 'HOURS',
            category: 'lifestyle',
          ),
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'winter_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'winter_arc', title: '25% Complete', targetDay: 23),
          Milestone(id: 'm3', arcId: 'winter_arc', title: 'Half Way There', targetDay: 45),
          Milestone(id: 'm4', arcId: 'winter_arc', title: '75% Complete', targetDay: 68),
          Milestone(id: 'm5', arcId: 'winter_arc', title: 'Arc Complete', targetDay: 90),
        ],
      ),
      const ArcTemplate(
        id: 'summer_arc',
        title: 'SUMMER ARC',
        category: 'FITNESS',
        description: 'Fitness, running, hydration and outdoor activity for peak conditioning.',
        durationDays: 60,
        difficulty: 'Intermediate',
        dailyCommitment: '45 min/day',
        weeklyFrequency: '4 days/week',
        coverImage: 'assets/images/card_summer.png',
        activities: [
          'Interval running & outdoor cardio',
          'Calisthenics & core conditioning',
          'Electrolyte hydration protocol',
        ],
        outcomes: [
          'High cardiovascular endurance',
          'Lean functional athletic posture',
          'Energized daily vitality',
        ],
        rules: [
          'Get outdoor sunlight within 30 min of waking.',
          'Hit 8,000 steps minimum daily.',
          'Drink 3L hydration.',
        ],
        missions: [
          Mission(
            id: 'sa_run',
            arcId: 'summer_arc',
            title: '5 KM OUTDOOR RUN / INTERVALS',
            description: 'Aerobic base building.',
            type: 'workout',
            frequency: '4× / WEEK',
            date: '',
            target: 5.0,
            unit: 'KM',
            category: 'fitness',
          ),
          Mission(
            id: 'sa_water',
            arcId: 'summer_arc',
            title: 'DRINK 3L WATER',
            description: 'Electrolytes & hydration.',
            type: 'hydration',
            frequency: 'DAILY',
            date: '',
            target: 3.0,
            unit: 'L',
            category: 'lifestyle',
          ),
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'summer_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'summer_arc', title: 'Half Way There', targetDay: 30),
          Milestone(id: 'm3', arcId: 'summer_arc', title: 'Arc Complete', targetDay: 60),
        ],
      ),
      const ArcTemplate(
        id: 'reset_arc',
        title: 'RESET ARC',
        category: 'LIFESTYLE',
        description: 'Rebuild your routine, sleep and focus through intentional daily habits.',
        durationDays: 30,
        difficulty: 'Beginner',
        dailyCommitment: '30 min/day',
        weeklyFrequency: '4 days/week',
        coverImage: 'assets/images/card_reset.png',
        activities: [
          'Early morning walking & grounding',
          'Digital detox 45 min before sleep',
          'Structured hydration & clean nutrition',
        ],
        outcomes: [
          'Calm, focused nervous system',
          'Consistent wake and bed times',
          'Decreased daily stress and anxiety',
        ],
        rules: [
          'No phones in bedroom overnight.',
          'Hydrate before caffeine.',
          'Protect 8 hours in bed.',
        ],
        missions: [
          Mission(
            id: 'res_walk',
            arcId: 'reset_arc',
            title: '20 MIN MORNING WALK',
            description: 'Sunlight and clear thoughts.',
            type: 'activity',
            frequency: 'DAILY',
            date: '',
            target: 20,
            unit: 'MIN',
            category: 'lifestyle',
          ),
          Mission(
            id: 'res_water',
            arcId: 'reset_arc',
            title: 'DRINK 2.5L WATER',
            description: 'Continuous brain hydration.',
            type: 'hydration',
            frequency: 'DAILY',
            date: '',
            target: 2.5,
            unit: 'L',
            category: 'lifestyle',
          ),
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'reset_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'reset_arc', title: 'Half Way There', targetDay: 15),
          Milestone(id: 'm3', arcId: 'reset_arc', title: 'Arc Complete', targetDay: 30),
        ],
      ),
      const ArcTemplate(
        id: 'coding_arc',
        title: 'CODING ARC',
        category: 'SKILLS',
        description: 'Build a daily coding habit, ship real software, and master modern stacks.',
        durationDays: 60,
        difficulty: 'Intermediate',
        dailyCommitment: '45 min/day',
        weeklyFrequency: '5 days/week',
        coverImage: 'assets/images/card_cpp.png',
        activities: [
          'Focused deep work coding session',
          'Reading system architecture & documentation',
          'Refactoring and committing code daily',
        ],
        outcomes: [
          'Production-grade shipped portfolio project',
          'Fluent problem-solving intuition',
          'Consistent git contribution streak',
        ],
        rules: [
          'Code for 45 focused minutes with zero notifications.',
          'Make at least one git commit per session.',
          'Review 1 open source code pattern weekly.',
        ],
        missions: [
          Mission(
            id: 'code_session',
            arcId: 'coding_arc',
            title: 'CODE FOR 45 MINUTES',
            description: 'Deliberate project coding without distraction.',
            type: 'study',
            frequency: '5× / WEEK',
            date: '',
            target: 45,
            unit: 'MIN',
            category: 'skills',
          ),
          Mission(
            id: 'code_doc',
            arcId: 'coding_arc',
            title: 'READ 15 PAGES OF DOCS / BOOK',
            description: 'System design, patterns or algorithms.',
            type: 'reading',
            frequency: 'DAILY',
            date: '',
            target: 15,
            unit: 'PAGES',
            category: 'learning',
          ),
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'coding_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'coding_arc', title: 'Core Architecture Built', targetDay: 20),
          Milestone(id: 'm3', arcId: 'coding_arc', title: 'Half Way There', targetDay: 30),
          Milestone(id: 'm4', arcId: 'coding_arc', title: 'Project Shipped', targetDay: 60),
        ],
      ),
      const ArcTemplate(
        id: 'study_arc',
        title: 'STUDY ARC',
        category: 'LEARNING',
        description: 'Build a disciplined study routine, master deep focus, and retain knowledge.',
        durationDays: 45,
        difficulty: 'Intermediate',
        dailyCommitment: '60 min/day',
        weeklyFrequency: '6 days/week',
        coverImage: 'assets/images/card_reset.png',
        activities: [
          'Pomodoro deep work study blocks',
          'Spaced repetition flashcards review',
          'Active recall summary notes',
        ],
        outcomes: [
          'Deep mastery of your subject matter',
          'Unshakable study stamina',
          'Confidence in upcoming assessments',
        ],
        rules: [
          'Zero phone access during study blocks.',
          'Write flashcards for every difficult concept.',
          'Sleep minimum 7.5 hours for memory consolidation.',
        ],
        missions: [
          Mission(
            id: 'std_session',
            arcId: 'study_arc',
            title: 'STUDY FOR 60 MINUTES',
            description: 'Active recall & problem solving.',
            type: 'study',
            frequency: '6× / WEEK',
            date: '',
            target: 60,
            unit: 'MIN',
            category: 'learning',
          ),
          Mission(
            id: 'std_cards',
            arcId: 'study_arc',
            title: 'REVIEW 30 FLASHCARDS',
            description: 'Spaced repetition system.',
            type: 'study',
            frequency: 'DAILY',
            date: '',
            target: 30,
            unit: 'CARDS',
            category: 'learning',
          ),
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'study_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'study_arc', title: 'Half Way There', targetDay: 22),
          Milestone(id: 'm3', arcId: 'study_arc', title: 'Arc Complete', targetDay: 45),
        ],
      ),
      const ArcTemplate(
        id: 'reading_arc',
        title: 'READING ARC',
        category: 'PERSONAL',
        description: 'Read deeply and consistently for a defined 30-day transformation chapter.',
        durationDays: 30,
        difficulty: 'Beginner',
        dailyCommitment: '30 min/day',
        weeklyFrequency: 'DAILY',
        coverImage: 'assets/images/card_cpp.png',
        activities: [
          'Daily focused non-fiction or literature reading',
          'Highlighting and extracting key insights',
          'Weekly one-page synthesis writing',
        ],
        outcomes: [
          '2 to 4 books thoroughly absorbed',
          'Strengthened attention span',
          'Refined worldview and vocabulary',
        ],
        rules: [
          'Read before turning on any screens in the evening.',
          'Annotate or take notes on core ideas.',
          'Never skip two days in a row.',
        ],
        missions: [
          Mission(
            id: 'read_pages',
            arcId: 'reading_arc',
            title: 'READ 20 PAGES',
            description: 'Quiet, uninterrupted book reading.',
            type: 'reading',
            frequency: 'DAILY',
            date: '',
            target: 20,
            unit: 'PAGES',
            category: 'personal',
          ),
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'reading_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'reading_arc', title: 'Half Way There', targetDay: 15),
          Milestone(id: 'm3', arcId: 'reading_arc', title: 'Arc Complete', targetDay: 30),
        ],
      ),
      // Marketplace Arc
      const ArcTemplate(
        id: 'hypertrophy_foundation',
        title: 'HYPERTROPHY FOUNDATION',
        category: 'FITNESS',
        description: 'Elite science-based strength & hypertrophy program engineered by Alex Rivera.',
        durationDays: 75,
        difficulty: 'Advanced',
        dailyCommitment: '60 min/day',
        weeklyFrequency: '4 days/week',
        coverImage: 'assets/images/card_strength.png',
        isMarketplace: true,
        creator: 'Alex Rivera, CSCS',
        price: '₹499',
        rating: 4.9,
        activities: [
          'Periodized upper / lower strength splits',
          'Targeted RPE volume progressions',
          'Recovery protocol and protein timing',
        ],
        outcomes: [
          'Measurable compound lift PRs',
          'Optimized muscle retention & density',
        ],
        rules: [
          'Track every working set RPE.',
          'Hit 1.8g protein per kg bodyweight.',
        ],
        missions: [
          Mission(
            id: 'hyp_lift',
            arcId: 'hypertrophy_foundation',
            title: '60 MIN HYPERTROPHY PROTOCOL',
            description: 'Upper / lower periodized session.',
            type: 'workout',
            frequency: '4× / WEEK',
            date: '',
            target: 60,
            unit: 'MIN',
            category: 'fitness',
          ),
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'hypertrophy_foundation', title: 'Phase 1 Adaptation', targetDay: 14),
          Milestone(id: 'm2', arcId: 'hypertrophy_foundation', title: 'Phase 2 Overload', targetDay: 45),
          Milestone(id: 'm3', arcId: 'hypertrophy_foundation', title: 'Peak Strength', targetDay: 75),
        ],
      ),
    ];
  }

  /// AI Arc Generator from natural language prompt
  static Arc generateFromPrompt(String prompt) {
    final lower = prompt.toLowerCase();
    int duration = 60;
    if (lower.contains('30 day') || lower.contains('30-day') || lower.contains('30d')) {
      duration = 30;
    } else if (lower.contains('90 day') || lower.contains('90-day') || lower.contains('90d')) {
      duration = 90;
    } else if (lower.contains('14 day') || lower.contains('14-day') || lower.contains('2 week')) {
      duration = 14;
    }

    String title = 'CUSTOM TRANSFORMATION ARC';
    String category = 'custom';
    String cover = 'assets/images/card_reset.png';
    List<Mission> missions = [];
    List<String> rules = [
      'Show up every single day.',
      'Protect your focus time.',
      'Complete your daily missions without excuses.',
      'Never skip two days in a row.',
    ];

    if (lower.contains('blender') || lower.contains('3d')) {
      title = 'BLENDER 3D ARC';
      category = 'skills';
      cover = 'assets/images/card_cpp.png';
      missions = [
        Mission(
          id: 'gen_blender_concept',
          arcId: 'ai_gen_arc',
          title: 'LEARN 1 BLENDER CONCEPT',
          description: 'Tutorial or documentation review.',
          type: 'study',
          frequency: 'DAILY',
          date: _todayString(),
          target: 20,
          unit: 'MIN',
        ),
        Mission(
          id: 'gen_blender_prac',
          arcId: 'ai_gen_arc',
          title: 'PRACTICE 3D MODELING',
          description: 'Hands-on viewport modeling and modifiers.',
          type: 'study',
          frequency: '5× / WEEK',
          date: _todayString(),
          target: 30,
          unit: 'MIN',
        ),
        Mission(
          id: 'gen_blender_render',
          arcId: 'ai_gen_arc',
          title: 'COMPLETE 1 MINI RENDER',
          description: 'Lighting, materials and final export.',
          type: 'activity',
          frequency: 'WEEKLY',
          date: _todayString(),
          target: 1,
          unit: 'RENDER',
        ),
      ];
    } else if (lower.contains('code') || lower.contains('python') || lower.contains('flutter') || lower.contains('rust')) {
      title = lower.contains('python')
          ? 'PYTHON MASTERY ARC'
          : lower.contains('rust')
              ? 'RUST SYSTEMS ARC'
              : 'SOFTWARE SPRINT ARC';
      category = 'skills';
      cover = 'assets/images/card_cpp.png';
      missions = [
        Mission(
          id: 'gen_code_time',
          arcId: 'ai_gen_arc',
          title: 'CODE FOR 40 MINUTES',
          description: 'Focused implementation on project repository.',
          type: 'study',
          frequency: '5× / WEEK',
          date: _todayString(),
          target: 40,
          unit: 'MIN',
        ),
        Mission(
          id: 'gen_code_algo',
          arcId: 'ai_gen_arc',
          title: 'SOLVE 1 PROBLEM / REFACTOR',
          description: 'Data structures or architecture polish.',
          type: 'study',
          frequency: 'DAILY',
          date: _todayString(),
          target: 1,
          unit: 'TASK',
        ),
      ];
    } else if (lower.contains('run') || lower.contains('marathon') || lower.contains('10k') || lower.contains('fitness')) {
      title = 'ENDURANCE ARC';
      category = 'fitness';
      cover = 'assets/images/card_summer.png';
      missions = [
        Mission(
          id: 'gen_run_dist',
          arcId: 'ai_gen_arc',
          title: 'AEROBIC RUNNING SESSION',
          description: 'Zone 2 cardiovascular endurance run.',
          type: 'workout',
          frequency: '4× / WEEK',
          date: _todayString(),
          target: 35,
          unit: 'MIN',
        ),
        Mission(
          id: 'gen_run_hydr',
          arcId: 'ai_gen_arc',
          title: 'DRINK 3L WATER',
          description: 'Essential fluid and electrolyte retention.',
          type: 'hydration',
          frequency: 'DAILY',
          date: _todayString(),
          target: 3.0,
          unit: 'L',
        ),
      ];
    } else {
      title = '${prompt.trim().toUpperCase()} ARC';
      missions = [
        Mission(
          id: 'gen_gen_act',
          arcId: 'ai_gen_arc',
          title: '30 MIN FOCUSED ACTION',
          description: 'Deliberate progress toward $prompt.',
          type: 'study',
          frequency: '5× / WEEK',
          date: _todayString(),
          target: 30,
          unit: 'MIN',
        ),
        Mission(
          id: 'gen_gen_rev',
          arcId: 'ai_gen_arc',
          title: 'DAILY PROGRESS REFLECTION',
          description: 'Log insights and plan tomorrow.',
          type: 'reading',
          frequency: 'DAILY',
          date: _todayString(),
          target: 10,
          unit: 'MIN',
        ),
      ];
    }

    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final adjustedMissions = missions.map((m) => m.copyWith(arcId: id)).toList();

    return Arc(
      id: id,
      title: title,
      category: category,
      description: 'AI-tailored transformation chapter designed for "$prompt".',
      durationDays: duration,
      status: ArcStatus.notStarted,
      difficulty: 'Intermediate',
      dailyCommitment: '45 min/day',
      weeklyFrequency: '5 days/week',
      coverImage: cover,
      rules: rules,
      missions: adjustedMissions,
      milestones: [
        Milestone(id: 'm1', arcId: id, title: 'First Week', targetDay: 7),
        Milestone(id: 'm2', arcId: id, title: 'Half Way There', targetDay: (duration / 2).round()),
        Milestone(id: 'm3', arcId: id, title: 'Arc Complete', targetDay: duration),
      ],
    );
  }

  /// Calculates current day given activation start date and total duration
  static int calculateCurrentDay(DateTime startDate, int totalDays) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final diff = today.difference(start).inDays + 1;
    if (diff < 1) return 1;
    if (diff > totalDays) return totalDays;
    return diff;
  }

  /// Generates fresh missions for today's date based on Arc specification
  static List<Mission> generateDailyMissions(Arc arc) {
    final today = _todayString();
    return arc.missions.map((m) {
      return m.copyWith(date: today, completed: false);
    }).toList();
  }

  static String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
