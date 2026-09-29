import 'package:flutter_test/flutter_test.dart';
import 'package:arc/core/models/models.dart';
import 'package:arc/core/services/ai_service.dart';

void main() {
  group('Phase 3 AI Service Unit Tests', () {
    test('GeminiAiService fallback generates valid Arc without API key', () async {
      final aiService = GeminiAiService();
      final arc = await aiService.generateArcFromPrompt('I want to learn Rust programming in 60 days');

      expect(arc.title.contains('RUST'), true);
      expect(arc.category, 'skills');
      expect(arc.durationDays, 60);
      expect(arc.missions.isNotEmpty, true);
    });

    test('GeminiAiService fallback streams response chunks', () async {
      final aiService = GeminiAiService();
      const activeArc = Arc(
        id: 'test_arc',
        title: 'BUILD STRENGTH',
        category: 'fitness',
        description: 'Fitness test',
        durationDays: 90,
        currentDay: 10,
        progress: 0.11,
        difficulty: 'Beginner',
        dailyCommitment: '30 min/day',
        weeklyFrequency: '3 days/week',
        coverImage: '',
      );

      final stream = aiService.streamCoachResponse(
        prompt: 'How am I doing on my progress?',
        activeArc: activeArc,
        history: [],
      );

      final chunks = <String>[];
      await for (final chunk in stream) {
        chunks.add(chunk);
      }

      expect(chunks.isNotEmpty, true);
      expect(chunks.last.contains('BUILD STRENGTH') || chunks.last.contains('11%') || chunks.last.contains('Day 10'), true);
    });
  });
}
