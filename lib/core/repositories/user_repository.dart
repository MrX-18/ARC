import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class UserRepository extends ChangeNotifier {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final StorageService _storage = StorageService();

  UserProfile _user = const UserProfile(
    id: 'usr_1',
    name: 'Gorank',
    selectedAreas: [],
    onboardingCompleted: false,
  );

  UserProfile get user => _user;
  bool get isOnboardingCompleted => _user.onboardingCompleted;

  Future<void> init() async {
    await _storage.init();
    final loaded = _storage.getUserProfile();
    if (loaded != null) {
      _user = loaded;
    }
    notifyListeners();
  }

  Future<void> setSelectedAreas(List<String> areas) async {
    _user = _user.copyWith(selectedAreas: areas);
    await _storage.saveUserProfile(_user);
    notifyListeners();
  }

  Future<void> setPrimaryGoal(String goal) async {
    _user = _user.copyWith(primaryGoal: goal);
    await _storage.saveUserProfile(_user);
    notifyListeners();
  }

  Future<void> setRoutine({
    required String dailyCommitment,
    required String weeklyFrequency,
    required String experienceLevel,
  }) async {
    _user = _user.copyWith(
      dailyCommitment: dailyCommitment,
      weeklyFrequency: weeklyFrequency,
      experienceLevel: experienceLevel,
    );
    await _storage.saveUserProfile(_user);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _user = _user.copyWith(onboardingCompleted: true);
    await _storage.saveUserProfile(_user);
    notifyListeners();
  }

  Future<void> resetData() async {
    _user = const UserProfile(
      id: 'usr_1',
      name: 'Gorank',
      selectedAreas: [],
      onboardingCompleted: false,
    );
    await _storage.clearAll();
    notifyListeners();
  }
}
