import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_engine.dart';

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine();
});

class SyncQueueNotifier extends StateNotifier<int> {
  final SyncEngine _engine;

  SyncQueueNotifier(this._engine) : super(_engine.pendingCount);

  Future<void> enqueue(String actionType, Map<String, dynamic> payload) async {
    await _engine.enqueueAction(actionType, payload);
    state = _engine.pendingCount;
  }

  Future<void> flush() async {
    await _engine.flushQueue();
    state = _engine.pendingCount;
  }
}

final syncQueueProvider = StateNotifierProvider<SyncQueueNotifier, int>((ref) {
  final engine = ref.watch(syncEngineProvider);
  return SyncQueueNotifier(engine);
});
