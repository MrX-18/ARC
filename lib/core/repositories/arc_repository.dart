import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../engine/arc_engine.dart';

class ArcRepository extends ChangeNotifier {
  static final ArcRepository _instance = ArcRepository._internal();
  factory ArcRepository() => _instance;
  ArcRepository._internal();

  final StorageService _storage = StorageService();

  Arc? _activeArc;
  List<Arc> _enrolledArcs = [];
  List<Mission> _todayMissions = [];
  List<ActivityLog> _activityLogs = [];
  List<ArcReflection> _reflections = [];
  SubscriptionPlan _subscription = const SubscriptionPlan();
  List<AppNotification> _notifications = [];
  List<Achievement> _achievements = [];
  List<Friend> _friends = [];
  List<Challenge> _challenges = [];
  List<GroupArc> _groupArcs = [];
  List<AiMessage> _aiMessages = [];

  Arc? get activeArc => _activeArc;
  List<Arc> get enrolledArcs => List.unmodifiable(_enrolledArcs);
  List<Mission> get todayMissions => List.unmodifiable(_todayMissions);
  List<ActivityLog> get activityLogs => List.unmodifiable(_activityLogs);
  List<ArcReflection> get reflections => List.unmodifiable(_reflections);
  SubscriptionPlan get subscription => _subscription;
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  List<Friend> get friends => List.unmodifiable(_friends);
  List<Challenge> get challenges => List.unmodifiable(_challenges);
  List<GroupArc> get groupArcs => List.unmodifiable(_groupArcs);
  List<AiMessage> get aiMessages => List.unmodifiable(_aiMessages);

  int get completedMissionsCount =>
      _todayMissions.where((m) => m.completed).length;

  int get totalMissionsCount => _todayMissions.length;

  double get todayProgressPercentage => _todayMissions.isEmpty
      ? 0.0
      : completedMissionsCount / totalMissionsCount;

  bool get isTodayComplete =>
      _todayMissions.isNotEmpty &&
      completedMissionsCount == _todayMissions.length;

  Future<void> init() async {
    await _storage.init();

    _activeArc = _storage.getActiveArc();
    _enrolledArcs = _storage.getEnrolledArcs();
    _todayMissions = _storage.getMissions();
    _activityLogs = _storage.getActivityLogs();
    _reflections = _storage.getReflections();
    _subscription = _storage.getSubscription();
    _notifications = _storage.getNotifications();
    _achievements = _storage.getAchievements();
    _friends = _storage.getFriends();
    _challenges = _storage.getChallenges();
    _groupArcs = _storage.getGroupArcs();
    _aiMessages = _storage.getAiMessages();

    // If no enrolled arcs exist yet, seed initial journey cards matching Screen 10
    if (_enrolledArcs.isEmpty) {
      _enrolledArcs = _initialJourneyArcs();
      await _storage.saveEnrolledArcs(_enrolledArcs);
    }

    // Seed default achievements if empty
    if (_achievements.isEmpty) {
      _achievements = _defaultAchievements();
      await _storage.saveAchievements(_achievements);
    }

    // Seed default notifications if empty
    if (_notifications.isEmpty) {
      _notifications = _defaultNotifications();
      await _storage.saveNotifications(_notifications);
    }

    // Seed default community data if empty
    if (_friends.isEmpty) {
      _friends = _defaultFriends();
      await _storage.saveFriends(_friends);
    }
    if (_challenges.isEmpty) {
      _challenges = _defaultChallenges();
      await _storage.saveChallenges(_challenges);
    }
    if (_groupArcs.isEmpty) {
      _groupArcs = _defaultGroupArcs();
      await _storage.saveGroupArcs(_groupArcs);
    }

    // If active Arc exists, ensure day is calculated and missions exist for today
    if (_activeArc != null) {
      _updateActiveArcDay();
    }

    notifyListeners();
  }

  void _updateActiveArcDay() {
    if (_activeArc == null || _activeArc!.startDate == null) return;
    final curDay = ArcEngine.calculateCurrentDay(
      _activeArc!.startDate!,
      _activeArc!.durationDays,
    );
    final progress = (curDay / _activeArc!.durationDays).clamp(0.0, 1.0);
    _activeArc = _activeArc!.copyWith(
      currentDay: curDay,
      progress: progress,
      status: curDay >= _activeArc!.durationDays
          ? ArcStatus.completed
          : ArcStatus.active,
    );
    _storage.saveActiveArc(_activeArc);

    if (_todayMissions.isEmpty) {
      _todayMissions = ArcEngine.generateDailyMissions(_activeArc!);
      _storage.saveMissions(_todayMissions);
    }
  }

  /// Atomic Arc activation
  Future<bool> activateArc(Arc arc) async {
    try {
      final now = DateTime.now();
      final totalDays = arc.durationDays;
      final endDate = now.add(Duration(days: totalDays));

      final active = arc.copyWith(
        status: ArcStatus.active,
        startDate: now,
        endDate: endDate,
        currentDay: 1,
        progress: (1.0 / totalDays).clamp(0.0, 1.0),
      );

      final missions = ArcEngine.generateDailyMissions(active);

      // Save to state and storage
      _activeArc = active;
      _todayMissions = missions;

      // Update enrolled list: mark previous active as paused or replace matching ID
      final updatedList = <Arc>[];
      bool found = false;
      for (final a in _enrolledArcs) {
        if (a.id == active.id) {
          updatedList.add(active);
          found = true;
        } else if (a.status == ArcStatus.active) {
          updatedList.add(a.copyWith(status: ArcStatus.paused));
        } else {
          updatedList.add(a);
        }
      }
      if (!found) {
        updatedList.insert(0, active);
      }

      // Sort order: 1. Active, 2. Ongoing/Paused, 3. Completed
      updatedList.sort((a, b) {
        if (a.status == ArcStatus.active) return -1;
        if (b.status == ArcStatus.active) return 1;
        if (a.status == ArcStatus.completed && b.status != ArcStatus.completed) return 1;
        if (b.status == ArcStatus.completed && a.status != ArcStatus.completed) return -1;
        return 0;
      });

      _enrolledArcs = updatedList;

      await _storage.saveActiveArc(_activeArc);
      await _storage.saveMissions(_todayMissions);
      await _storage.saveEnrolledArcs(_enrolledArcs);

      // Check first arc achievement
      _unlockAchievement('first_arc');

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error in atomic arc activation: $e');
      return false;
    }
  }

  /// Toggle mission completion
  Future<void> toggleMission(String missionId) async {
    final index = _todayMissions.indexWhere((m) => m.id == missionId);
    if (index == -1) return;

    final mission = _todayMissions[index];
    final updatedMission = mission.copyWith(completed: !mission.completed);
    _todayMissions[index] = updatedMission;

    await _storage.saveMissions(_todayMissions);

    // If mission completed, log activity
    if (updatedMission.completed) {
      await logActivity(ActivityLog(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        arcId: updatedMission.arcId,
        missionId: updatedMission.id,
        type: updatedMission.type,
        value: updatedMission.target ?? 1.0,
        unit: updatedMission.unit ?? 'COUNT',
        timestamp: DateTime.now(),
        note: 'Completed from daily missions',
      ));
    }

    // Slightly update active Arc progress
    if (_activeArc != null) {
      final baseProgress = _activeArc!.currentDay / _activeArc!.durationDays;
      final missionBonus = totalMissionsCount > 0
          ? (completedMissionsCount / totalMissionsCount) * (1.0 / _activeArc!.durationDays)
          : 0.0;
      _activeArc = _activeArc!.copyWith(
        progress: (baseProgress + missionBonus).clamp(0.0, 1.0),
      );
      await _storage.saveActiveArc(_activeArc);

      // Sync active arc progress inside enrolled arcs
      final cardIdx = _enrolledArcs.indexWhere((a) => a.id == _activeArc!.id);
      if (cardIdx != -1) {
        _enrolledArcs[cardIdx] = _activeArc!;
        await _storage.saveEnrolledArcs(_enrolledArcs);
      }
    }

    notifyListeners();
  }

  /// Log generic activity for an Arc
  Future<void> logActivity(ActivityLog log) async {
    _activityLogs.insert(0, log);
    await _storage.saveActivityLogs(_activityLogs);
    notifyListeners();
  }

  /// Get activity logs isolated by arcId
  List<ActivityLog> getArcActivityLogs(String arcId) {
    return _activityLogs.where((l) => l.arcId == arcId).toList();
  }

  /// Get specific progress for an Arc
  ArcProgress getArcProgress(String arcId) {
    final cached = _storage.getArcProgress(arcId);
    final arc = getArcById(arcId);
    final totalDays = arc?.durationDays ?? 90;
    final currentDay = arc?.currentDay ?? 1;

    // Days completed calculation
    final daysDone = arc?.status == ArcStatus.completed
        ? totalDays
        : currentDay > 1 ? currentDay - 1 : 1;

    final progressPct = arc?.progress ?? (daysDone / totalDays);
    final missionsDone = _activityLogs.where((l) => l.arcId == arcId).length + (daysDone * 2);
    final streak = currentDay > 6 ? 6 : currentDay;

    // Completed days set for calendar
    final completedDays = <int>[];
    for (int i = 1; i <= daysDone; i++) {
      // simulate realistic 85% consistency
      if (i % 7 != 4) {
        completedDays.add(i);
      }
    }

    final p = ArcProgress(
      arcId: arcId,
      daysCompleted: cached?.daysCompleted ?? daysDone,
      missionsCompleted: cached?.missionsCompleted ?? missionsDone,
      currentStreak: cached?.currentStreak ?? streak,
      progressPercentage: progressPct,
      weeklyConsistency: 0.85,
      completedDays: cached?.completedDays.isNotEmpty == true
          ? cached!.completedDays
          : completedDays,
    );
    return p;
  }

  /// Update Arc rules without destroying historical progress
  Future<void> updateArcRules(String arcId, List<String> newRules) async {
    if (_activeArc != null && _activeArc!.id == arcId) {
      _activeArc = _activeArc!.copyWith(rules: newRules);
      await _storage.saveActiveArc(_activeArc);
    }
    final idx = _enrolledArcs.indexWhere((a) => a.id == arcId);
    if (idx != -1) {
      _enrolledArcs[idx] = _enrolledArcs[idx].copyWith(rules: newRules);
      await _storage.saveEnrolledArcs(_enrolledArcs);
    }
    notifyListeners();
  }

  /// Complete active Arc atomically and transition to completed status
  Future<void> completeActiveArc() async {
    if (_activeArc == null) return;
    final completed = _activeArc!.copyWith(
      status: ArcStatus.completed,
      currentDay: _activeArc!.durationDays,
      progress: 1.0,
    );

    _activeArc = null;
    await _storage.saveActiveArc(null);

    final idx = _enrolledArcs.indexWhere((a) => a.id == completed.id);
    if (idx != -1) {
      _enrolledArcs[idx] = completed;
    } else {
      _enrolledArcs.insert(0, completed);
    }
    await _storage.saveEnrolledArcs(_enrolledArcs);

    // Unlock finisher achievement
    _unlockAchievement('finisher');

    notifyListeners();
  }

  /// Save Arc reflection
  Future<void> saveReflection(ArcReflection reflection) async {
    _reflections.insert(0, reflection);
    await _storage.saveReflections(_reflections);
    notifyListeners();
  }

  /// Create and save a custom Arc
  Future<void> createCustomArc(Arc arc, {bool activateImmediately = true}) async {
    _enrolledArcs.insert(0, arc);
    await _storage.saveEnrolledArcs(_enrolledArcs);

    if (activateImmediately) {
      await activateArc(arc);
    } else {
      notifyListeners();
    }
  }

  /// Subscription management
  Future<void> updateSubscription(SubscriptionPlan plan) async {
    _subscription = plan;
    await _storage.saveSubscription(plan);
    notifyListeners();
  }

  /// Notifications management
  Future<void> markNotificationAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = AppNotification(
        id: _notifications[idx].id,
        title: _notifications[idx].title,
        body: _notifications[idx].body,
        timestamp: _notifications[idx].timestamp,
        isRead: true,
        type: _notifications[idx].type,
      );
      await _storage.saveNotifications(_notifications);
      notifyListeners();
    }
  }

  /// Community: Join/Leave Challenge
  Future<void> toggleChallenge(String challengeId) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx != -1) {
      final cur = _challenges[idx];
      _challenges[idx] = Challenge(
        id: cur.id,
        title: cur.title,
        description: cur.description,
        durationDays: cur.durationDays,
        category: cur.category,
        participantCount: cur.joined ? cur.participantCount - 1 : cur.participantCount + 1,
        joined: !cur.joined,
        progress: cur.joined ? 0.0 : 0.1,
      );
      await _storage.saveChallenges(_challenges);
      notifyListeners();
    }
  }

  /// AI Arc Coach chat
  Future<void> sendAiMessage(String userText) async {
    final userMsg = AiMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      text: userText,
      timestamp: DateTime.now(),
    );
    _aiMessages.add(userMsg);

    // Generate contextual AI response based on real activeArc data
    String coachReply = _generateContextualAiResponse(userText);
    final coachMsg = AiMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch + 1}',
      role: 'coach',
      text: coachReply,
      timestamp: DateTime.now().add(const Duration(milliseconds: 500)),
    );
    _aiMessages.add(coachMsg);

    await _storage.saveAiMessages(_aiMessages);
    notifyListeners();
  }

  String _generateContextualAiResponse(String prompt) {
    final lower = prompt.toLowerCase();
    final arc = _activeArc;

    if (arc == null) {
      return "You do not have an active Arc yet. Choose an Arc from the Library or create a Custom Arc to begin your transformation.";
    }

    final day = arc.currentDay;
    final total = arc.durationDays;
    final completedMissions = completedMissionsCount;
    final totalMissions = totalMissionsCount;

    if (lower.contains('missed') || lower.contains('behind') || lower.contains('skip')) {
      return "You are on Day $day of ${arc.title}. Missing a session does not break your Arc. The standard is consistency over perfection. Focus on finishing today's $completedMissions/$totalMissions missions and protect your recovery tonight.";
    }

    if (lower.contains('tired') || lower.contains('rest') || lower.contains('recovery')) {
      return "Recovery is a core rule of ${arc.title}. When fatigue builds up, prioritize 8 hours of sleep and adequate hydration before pushing for volume. Your Arc is a marathon of $total days, not a single sprint.";
    }

    if (lower.contains('water') || lower.contains('hydration')) {
      return "Staying consistent with your hydration mission accelerates muscle recovery and cognitive focus. Keep your water bottle within reach today.";
    }

    if (lower.contains('progress') || lower.contains('how am i doing')) {
      final pct = (arc.progress * 100).round();
      return "You're at $pct% of your ${arc.title} Arc (Day $day / $total). You've maintained steady discipline. Continue showing up for your daily missions.";
    }

    return "I am tracking your ${arc.title} progress. You have completed $completedMissions of $totalMissions missions today on Day $day. What would you like to calibrate next?";
  }

  void _unlockAchievement(String id) {
    final idx = _achievements.indexWhere((a) => a.id == id);
    if (idx != -1 && !_achievements[idx].unlocked) {
      _achievements[idx] = Achievement(
        id: _achievements[idx].id,
        title: _achievements[idx].title,
        description: _achievements[idx].description,
        unlocked: true,
        unlockedAt: DateTime.now(),
      );
      _storage.saveAchievements(_achievements);
    }
  }

  Arc? getArcById(String id) {
    if (_activeArc != null && _activeArc!.id == id) {
      return _activeArc;
    }
    try {
      return _enrolledArcs.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Arc> _initialJourneyArcs() {
    return [
      const Arc(
        id: 'build_strength',
        title: 'BUILD STRENGTH',
        category: 'fitness',
        description: 'Build strength through consistent training, recovery, and sustainable habits.',
        durationDays: 90,
        status: ArcStatus.active,
        currentDay: 27,
        progress: 0.30,
        difficulty: 'Beginner',
        dailyCommitment: '30 min/day',
        weeklyFrequency: '3 days/week',
        coverImage: 'assets/images/card_strength.png',
        rules: [
          'Train 3 days each week.',
          'Protect your recovery.',
          'Stay consistent for 90 days.',
          'Complete your daily missions.',
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'build_strength', title: 'First Week', targetDay: 7, completed: true),
          Milestone(id: 'm2', arcId: 'build_strength', title: '25% Complete', targetDay: 23, completed: true),
          Milestone(id: 'm3', arcId: 'build_strength', title: 'Half Way There', targetDay: 45, completed: false),
          Milestone(id: 'm4', arcId: 'build_strength', title: '75% Complete', targetDay: 68, completed: false),
          Milestone(id: 'm5', arcId: 'build_strength', title: 'Arc Complete', targetDay: 90, completed: false),
        ],
      ),
      const Arc(
        id: 'reset_arc',
        title: 'RESET ARC',
        category: 'discipline',
        description: 'Reclaim your focus, optimize recovery, and build sustainable daily clarity.',
        durationDays: 30,
        status: ArcStatus.notStarted,
        currentDay: 12,
        progress: 0.40,
        difficulty: 'Beginner',
        dailyCommitment: '30 min/day',
        weeklyFrequency: '4 days/week',
        coverImage: 'assets/images/card_reset.png',
        rules: [
          'Protect 8 hours of sleep each night.',
          'Zero screen time 45 min before bed.',
          'Stay consistent for 30 days.',
          'Complete your daily missions.',
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'reset_arc', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'reset_arc', title: 'Half Way There', targetDay: 15),
          Milestone(id: 'm3', arcId: 'reset_arc', title: 'Arc Complete', targetDay: 30),
        ],
      ),
      const Arc(
        id: 'learn_cpp',
        title: 'LEARN C++',
        category: 'skills',
        description: 'Master systems programming through deliberate daily coding and practice.',
        durationDays: 60,
        status: ArcStatus.notStarted,
        currentDay: 18,
        progress: 0.30,
        difficulty: 'Intermediate',
        dailyCommitment: '45 min/day',
        weeklyFrequency: '5 days/week',
        coverImage: 'assets/images/card_cpp.png',
        rules: [
          'Code 5 days/week.',
          'Solve 1 algorithmic challenge daily.',
          'Build consistent momentum for 60 days.',
          'Complete your daily missions.',
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'learn_cpp', title: 'First Week', targetDay: 7),
          Milestone(id: 'm2', arcId: 'learn_cpp', title: '25% Complete', targetDay: 15),
          Milestone(id: 'm3', arcId: 'learn_cpp', title: 'Half Way There', targetDay: 30),
          Milestone(id: 'm4', arcId: 'learn_cpp', title: 'Arc Complete', targetDay: 60),
        ],
      ),
      const Arc(
        id: 'summer_arc',
        title: 'SUMMER ARC',
        category: 'fitness',
        description: 'High intensity conditioning and vitality for peak summer wellness.',
        durationDays: 60,
        status: ArcStatus.completed,
        currentDay: 60,
        progress: 1.0,
        difficulty: 'Intermediate',
        dailyCommitment: '45 min/day',
        weeklyFrequency: '5 days/week',
        coverImage: 'assets/images/card_summer.png',
        rules: [
          'Get outdoor sunlight within 30 min of waking.',
          'Hit 8,000 steps minimum daily.',
          'Drink 3L hydration.',
        ],
        milestones: [
          Milestone(id: 'm1', arcId: 'summer_arc', title: 'First Week', targetDay: 7, completed: true),
          Milestone(id: 'm2', arcId: 'summer_arc', title: 'Half Way There', targetDay: 30, completed: true),
          Milestone(id: 'm3', arcId: 'summer_arc', title: 'Arc Complete', targetDay: 60, completed: true),
        ],
      ),
    ];
  }

  List<Achievement> _defaultAchievements() {
    return [
      const Achievement(
        id: 'first_arc',
        title: 'FIRST ARC',
        description: 'Complete onboarding and activate your first Arc chapter.',
        unlocked: true,
      ),
      const Achievement(
        id: 'first_week',
        title: 'FIRST WEEK',
        description: 'Maintain consistency through your first 7 days.',
        unlocked: true,
      ),
      const Achievement(
        id: 'consistent',
        title: 'CONSISTENT',
        description: 'Complete 30 days of daily disciplined action.',
        unlocked: false,
      ),
      const Achievement(
        id: 'finisher',
        title: 'FINISHER',
        description: 'Cross the finish line and complete an entire Arc.',
        unlocked: false,
      ),
      const Achievement(
        id: 'second_chapter',
        title: 'SECOND CHAPTER',
        description: 'Start another Arc immediately after completing one.',
        unlocked: false,
      ),
    ];
  }

  List<AppNotification> _defaultNotifications() {
    return [
      AppNotification(
        id: 'n1',
        title: 'Your Arc is waiting',
        body: 'Day 27 of Build Strength is underway. Show up for your daily missions.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: 'mission',
      ),
      AppNotification(
        id: 'n2',
        title: 'Milestone within reach',
        body: 'You are only 18 days away from Half Way There milestone.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: 'milestone',
      ),
    ];
  }

  List<Friend> _defaultFriends() {
    return const [
      Friend(
        id: 'f1',
        name: 'Marcus Vance',
        avatar: 'assets/images/avatar.png',
        activeArcTitle: 'WINTER ARC',
        currentStreak: 14,
        daysCompleted: 42,
      ),
      Friend(
        id: 'f2',
        name: 'Elena Rostova',
        avatar: 'assets/images/avatar.png',
        activeArcTitle: 'CODING ARC',
        currentStreak: 21,
        daysCompleted: 35,
      ),
      Friend(
        id: 'f3',
        name: 'Liam Chen',
        avatar: 'assets/images/avatar.png',
        activeArcTitle: 'RESET ARC',
        currentStreak: 7,
        daysCompleted: 19,
      ),
    ];
  }

  List<Challenge> _defaultChallenges() {
    return const [
      Challenge(
        id: 'c1',
        title: '30 DAY READING CHALLENGE',
        description: 'Read 20 pages every single day without missing a session.',
        durationDays: 30,
        category: 'PERSONAL',
        participantCount: 1420,
        joined: true,
        progress: 0.35,
      ),
      Challenge(
        id: 'c2',
        title: '14 DAY MORNING ROUTINE',
        description: 'Early walk, natural sunlight, and no screen time in the first hour.',
        durationDays: 14,
        category: 'LIFESTYLE',
        participantCount: 890,
        joined: false,
        progress: 0.0,
      ),
      Challenge(
        id: 'c3',
        title: '30 DAY CODING CHALLENGE',
        description: 'Commit to code for at least 45 minutes 5 days a week.',
        durationDays: 30,
        category: 'SKILLS',
        participantCount: 2310,
        joined: false,
        progress: 0.0,
      ),
    ];
  }

  List<GroupArc> _defaultGroupArcs() {
    return const [
      GroupArc(
        id: 'g1',
        title: '30 DAY CODING SPRINT',
        durationDays: 30,
        memberCount: 5,
        groupProgress: 0.45,
        userCompletion: 0.40,
        members: ['Gorank (You)', 'Marcus Vance', 'Elena Rostova', 'Liam Chen', 'David K.'],
      ),
    ];
  }
}
