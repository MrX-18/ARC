import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/arc_repository.dart';
import '../services/ai_service.dart';
import 'arc_providers.dart';
import 'ai_service_provider.dart';

class AiCoachNotifier extends StateNotifier<List<AiMessage>> {
  final ArcRepository _repository;
  final GeminiAiService _aiService;

  AiCoachNotifier(this._repository, this._aiService) : super(_repository.aiMessages) {
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    state = _repository.aiMessages;
  }

  Future<void> sendStreamingMessage(String userText, Arc? activeArc) async {
    final userMsg = AiMessage(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      text: userText,
      timestamp: DateTime.now(),
    );

    final coachMsgId = 'coach_${DateTime.now().millisecondsSinceEpoch}';
    final placeholderCoachMsg = AiMessage(
      id: coachMsgId,
      role: 'coach',
      text: 'Thinking...',
      timestamp: DateTime.now().add(const Duration(milliseconds: 100)),
    );

    // Update state locally
    state = [...state, userMsg, placeholderCoachMsg];

    final stream = _aiService.streamCoachResponse(
      prompt: userText,
      activeArc: activeArc,
      history: state,
    );

    await for (final chunk in stream) {
      final updatedList = List<AiMessage>.from(state);
      final idx = updatedList.indexWhere((m) => m.id == coachMsgId);
      if (idx != -1) {
        updatedList[idx] = AiMessage(
          id: coachMsgId,
          role: 'coach',
          text: chunk,
          timestamp: updatedList[idx].timestamp,
        );
        state = updatedList;
      }
    }

    // Persist final conversation to storage
    await _repository.saveAiMessages(state);
  }
}

final aiCoachProvider = StateNotifierProvider<AiCoachNotifier, List<AiMessage>>((ref) {
  final repo = ref.watch(arcRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);
  return AiCoachNotifier(repo, aiService);
});
