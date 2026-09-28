import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Map<String, dynamic> _memoryCache = {};
  bool _initialized = false;
  File? _localFile;

  static const String _keyProfile = 'arc_user_profile';
  static const String _keyActiveArc = 'arc_active_arc';
  static const String _keyEnrolledArcs = 'arc_enrolled_arcs';
  static const String _keyMissions = 'arc_daily_missions';
  static const String _keyProgressMap = 'arc_progress_map';
  static const String _keyActivityLogs = 'arc_activity_logs';
  static const String _keyReflections = 'arc_reflections';
  static const String _keySubscription = 'arc_subscription';
  static const String _keyNotifications = 'arc_notifications';
  static const String _keyAchievements = 'arc_achievements';
  static const String _keyFriends = 'arc_friends';
  static const String _keyChallenges = 'arc_challenges';
  static const String _keyGroupArcs = 'arc_group_arcs';
  static const String _keyAiMessages = 'arc_ai_messages';

  Future<void> init() async {
    if (_initialized) return;

    if (!kIsWeb) {
      try {
        final directory = Directory.current;
        _localFile = File('${directory.path}/arc_storage_data.json');
        if (await _localFile!.exists()) {
          final content = await _localFile!.readAsString();
          if (content.isNotEmpty) {
            final Map<String, dynamic> data = json.decode(content);
            _memoryCache.addAll(data);
          }
        }
      } catch (e) {
        debugPrint('Local file storage init fallback: $e');
      }
    }

    _initialized = true;
  }

  Future<void> _persist() async {
    if (kIsWeb) return;
    try {
      if (_localFile != null) {
        await _localFile!.writeAsString(json.encode(_memoryCache));
      }
    } catch (e) {
      debugPrint('Error writing storage to disk: $e');
    }
  }

  // User Profile
  Future<void> saveUserProfile(UserProfile profile) async {
    _memoryCache[_keyProfile] = profile.toMap();
    await _persist();
  }

  UserProfile? getUserProfile() {
    final data = _memoryCache[_keyProfile];
    if (data == null) return null;
    try {
      return UserProfile.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error parsing user profile: $e');
      return null;
    }
  }

  // Active Arc
  Future<void> saveActiveArc(Arc? arc) async {
    if (arc == null) {
      _memoryCache.remove(_keyActiveArc);
    } else {
      _memoryCache[_keyActiveArc] = arc.toMap();
    }
    await _persist();
  }

  Arc? getActiveArc() {
    final data = _memoryCache[_keyActiveArc];
    if (data == null) return null;
    try {
      return Arc.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error parsing active arc: $e');
      return null;
    }
  }

  // Enrolled Arcs
  Future<void> saveEnrolledArcs(List<Arc> arcs) async {
    _memoryCache[_keyEnrolledArcs] = arcs.map((a) => a.toMap()).toList();
    await _persist();
  }

  List<Arc> getEnrolledArcs() {
    final list = _memoryCache[_keyEnrolledArcs];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((m) => Arc.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      debugPrint('Error parsing enrolled arcs: $e');
      return [];
    }
  }

  // Daily Missions
  Future<void> saveMissions(List<Mission> missions) async {
    _memoryCache[_keyMissions] = missions.map((m) => m.toMap()).toList();
    await _persist();
  }

  List<Mission> getMissions() {
    final list = _memoryCache[_keyMissions];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((m) => Mission.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      debugPrint('Error parsing missions: $e');
      return [];
    }
  }

  // Arc Progress Map (Keyed strictly by arcId)
  Future<void> saveArcProgress(ArcProgress progress) async {
    Map<String, dynamic> map = {};
    if (_memoryCache[_keyProgressMap] is Map) {
      map = Map<String, dynamic>.from(_memoryCache[_keyProgressMap]);
    }
    map[progress.arcId] = progress.toMap();
    _memoryCache[_keyProgressMap] = map;
    await _persist();
  }

  ArcProgress? getArcProgress(String arcId) {
    final map = _memoryCache[_keyProgressMap];
    if (map == null || map is! Map || !map.containsKey(arcId)) return null;
    try {
      return ArcProgress.fromMap(Map<String, dynamic>.from(map[arcId]));
    } catch (e) {
      debugPrint('Error parsing arc progress for $arcId: $e');
      return null;
    }
  }

  // Activity Logs
  Future<void> saveActivityLogs(List<ActivityLog> logs) async {
    _memoryCache[_keyActivityLogs] = logs.map((l) => l.toMap()).toList();
    await _persist();
  }

  List<ActivityLog> getActivityLogs() {
    final list = _memoryCache[_keyActivityLogs];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((l) => ActivityLog.fromMap(Map<String, dynamic>.from(l)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Reflections
  Future<void> saveReflections(List<ArcReflection> reflections) async {
    _memoryCache[_keyReflections] = reflections.map((r) => r.toMap()).toList();
    await _persist();
  }

  List<ArcReflection> getReflections() {
    final list = _memoryCache[_keyReflections];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((r) => ArcReflection.fromMap(Map<String, dynamic>.from(r)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Subscription Plan
  Future<void> saveSubscription(SubscriptionPlan plan) async {
    _memoryCache[_keySubscription] = plan.toMap();
    await _persist();
  }

  SubscriptionPlan getSubscription() {
    final data = _memoryCache[_keySubscription];
    if (data == null) return const SubscriptionPlan();
    try {
      return SubscriptionPlan.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      return const SubscriptionPlan();
    }
  }

  // Notifications
  Future<void> saveNotifications(List<AppNotification> notifs) async {
    _memoryCache[_keyNotifications] = notifs.map((n) => n.toMap()).toList();
    await _persist();
  }

  List<AppNotification> getNotifications() {
    final list = _memoryCache[_keyNotifications];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((n) => AppNotification.fromMap(Map<String, dynamic>.from(n)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Achievements
  Future<void> saveAchievements(List<Achievement> achievements) async {
    _memoryCache[_keyAchievements] = achievements.map((a) => a.toMap()).toList();
    await _persist();
  }

  List<Achievement> getAchievements() {
    final list = _memoryCache[_keyAchievements];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((a) => Achievement.fromMap(Map<String, dynamic>.from(a)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Friends
  Future<void> saveFriends(List<Friend> friends) async {
    _memoryCache[_keyFriends] = friends.map((f) => f.toMap()).toList();
    await _persist();
  }

  List<Friend> getFriends() {
    final list = _memoryCache[_keyFriends];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((f) => Friend.fromMap(Map<String, dynamic>.from(f)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Challenges
  Future<void> saveChallenges(List<Challenge> challenges) async {
    _memoryCache[_keyChallenges] = challenges.map((c) => c.toMap()).toList();
    await _persist();
  }

  List<Challenge> getChallenges() {
    final list = _memoryCache[_keyChallenges];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((c) => Challenge.fromMap(Map<String, dynamic>.from(c)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Group Arcs
  Future<void> saveGroupArcs(List<GroupArc> groupArcs) async {
    _memoryCache[_keyGroupArcs] = groupArcs.map((g) => g.toMap()).toList();
    await _persist();
  }

  List<GroupArc> getGroupArcs() {
    final list = _memoryCache[_keyGroupArcs];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((g) => GroupArc.fromMap(Map<String, dynamic>.from(g)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // AI Messages
  Future<void> saveAiMessages(List<AiMessage> messages) async {
    _memoryCache[_keyAiMessages] = messages.map((m) => m.toMap()).toList();
    await _persist();
  }

  List<AiMessage> getAiMessages() {
    final list = _memoryCache[_keyAiMessages];
    if (list == null || list is! List) return [];
    try {
      return list
          .map((m) => AiMessage.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearAll() async {
    _memoryCache.clear();
    await _persist();
  }
}
