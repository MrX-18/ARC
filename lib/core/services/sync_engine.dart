import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'api_client.dart';

class SyncAction {
  final String id;
  final String actionType; // e.g. "TOGGLE_MISSION", "ACTIVATE_ARC", "LOG_ACTIVITY"
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  const SyncAction({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'actionType': actionType,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SyncAction.fromMap(Map<String, dynamic> map) {
    return SyncAction(
      id: map['id'] ?? '',
      actionType: map['actionType'] ?? '',
      payload: Map<String, dynamic>.from(map['payload'] ?? {}),
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}

class SyncEngine {
  static final SyncEngine _instance = SyncEngine._internal();
  factory SyncEngine() => _instance;
  SyncEngine._internal();

  static const String _syncBoxName = 'arc_sync_queue_box';
  late Box _syncBox;
  bool _initialized = false;
  final ApiClient _apiClient = ApiClient();

  Future<void> init() async {
    if (_initialized) return;
    try {
      await Hive.initFlutter();
      _syncBox = await Hive.openBox(_syncBoxName);
      _initialized = true;
    } catch (e) {
      debugPrint('SyncEngine init error: $e');
    }
  }

  int get pendingCount => _initialized ? _syncBox.length : 0;

  Future<void> enqueueAction(String actionType, Map<String, dynamic> payload) async {
    if (!_initialized) await init();
    final action = SyncAction(
      id: 'sync_${DateTime.now().millisecondsSinceEpoch}',
      actionType: actionType,
      payload: payload,
      timestamp: DateTime.now(),
    );
    await _syncBox.put(action.id, action.toMap());
    debugPrint('Queued offline action [${action.actionType}]. Total pending: ${pendingCount}');
  }

  Future<void> flushQueue() async {
    if (!_initialized) await init();
    if (_syncBox.isEmpty) return;

    final keys = _syncBox.keys.toList();
    for (final key in keys) {
      final raw = _syncBox.get(key);
      if (raw != null) {
        try {
          final action = SyncAction.fromMap(Map<String, dynamic>.from(raw));
          debugPrint('Flushing action [${action.actionType}] to backend server...');
          // Simulate HTTP sync request via ApiClient
          await Future.delayed(const Duration(milliseconds: 200));
          await _syncBox.delete(key);
        } catch (e) {
          debugPrint('Sync action error for $key: $e');
        }
      }
    }
  }

  Future<void> clearQueue() async {
    if (!_initialized) await init();
    await _syncBox.clear();
  }
}
