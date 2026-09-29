import 'package:flutter_test/flutter_test.dart';
import 'package:arc/core/models/models.dart';
import 'package:arc/core/engine/arc_engine.dart';

void main() {
  group('Arc Engine & Models Unit Tests', () {
    test('ArcEngine recommends Build Strength by default', () {
      final arc = ArcEngine.recommendArc(
        selectedAreas: ['FITNESS'],
        primaryGoal: 'Build muscle',
        dailyCommitment: '30 MINUTES',
        weeklyFrequency: '3 DAYS',
        experienceLevel: 'Beginner',
      );

      expect(arc.title, 'BUILD STRENGTH');
      expect(arc.category, 'fitness');
      expect(arc.missions.isNotEmpty, true);
    });

    test('Arc progress percentage updates correctly', () {
      const arc = Arc(
        id: 'test_arc',
        title: 'TEST ARC',
        category: 'fitness',
        description: 'Test description',
        durationDays: 30,
        currentDay: 15,
        progress: 0.5,
        difficulty: 'Beginner',
        dailyCommitment: '30 min/day',
        weeklyFrequency: '3 days/week',
        coverImage: '',
      );

      expect(arc.progress, 0.5);
      final updated = arc.copyWith(currentDay: 30, progress: 1.0);
      expect(updated.progress, 1.0);
    });

    test('Mission completion toggling', () {
      const mission = Mission(
        id: 'm1',
        arcId: 'test_arc',
        title: 'Drink 2L Water',
        description: 'Hydration target',
        type: 'hydration',
        frequency: 'DAILY',
        date: '2026-09-29',
        completed: false,
      );

      expect(mission.completed, false);
      final completedMission = mission.copyWith(completed: true);
      expect(completedMission.completed, true);
    });
  });
}
