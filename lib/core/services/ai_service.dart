import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/models.dart';
import '../engine/arc_engine.dart';

class GeminiAiService {
  static final GeminiAiService _instance = GeminiAiService._internal();
  factory GeminiAiService() => _instance;
  GeminiAiService._internal();

  String? _customApiKey;
  GenerativeModel? _model;

  String get _apiKey {
    if (_customApiKey != null && _customApiKey!.isNotEmpty) {
      return _customApiKey!;
    }
    return const String.fromEnvironment('GEMINI_API_KEY');
  }

  void setApiKey(String key) {
    _customApiKey = key;
    _model = null;
  }

  GenerativeModel? _getModel() {
    final key = _apiKey;
    if (key.isEmpty) return null;
    _model ??= GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: key,
    );
    return _model;
  }

  /// Synthesize a structured Arc from natural language using Gemini
  Future<Arc> generateArcFromPrompt(String prompt) async {
    final model = _getModel();
    if (model == null) {
      debugPrint('Gemini API key not configured. Falling back to local ArcEngine.');
      return ArcEngine.generateFromPrompt(prompt);
    }

    try {
      final jsonPrompt = '''
You are the ARC AI Generator. Transform this user goal into a complete structured JSON transformation Arc.
User Goal: "$prompt"

Respond ONLY with valid JSON following this exact schema:
{
  "title": "ARC TITLE IN CAPITAL LETTERS",
  "category": "fitness|skills|study|discipline|lifestyle|personal",
  "description": "Concise summary of this transformation chapter.",
  "durationDays": 30 or 60 or 90,
  "difficulty": "Beginner|Intermediate|Advanced",
  "dailyCommitment": "30 min/day",
  "weeklyFrequency": "5 days/week",
  "rules": ["Rule 1", "Rule 2", "Rule 3"],
  "missions": [
    {
      "id": "m1",
      "title": "MISSION TITLE IN CAPITAL LETTERS",
      "description": "Action description",
      "type": "workout|hydration|sleep|study|reading|activity",
      "frequency": "DAILY",
      "target": 30.0,
      "unit": "MIN|L|PAGES|HOURS"
    }
  ],
  "milestones": [
    {
      "id": "ms1",
      "title": "First Week",
      "targetDay": 7
    }
  ]
}
''';

      final content = [Content.text(jsonPrompt)];
      final response = await model.generateContent(content);
      final text = response.text;

      if (text != null && text.isNotEmpty) {
        // Strip markdown code fences if present
        final cleanJson = text.replaceAll(RegExp(r'^```json\s*|^```\s*|\s*```$'), '').trim();
        final Map<String, dynamic> data = json.decode(cleanJson);

        final id = 'ai_arc_${DateTime.now().millisecondsSinceEpoch}';
        final duration = (data['durationDays'] as num?)?.toInt() ?? 60;

        final missions = (data['missions'] as List<dynamic>?)?.map((m) {
          final map = Map<String, dynamic>.from(m);
          return Mission(
            id: map['id'] ?? 'm_${DateTime.now().millisecondsSinceEpoch}',
            arcId: id,
            title: map['title'] ?? 'DAILY MISSION',
            description: map['description'] ?? '',
            type: map['type'] ?? 'study',
            frequency: map['frequency'] ?? 'DAILY',
            date: DateTime.now().toIso8601String().split('T').first,
            target: (map['target'] as num?)?.toDouble() ?? 30.0,
            unit: map['unit'] ?? 'MIN',
            category: data['category'] ?? 'skills',
          );
        }).toList() ?? [];

        final milestones = (data['milestones'] as List<dynamic>?)?.map((ms) {
          final map = Map<String, dynamic>.from(ms);
          return Milestone(
            id: map['id'] ?? 'ms_${DateTime.now().millisecondsSinceEpoch}',
            arcId: id,
            title: map['title'] ?? 'Milestone',
            targetDay: (map['targetDay'] as num?)?.toInt() ?? 7,
          );
        }).toList() ?? [];

        return Arc(
          id: id,
          title: data['title'] ?? 'CUSTOM AI ARC',
          category: (data['category'] ?? 'custom').toString().toLowerCase(),
          description: data['description'] ?? 'AI synthesized Arc.',
          durationDays: duration,
          status: ArcStatus.notStarted,
          difficulty: data['difficulty'] ?? 'Intermediate',
          dailyCommitment: data['dailyCommitment'] ?? '30 min/day',
          weeklyFrequency: data['weeklyFrequency'] ?? '5 days/week',
          coverImage: 'assets/images/card_reset.png',
          rules: List<String>.from(data['rules'] ?? []),
          missions: missions,
          milestones: milestones,
        );
      }
    } catch (e) {
      debugPrint('Gemini JSON generation error: $e. Falling back to local ArcEngine.');
    }

    return ArcEngine.generateFromPrompt(prompt);
  }

  /// Stream AI Coach responses with real-time context injection
  Stream<String> streamCoachResponse({
    required String prompt,
    required Arc? activeArc,
    required List<AiMessage> history,
  }) async* {
    final model = _getModel();
    if (model == null) {
      // Offline fallback: Yield response immediately
      final fallbackReply = ArcEngine.generateContextualResponse(prompt, activeArc);
      for (int i = 0; i < fallbackReply.length; i += 3) {
        await Future.delayed(const Duration(milliseconds: 30));
        final end = (i + 3 < fallbackReply.length) ? i + 3 : fallbackReply.length;
        yield fallbackReply.substring(0, end);
      }
      return;
    }

    try {
      final contextBuffer = StringBuffer();
      contextBuffer.writeln('You are ARC COACH, a stoic, encouraging, disciplined AI transformation mentor.');
      if (activeArc != null) {
        contextBuffer.writeln('User Active Arc: "${activeArc.title}"');
        contextBuffer.writeln('Current Progress: Day ${activeArc.currentDay} of ${activeArc.durationDays} (${(activeArc.progress * 100).round()}% complete).');
        contextBuffer.writeln('Arc Rules: ${activeArc.rules.join(', ')}');
      } else {
        contextBuffer.writeln('User has no active Arc yet.');
      }
      contextBuffer.writeln('Keep responses concise, impactful, and direct under 4 sentences.');

      final contentHistory = <Content>[];
      contentHistory.add(Content.text(contextBuffer.toString()));

      // Add recent message history (up to last 6 messages)
      final recentHistory = history.length > 6 ? history.sublist(history.length - 6) : history;
      for (final msg in recentHistory) {
        if (msg.role == 'user') {
          contentHistory.add(Content.text('User: ${msg.text}'));
        } else {
          contentHistory.add(Content.model([TextPart('Coach: ${msg.text}')]));
        }
      }

      contentHistory.add(Content.text('User: $prompt'));

      final responseStream = model.generateContentStream(contentHistory);
      final cumulativeText = StringBuffer();

      await for (final chunk in responseStream) {
        final textChunk = chunk.text;
        if (textChunk != null) {
          cumulativeText.write(textChunk);
          yield cumulativeText.toString();
        }
      }
    } catch (e) {
      debugPrint('Gemini Streaming Error: $e. Falling back to local response.');
      final fallbackReply = ArcEngine.generateContextualResponse(prompt, activeArc);
      yield fallbackReply;
    }
  }
}

extension ArcEngineContextExtension on ArcEngine {
  static String generateContextualResponse(String prompt, Arc? activeArc) {
    if (activeArc == null) {
      return "You do not have an active Arc yet. Choose an Arc from the Library or create a Custom Arc to begin your transformation.";
    }
    final lower = prompt.toLowerCase();
    final day = activeArc.currentDay;
    final total = activeArc.durationDays;

    if (lower.contains('missed') || lower.contains('behind') || lower.contains('skip')) {
      return "You are on Day $day of ${activeArc.title}. Missing a session does not break your Arc. Focus on finishing today's missions and protect your recovery tonight.";
    }
    if (lower.contains('tired') || lower.contains('rest') || lower.contains('recovery')) {
      return "Recovery is a core rule of ${activeArc.title}. Prioritize 8 hours of sleep and adequate hydration before pushing for volume.";
    }
    if (lower.contains('progress') || lower.contains('how am i doing')) {
      final pct = (activeArc.progress * 100).round();
      return "You're at $pct% of your ${activeArc.title} Arc (Day $day / $total). You've maintained steady discipline. Keep showing up.";
    }
    return "I am tracking your ${activeArc.title} progress. You are on Day $day of $total. Focus on executing today's missions with discipline.";
  }
}
