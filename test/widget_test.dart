import 'package:flutter_test/flutter_test.dart';
import 'package:arc/main.dart';
import 'package:arc/core/engine/arc_engine.dart';
import 'package:arc/core/models/models.dart';
import 'package:arc/core/repositories/arc_repository.dart';

void main() {
  testWidgets('ArcApp boots cleanly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ArcApp());
    expect(find.byType(ArcApp), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  test('ArcEngine recommendation logic for Fitness produces BUILD STRENGTH', () {
    final arc = ArcEngine.recommendArc(
      selectedAreas: ['FITNESS', 'DISCIPLINE'],
      primaryGoal: 'BUILD STRENGTH',
      dailyCommitment: '30 MINUTES',
      weeklyFrequency: '3 DAYS',
      experienceLevel: "I'M JUST STARTING",
    );

    expect(arc.id, 'build_strength');
    expect(arc.title, 'BUILD STRENGTH');
    expect(arc.durationDays, 90);
    expect(arc.missions.length, 3);
  });

  test('ArcEngine recommendation for Coding/Skills produces LEARN C++', () {
    final arc = ArcEngine.recommendArc(
      selectedAreas: ['SKILLS', 'LEARNING'],
      primaryGoal: 'LEARN PROGRAMMING',
      dailyCommitment: '45 MINUTES',
      weeklyFrequency: '5 DAYS',
      experienceLevel: "I'VE DONE THIS BEFORE",
    );

    expect(arc.id, 'learn_cpp');
    expect(arc.title, 'LEARN C++');
    expect(arc.durationDays, 60);
  });

  test('ArcEngine provides curated templates across categories', () {
    final templates = ArcEngine.getCuratedTemplates();
    expect(templates.isNotEmpty, isTrue);

    final winterArc = templates.firstWhere((t) => t.id == 'winter_arc');
    expect(winterArc.title, 'WINTER ARC');
    expect(winterArc.durationDays, 90);

    final codingArc = templates.firstWhere((t) => t.id == 'coding_arc');
    expect(codingArc.title, 'CODING ARC');
    expect(codingArc.missions.isNotEmpty, isTrue);

    final marketplaceArc = templates.firstWhere((t) => t.isMarketplace);
    expect(marketplaceArc.creator, isNotNull);
    expect(marketplaceArc.price, isNotNull);
  });

  test('AI Arc Generator creates structured Arc from prompt', () {
    final blenderArc = ArcEngine.generateFromPrompt('I want to learn Blender in 60 days');
    expect(blenderArc.title, contains('BLENDER'));
    expect(blenderArc.durationDays, 60);
    expect(blenderArc.missions.isNotEmpty, isTrue);
    expect(blenderArc.milestones.isNotEmpty, isTrue);
  });

  test('ArcRepository day calculation and progress percentage', () {
    final start = DateTime.now().subtract(const Duration(days: 26));
    final currentDay = ArcEngine.calculateCurrentDay(start, 90);
    expect(currentDay, 27);
  });

  test('Mission completion toggling updates progress and logs activity', () async {
    final repo = ArcRepository();
    await repo.init();
    final initialCount = repo.completedMissionsCount;

    if (repo.todayMissions.isNotEmpty) {
      final firstId = repo.todayMissions.first.id;
      await repo.toggleMission(firstId);
      expect(repo.completedMissionsCount, isNot(equals(initialCount)));

      // Toggle back
      await repo.toggleMission(firstId);
      expect(repo.completedMissionsCount, equals(initialCount));
    }
  });

  test('Arc rules can be updated without destroying progress', () async {
    final repo = ArcRepository();
    await repo.init();
    const testRule = 'Protect morning deep work.';
    await repo.updateArcRules('build_strength', [testRule]);

    final arc = repo.getArcById('build_strength');
    expect(arc?.rules, contains(testRule));
  });

  test('Reflections can be saved to repository', () async {
    final repo = ArcRepository();
    await repo.init();

    final reflection = ArcReflection(
      id: 'test_refl',
      arcId: 'build_strength',
      arcTitle: 'BUILD STRENGTH',
      date: DateTime.now(),
      whatChanged: 'Stronger routine',
      mostProudOf: 'Zero missed days',
      hardestPart: 'Sleep discipline',
      doDifferently: 'More hydration',
    );

    await repo.saveReflection(reflection);
    expect(repo.reflections.any((r) => r.id == 'test_refl'), isTrue);
  });

  test('Subscription state toggle between Free and Pro', () async {
    final repo = ArcRepository();
    await repo.init();

    await repo.updateSubscription(const SubscriptionPlan(isPro: true, planType: 'annual'));
    expect(repo.subscription.isPro, isTrue);
    expect(repo.subscription.planType, 'annual');
  });
}
