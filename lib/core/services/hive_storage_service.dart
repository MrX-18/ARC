import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

class HiveStorageService {
  static final HiveStorageService _instance = HiveStorageService._internal();
  factory HiveStorageService() => _instance;
  HiveStorageService._internal();

  bool _initialized = false;
  late Box _appBox;

  static const String _boxName = 'arc_app_storage_box';

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

    try {
      await Hive.initFlutter();
      _appBox = await Hive.openBox(_boxName);

      // Automated Migration from legacy JSON file if Box is newly opened
      await _migrateLegacyJsonIfNeeded();
    } catch (e) {
      debugPrint('Hive init error: $e');
    }

    _initialized = true;
  }

  Future<void> _migrateLegacyJsonIfNeeded() async {
    if (kIsWeb) return;
    try {
      if (_appBox.isEmpty) {
        final directory = Directory.current;
        final legacyFile = File('${directory.path}/arc_storage_data.json');
        if (await legacyFile.exists()) {
          final content = await legacyFile.readAsString();
          if (content.isNotEmpty) {
            final Map<String, dynamic> data = json.decode(content);
            for (final entry in data.entries) {
              await _appBox.put(entry.key, entry.value);
            }
            debugPrint('Migrated legacy JSON data into Hive successfully.');
          }
        }
      }
    } catch (e) {
      debugPrint('Legacy JSON migration error: $e');
    }
  }

  // User Profile
  Future<void> saveUserProfile(UserProfile profile) async {
    await _appBox.put(_keyProfile, profile.toMap());
  }

  UserProfile? getUserProfile() {
    final data = _appBox.get(_keyProfile);
    if (data == null) return null;
    try {
      return UserProfile.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error parsing user profile from Hive: $e');
      return null;
    }
  }

  // Active Arc
  Future<void> saveActiveArc(Arc? arc) async {
    if (arc == null) {
      await _appBox.delete(_keyActiveArc);
    } else {
      await _appBox.put(_keyActiveArc, arc.toMap());
    }
  }

  Arc? getActiveArc() {
    final data = _appBox.get(_keyActiveArc);
    if (data == null) return null;
    try {
      return Arc.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error parsing active arc from Hive: $e');
      return null;
    }
  }

  // Enrolled Arcs
  Future<void> saveEnrolledArcs(List<Arc> arcs) async {
    await _appBox.put(_keyEnrolledArcs, arcs.map((a) => a.toMap()).toList());
  }

  List<Arc> getEnrolledArcs() {
    final list = _appBox.get(_keyEnrolledArcs);
    if (list == null || list is! List) return [];
    try {
      return list
          .map((m) => Arc.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      debugPrint('Error parsing enrolled arcs from Hive: $e');
      return [];
    }
  }

  // Daily Missions
  Future<void> saveMissions(List<Mission> missions) async {
    await _appBox.put(_keyMissions, missions.map((m) => m.toMap()).toList());
  }

  List<Mission> getMissions() {
    final list = _appBox.get(_keyMissions);
    if (list == null || list is! List) return [];
    try {
      return list
          .map((m) => Mission.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      debugPrint('Error parsing missions from Hive: $e');
      return [];
    }
  }

  // Arc Progress Map
  Future<void> saveArcProgress(ArcProgress progress) async {
    Map<String, dynamic> map = {};
    final existing = _appBox.get(_keyProgressMap);
    if (existing is Map) {
      map = Map<String, dynamic>.from(existing);
    }
    map[progress.arcId] = progress.toMap();
    await _appBox.put(_keyProgressMap, map);
  }

  ArcProgress? getArcProgress(String arcId) {
    final map = _appBox.get(_keyProgressMap);
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
    await _appBox.put(_keyActivityLogs, logs.map((l) => l.toMap()).toList());
  }

  List<ActivityLog> getActivityLogs() {
    final list = _appBox.get(_keyActivityLogs);
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
    await _appBox.put(_keyReflections, reflections.map((r) => r.toMap()).toList());
  }

  List<ArcReflection> getReflections() {
    final list = _appBox.get(_keyReflections);
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
    await _appBox.put(_keySubscription, plan.toMap());
  }

  SubscriptionPlan getSubscription() {
    final data = _appBox.get(_keySubscription);
    if (data == null) return const SubscriptionPlan();
    try {
      return SubscriptionPlan.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      return const SubscriptionPlan();
    }
  }

  // Notifications
  Future<void> saveNotifications(List<AppNotification> notifs) async {
    await _appBox.put(_keyNotifications, notifs.map((n) => n.toMap()).toList());
  }

  List<AppNotification> getNotifications() {
    final list = _appBox.get(_keyNotifications);
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
    await _appBox.put(_keyAchievements, achievements.map((a) => a.toMap()).toList());
  }

  List<Achievement> getAchievements() {
    final list = _appBox.get(_keyAchievements);
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
    await _appBox.put(_keyFriends, friends.map((f) => f.toMap()).toList());
  }

  List<Friend> getFriends() {
    final list = _appBox.get(_keyFriends);
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
    await _appBox.put(_keyChallenges, challenges.map((c) => c.toMap()).toList());
  }

  List<Challenge> getChallenges() {
    final list = _appBox.get(_keyChallenges);
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
    await _appBox.put(_keyGroupArcs, groupArcs.map((g) => g.toMap()).toList());
  }

  List<GroupArc> getGroupArcs() {
    final list = _appBox.get(_keyGroupArcs);
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
    await _appBox.put(_keyAiMessages, messages.map((m) => m.toMap()).toList());
  }

  List<AiMessage> getAiMessages() {
    final list = _appBox.get(_keyAiMessages);
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
    await _appBox.clear();
  }
}
