import 'package:flutter_test/flutter_test.dart';
import 'package:arc/core/models/auth_models.dart';
import 'package:arc/core/services/sync_engine.dart';

void main() {
  group('Phase 2 Auth & Sync Unit Tests', () {
    test('AuthUser createGuest generates valid guest model', () {
      final guest = AuthUser.createGuest();

      expect(guest.isGuest, true);
      expect(guest.email, 'guest@arc.app');
      expect(guest.displayName, 'Guest Warrior');
      expect(guest.id.startsWith('guest_'), true);
    });

    test('AuthUser serialization & deserialization', () {
      final user = AuthUser(
        id: 'usr_100',
        email: 'test@arc.app',
        displayName: 'Alex',
        token: 'sample_token_xyz',
        isGuest: false,
        createdAt: DateTime.now(),
      );

      final map = user.toMap();
      final restored = AuthUser.fromMap(map);

      expect(restored.id, 'usr_100');
      expect(restored.email, 'test@arc.app');
      expect(restored.displayName, 'Alex');
      expect(restored.token, 'sample_token_xyz');
      expect(restored.isGuest, false);
    });

    test('SyncAction serialization', () {
      final action = SyncAction(
        id: 'sync_1',
        actionType: 'TOGGLE_MISSION',
        payload: {'missionId': 'm101', 'completed': true},
        timestamp: DateTime.now(),
      );

      final map = action.toMap();
      final restored = SyncAction.fromMap(map);

      expect(restored.id, 'sync_1');
      expect(restored.actionType, 'TOGGLE_MISSION');
      expect(restored.payload['missionId'], 'm101');
      expect(restored.payload['completed'], true);
    });
  });
}
