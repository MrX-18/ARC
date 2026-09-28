import 'dart:convert';

enum ArcStatus {
  active,
  completed,
  paused,
  notStarted,
}

extension ArcStatusExtension on ArcStatus {
  String get name {
    switch (this) {
      case ArcStatus.active:
        return 'ACTIVE';
      case ArcStatus.completed:
        return 'COMPLETED';
      case ArcStatus.paused:
        return 'PAUSED';
      case ArcStatus.notStarted:
        return 'NOT STARTED';
    }
  }

  static ArcStatus fromString(String val) {
    switch (val.toUpperCase()) {
      case 'ACTIVE':
        return ArcStatus.active;
      case 'COMPLETED':
        return ArcStatus.completed;
      case 'PAUSED':
        return ArcStatus.paused;
      default:
        return ArcStatus.notStarted;
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final List<String> selectedAreas;
  final String? primaryGoal;
  final String? dailyCommitment;
  final String? weeklyFrequency;
  final String? experienceLevel;
  final bool onboardingCompleted;

  const UserProfile({
    required this.id,
    required this.name,
    this.selectedAreas = const [],
    this.primaryGoal,
    this.dailyCommitment,
    this.weeklyFrequency,
    this.experienceLevel,
    this.onboardingCompleted = false,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    List<String>? selectedAreas,
    String? primaryGoal,
    String? dailyCommitment,
    String? weeklyFrequency,
    String? experienceLevel,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      dailyCommitment: dailyCommitment ?? this.dailyCommitment,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'selectedAreas': selectedAreas,
      'primaryGoal': primaryGoal,
      'dailyCommitment': dailyCommitment,
      'weeklyFrequency': weeklyFrequency,
      'experienceLevel': experienceLevel,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? 'user_1',
      name: map['name'] ?? 'Gorank',
      selectedAreas: List<String>.from(map['selectedAreas'] ?? []),
      primaryGoal: map['primaryGoal'],
      dailyCommitment: map['dailyCommitment'],
      weeklyFrequency: map['weeklyFrequency'],
      experienceLevel: map['experienceLevel'],
      onboardingCompleted: map['onboardingCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));
}

class Mission {
  final String id;
  final String arcId;
  final String title;
  final String description;
  final String type; // e.g. "workout", "hydration", "sleep", "study", "reading"
  final String frequency; // "DAILY", "3× / WEEK"
  final bool completed;
  final String date; // YYYY-MM-DD
  final double? target;
  final String? unit; // "MINUTES", "L", "PAGES"
  final String? category;

  const Mission({
    required this.id,
    required this.arcId,
    required this.title,
    required this.description,
    required this.type,
    required this.frequency,
    this.completed = false,
    required this.date,
    this.target,
    this.unit,
    this.category,
  });

  Mission copyWith({
    String? id,
    String? arcId,
    String? title,
    String? description,
    String? type,
    String? frequency,
    bool? completed,
    String? date,
    double? target,
    String? unit,
    String? category,
  }) {
    return Mission(
      id: id ?? this.id,
      arcId: arcId ?? this.arcId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      completed: completed ?? this.completed,
      date: date ?? this.date,
      target: target ?? this.target,
      unit: unit ?? this.unit,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arcId': arcId,
      'title': title,
      'description': description,
      'type': type,
      'frequency': frequency,
      'completed': completed,
      'date': date,
      'target': target,
      'unit': unit,
      'category': category,
    };
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id: map['id'] ?? '',
      arcId: map['arcId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      frequency: map['frequency'] ?? 'DAILY',
      completed: map['completed'] ?? false,
      date: map['date'] ?? '',
      target: (map['target'] as num?)?.toDouble(),
      unit: map['unit'],
      category: map['category'],
    );
  }
}

class Milestone {
  final String id;
  final String arcId;
  final String title;
  final int targetDay;
  final bool completed;

  const Milestone({
    required this.id,
    required this.arcId,
    required this.title,
    required this.targetDay,
    this.completed = false,
  });

  Milestone copyWith({
    String? id,
    String? arcId,
    String? title,
    int? targetDay,
    bool? completed,
  }) {
    return Milestone(
      id: id ?? this.id,
      arcId: arcId ?? this.arcId,
      title: title ?? this.title,
      targetDay: targetDay ?? this.targetDay,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arcId': arcId,
      'title': title,
      'targetDay': targetDay,
      'completed': completed,
    };
  }

  factory Milestone.fromMap(Map<String, dynamic> map) {
    return Milestone(
      id: map['id'] ?? '',
      arcId: map['arcId'] ?? '',
      title: map['title'] ?? '',
      targetDay: map['targetDay'] ?? 0,
      completed: map['completed'] ?? false,
    );
  }
}

class ActivityLog {
  final String id;
  final String arcId;
  final String missionId;
  final String type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? note;

  const ActivityLog({
    required this.id,
    required this.arcId,
    required this.missionId,
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arcId': arcId,
      'missionId': missionId,
      'type': type,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'] ?? '',
      arcId: map['arcId'] ?? '',
      missionId: map['missionId'] ?? '',
      type: map['type'] ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      note: map['note'],
    );
  }
}

class Arc {
  final String id;
  final String title;
  final String category; // fitness, study, skills, discipline, custom, lifestyle
  final String description;
  final int durationDays;
  final ArcStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int currentDay;
  final double progress; // 0.0 to 1.0
  final String difficulty;
  final String dailyCommitment;
  final String weeklyFrequency;
  final String coverImage;
  final List<String> rules;
  final List<Mission> missions;
  final List<Milestone> milestones;

  const Arc({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.durationDays,
    this.status = ArcStatus.notStarted,
    this.startDate,
    this.endDate,
    this.currentDay = 1,
    this.progress = 0.0,
    required this.difficulty,
    required this.dailyCommitment,
    required this.weeklyFrequency,
    required this.coverImage,
    this.rules = const [],
    this.missions = const [],
    this.milestones = const [],
  });

  Arc copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    int? durationDays,
    ArcStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? currentDay,
    double? progress,
    String? difficulty,
    String? dailyCommitment,
    String? weeklyFrequency,
    String? coverImage,
    List<String>? rules,
    List<Mission>? missions,
    List<Milestone>? milestones,
  }) {
    return Arc(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      durationDays: durationDays ?? this.durationDays,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentDay: currentDay ?? this.currentDay,
      progress: progress ?? this.progress,
      difficulty: difficulty ?? this.difficulty,
      dailyCommitment: dailyCommitment ?? this.dailyCommitment,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      coverImage: coverImage ?? this.coverImage,
      rules: rules ?? this.rules,
      missions: missions ?? this.missions,
      milestones: milestones ?? this.milestones,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'durationDays': durationDays,
      'status': status.name,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'currentDay': currentDay,
      'progress': progress,
      'difficulty': difficulty,
      'dailyCommitment': dailyCommitment,
      'weeklyFrequency': weeklyFrequency,
      'coverImage': coverImage,
      'rules': rules,
      'missions': missions.map((m) => m.toMap()).toList(),
      'milestones': milestones.map((m) => m.toMap()).toList(),
    };
  }

  factory Arc.fromMap(Map<String, dynamic> map) {
    return Arc(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? 'fitness',
      description: map['description'] ?? '',
      durationDays: map['durationDays'] ?? 90,
      status: ArcStatusExtension.fromString(map['status'] ?? 'NOT STARTED'),
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      currentDay: map['currentDay'] ?? 1,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      difficulty: map['difficulty'] ?? 'Beginner',
      dailyCommitment: map['dailyCommitment'] ?? '30 min/day',
      weeklyFrequency: map['weeklyFrequency'] ?? '3 days/week',
      coverImage: map['coverImage'] ?? '',
      rules: List<String>.from(map['rules'] ?? []),
      missions: (map['missions'] as List<dynamic>?)
              ?.map((m) => Mission.fromMap(Map<String, dynamic>.from(m)))
              .toList() ??
          [],
      milestones: (map['milestones'] as List<dynamic>?)
              ?.map((m) => Milestone.fromMap(Map<String, dynamic>.from(m)))
              .toList() ??
          [],
    );
  }
}

class ArcProgress {
  final String arcId;
  final int daysCompleted;
  final int missionsCompleted;
  final int currentStreak;
  final double progressPercentage;
  final double weeklyConsistency;
  final List<int> completedDays;

  const ArcProgress({
    required this.arcId,
    required this.daysCompleted,
    required this.missionsCompleted,
    required this.currentStreak,
    required this.progressPercentage,
    required this.weeklyConsistency,
    this.completedDays = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'arcId': arcId,
      'daysCompleted': daysCompleted,
      'missionsCompleted': missionsCompleted,
      'currentStreak': currentStreak,
      'progressPercentage': progressPercentage,
      'weeklyConsistency': weeklyConsistency,
      'completedDays': completedDays,
    };
  }

  factory ArcProgress.fromMap(Map<String, dynamic> map) {
    return ArcProgress(
      arcId: map['arcId'] ?? '',
      daysCompleted: map['daysCompleted'] ?? 0,
      missionsCompleted: map['missionsCompleted'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      progressPercentage: (map['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      weeklyConsistency: (map['weeklyConsistency'] as num?)?.toDouble() ?? 0.0,
      completedDays: List<int>.from(map['completedDays'] ?? []),
    );
  }
}

class ArcTemplate {
  final String id;
  final String title;
  final String category; // FITNESS, LIFESTYLE, LEARNING, SKILLS, PERSONAL
  final String description;
  final int durationDays;
  final String difficulty;
  final String dailyCommitment;
  final String weeklyFrequency;
  final String coverImage;
  final List<String> activities;
  final List<String> outcomes;
  final List<String> rules;
  final List<Milestone> milestones;
  final List<Mission> missions;
  final bool isMarketplace;
  final String? creator;
  final String? price;
  final double? rating;

  const ArcTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.durationDays,
    required this.difficulty,
    required this.dailyCommitment,
    required this.weeklyFrequency,
    required this.coverImage,
    this.activities = const [],
    this.outcomes = const [],
    this.rules = const [],
    this.milestones = const [],
    this.missions = const [],
    this.isMarketplace = false,
    this.creator,
    this.price,
    this.rating,
  });

  Arc toArc({ArcStatus status = ArcStatus.notStarted}) {
    return Arc(
      id: id,
      title: title,
      category: category.toLowerCase(),
      description: description,
      durationDays: durationDays,
      status: status,
      difficulty: difficulty,
      dailyCommitment: dailyCommitment,
      weeklyFrequency: weeklyFrequency,
      coverImage: coverImage,
      rules: rules,
      missions: missions,
      milestones: milestones,
    );
  }
}

class ArcReflection {
  final String id;
  final String arcId;
  final String arcTitle;
  final DateTime date;
  final String whatChanged;
  final String mostProudOf;
  final String hardestPart;
  final String doDifferently;
  final String notes;

  const ArcReflection({
    required this.id,
    required this.arcId,
    required this.arcTitle,
    required this.date,
    required this.whatChanged,
    required this.mostProudOf,
    required this.hardestPart,
    required this.doDifferently,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arcId': arcId,
      'arcTitle': arcTitle,
      'date': date.toIso8601String(),
      'whatChanged': whatChanged,
      'mostProudOf': mostProudOf,
      'hardestPart': hardestPart,
      'doDifferently': doDifferently,
      'notes': notes,
    };
  }

  factory ArcReflection.fromMap(Map<String, dynamic> map) {
    return ArcReflection(
      id: map['id'] ?? '',
      arcId: map['arcId'] ?? '',
      arcTitle: map['arcTitle'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      whatChanged: map['whatChanged'] ?? '',
      mostProudOf: map['mostProudOf'] ?? '',
      hardestPart: map['hardestPart'] ?? '',
      doDifferently: map['doDifferently'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final bool unlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.unlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'unlocked': unlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      unlocked: map['unlocked'] ?? false,
      unlockedAt: map['unlockedAt'] != null ? DateTime.parse(map['unlockedAt']) : null,
    );
  }
}

class Friend {
  final String id;
  final String name;
  final String avatar;
  final String activeArcTitle;
  final int currentStreak;
  final int daysCompleted;

  const Friend({
    required this.id,
    required this.name,
    required this.avatar,
    required this.activeArcTitle,
    required this.currentStreak,
    required this.daysCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'activeArcTitle': activeArcTitle,
      'currentStreak': currentStreak,
      'daysCompleted': daysCompleted,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      activeArcTitle: map['activeArcTitle'] ?? '',
      currentStreak: map['currentStreak'] ?? 0,
      daysCompleted: map['daysCompleted'] ?? 0,
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final int durationDays;
  final String category;
  final int participantCount;
  final bool joined;
  final double progress;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.category,
    required this.participantCount,
    this.joined = false,
    this.progress = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationDays': durationDays,
      'category': category,
      'participantCount': participantCount,
      'joined': joined,
      'progress': progress,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      durationDays: map['durationDays'] ?? 30,
      category: map['category'] ?? 'FITNESS',
      participantCount: map['participantCount'] ?? 0,
      joined: map['joined'] ?? false,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class GroupArc {
  final String id;
  final String title;
  final int durationDays;
  final int memberCount;
  final double groupProgress;
  final double userCompletion;
  final List<String> members;

  const GroupArc({
    required this.id,
    required this.title,
    required this.durationDays,
    required this.memberCount,
    required this.groupProgress,
    required this.userCompletion,
    this.members = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'durationDays': durationDays,
      'memberCount': memberCount,
      'groupProgress': groupProgress,
      'userCompletion': userCompletion,
      'members': members,
    };
  }

  factory GroupArc.fromMap(Map<String, dynamic> map) {
    return GroupArc(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      durationDays: map['durationDays'] ?? 30,
      memberCount: map['memberCount'] ?? 1,
      groupProgress: (map['groupProgress'] as num?)?.toDouble() ?? 0.0,
      userCompletion: (map['userCompletion'] as num?)?.toDouble() ?? 0.0,
      members: List<String>.from(map['members'] ?? []),
    );
  }
}

class SubscriptionPlan {
  final bool isPro;
  final String planType; // "free", "monthly", "annual"
  final DateTime? expiresAt;

  const SubscriptionPlan({
    this.isPro = false,
    this.planType = 'free',
    this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'isPro': isPro,
      'planType': planType,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory SubscriptionPlan.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlan(
      isPro: map['isPro'] ?? false,
      planType: map['planType'] ?? 'free',
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
    );
  }
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String type; // "mission", "arc", "milestone", "system"

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
      type: map['type'] ?? 'system',
    );
  }
}

class AiMessage {
  final String id;
  final String role; // "user" or "coach"
  final String text;
  final DateTime timestamp;

  const AiMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AiMessage.fromMap(Map<String, dynamic> map) {
    return AiMessage(
      id: map['id'] ?? '',
      role: map['role'] ?? 'coach',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}
