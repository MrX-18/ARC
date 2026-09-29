import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/arc_repository.dart';
import 'arc_providers.dart';

class CommunityNotifier extends StateNotifier<List<Challenge>> {
  final ArcRepository _repository;

  CommunityNotifier(this._repository) : super(_repository.challenges) {
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    state = _repository.challenges;
  }

  Future<void> toggleChallenge(String challengeId) async {
    await _repository.toggleChallenge(challengeId);
    state = _repository.challenges;
  }
}

final challengesProvider = StateNotifierProvider<CommunityNotifier, List<Challenge>>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  return CommunityNotifier(repo);
});

final friendsProvider = Provider<List<Friend>>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  return repo.friends;
});

final groupArcsProvider = Provider<List<GroupArc>>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  return repo.groupArcs;
});
