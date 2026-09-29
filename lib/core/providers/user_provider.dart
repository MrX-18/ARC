import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final StorageService _storage;

  UserProfileNotifier(this._storage) : super(_storage.getUserProfile());

  Future<void> saveProfile(UserProfile profile) async {
    await _storage.saveUserProfile(profile);
    state = profile;
  }

  Future<void> updateGoal(String goal) async {
    if (state != null) {
      final updated = state!.copyWith(primaryGoal: goal);
      await saveProfile(updated);
    }
  }

  Future<void> completeOnboarding() async {
    if (state != null) {
      final updated = state!.copyWith(onboardingCompleted: true);
      await saveProfile(updated);
    }
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return UserProfileNotifier(storage);
});
