import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/arc_repository.dart';
import 'arc_providers.dart';

class AiCoachNotifier extends StateNotifier<List<AiMessage>> {
  final ArcRepository _repository;

  AiCoachNotifier(this._repository) : super(_repository.aiMessages) {
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    state = _repository.aiMessages;
  }

  Future<void> sendMessage(String text) async {
    await _repository.sendAiMessage(text);
    state = _repository.aiMessages;
  }
}

final aiCoachProvider = StateNotifierProvider<AiCoachNotifier, List<AiMessage>>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  return AiCoachNotifier(repo);
});
