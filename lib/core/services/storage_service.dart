import 'hive_storage_service.dart';
import '../models/models.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final HiveStorageService _hive = HiveStorageService();

  Future<void> init() async {
    await _hive.init();
  }

  // User Profile
  Future<void> saveUserProfile(UserProfile profile) async {
    await _hive.saveUserProfile(profile);
  }

  UserProfile? getUserProfile() {
    return _hive.getUserProfile();
  }

  // Active Arc
  Future<void> saveActiveArc(Arc? arc) async {
    await _hive.saveActiveArc(arc);
  }

  Arc? getActiveArc() {
    return _hive.getActiveArc();
  }

  // Enrolled Arcs
  Future<void> saveEnrolledArcs(List<Arc> arcs) async {
    await _hive.saveEnrolledArcs(arcs);
  }

  List<Arc> getEnrolledArcs() {
    return _hive.getEnrolledArcs();
  }

  // Daily Missions
  Future<void> saveMissions(List<Mission> missions) async {
    await _hive.saveMissions(missions);
  }

  List<Mission> getMissions() {
    return _hive.getMissions();
  }

  // Arc Progress Map
  Future<void> saveArcProgress(ArcProgress progress) async {
    await _hive.saveArcProgress(progress);
  }

  ArcProgress? getArcProgress(String arcId) {
    return _hive.getArcProgress(arcId);
  }

  // Activity Logs
  Future<void> saveActivityLogs(List<ActivityLog> logs) async {
    await _hive.saveActivityLogs(logs);
  }

  List<ActivityLog> getActivityLogs() {
    return _hive.getActivityLogs();
  }

  // Reflections
  Future<void> saveReflections(List<ArcReflection> reflections) async {
    await _hive.saveReflections(reflections);
  }

  List<ArcReflection> getReflections() {
    return _hive.getReflections();
  }

  // Subscription Plan
  Future<void> saveSubscription(SubscriptionPlan plan) async {
    await _hive.saveSubscription(plan);
  }

  SubscriptionPlan getSubscription() {
    return _hive.getSubscription();
  }

  // Notifications
  Future<void> saveNotifications(List<AppNotification> notifs) async {
    await _hive.saveNotifications(notifs);
  }

  List<AppNotification> getNotifications() {
    return _hive.getNotifications();
  }

  // Achievements
  Future<void> saveAchievements(List<Achievement> achievements) async {
    await _hive.saveAchievements(achievements);
  }

  List<Achievement> getAchievements() {
    return _hive.getAchievements();
  }

  // Friends
  Future<void> saveFriends(List<Friend> friends) async {
    await _hive.saveFriends(friends);
  }

  List<Friend> getFriends() {
    return _hive.getFriends();
  }

  // Challenges
  Future<void> saveChallenges(List<Challenge> challenges) async {
    await _hive.saveChallenges(challenges);
  }

  List<Challenge> getChallenges() {
    return _hive.getChallenges();
  }

  // Group Arcs
  Future<void> saveGroupArcs(List<GroupArc> groupArcs) async {
    await _hive.saveGroupArcs(groupArcs);
  }

  List<GroupArc> getGroupArcs() {
    return _hive.getGroupArcs();
  }

  // AI Messages
  Future<void> saveAiMessages(List<AiMessage> messages) async {
    await _hive.saveAiMessages(messages);
  }

  List<AiMessage> getAiMessages() {
    return _hive.getAiMessages();
  }

  Future<void> clearAll() async {
    await _hive.clearAll();
  }
}
