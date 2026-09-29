import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/arc_repository.dart';

final arcRepositoryProvider = Provider<ArcRepository>((ref) {
  return ArcRepository();
});

/// Active Arc State Notifier
class ActiveArcNotifier extends StateNotifier<Arc?> {
  final ArcRepository _repository;

  ActiveArcNotifier(this._repository) : super(_repository.activeArc) {
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    state = _repository.activeArc;
  }

  Future<bool> activateArc(Arc arc) async {
    final success = await _repository.activateArc(arc);
    if (success) {
      state = _repository.activeArc;
    }
    return success;
  }

  Future<void> completeArc() async {
    await _repository.completeActiveArc();
    state = null;
  }
}

final activeArcProvider = StateNotifierProvider<ActiveArcNotifier, Arc?>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  return ActiveArcNotifier(repo);
});

/// Enrolled Arcs List Provider
class EnrolledArcsNotifier extends StateNotifier<List<Arc>> {
  final ArcRepository _repository;

  EnrolledArcsNotifier(this._repository) : super(_repository.enrolledArcs) {
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    state = _repository.enrolledArcs;
  }
}

final enrolledArcsProvider = StateNotifierProvider<EnrolledArcsNotifier, List<Arc>>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  return EnrolledArcsNotifier(repo);
});

/// Daily Missions Provider
class DailyMissionsNotifier extends StateNotifier<List<Mission>> {
  final ArcRepository _repository;

  DailyMissionsNotifier(this._repository) : super(_repository.todayMissions) {
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    state = _repository.todayMissions;
  }

  Future<void> toggleMission(String missionId) async {
    await _repository.toggleMission(missionId);
    state = _repository.todayMissions;
  }
}

final dailyMissionsProvider = StateNotifierProvider<DailyMissionsNotifier, List<Mission>>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  return DailyMissionsNotifier(repo);
});

/// Today's Mission Progress Percentage (0.0 to 1.0)
final todayProgressPercentageProvider = Provider<double>((ref) {
  final missions = ref.watch(dailyMissionsProvider);
  if (missions.isEmpty) return 0.0;
  final completed = missions.where((m) => m.completed).length;
  return completed / missions.length;
});

/// Arc Specific Progress Family Provider
final arcProgressProvider = Provider.family<ArcProgress, String>((ref, arcId) {
  final repo = ref.watch(arcRepositoryProvider);
  return repo.getArcProgress(arcId);
});
