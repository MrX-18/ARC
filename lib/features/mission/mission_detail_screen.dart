import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';

class MissionDetailScreen extends StatefulWidget {
  final Mission mission;

  const MissionDetailScreen({super.key, required this.mission});

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  final ArcRepository _arcRepo = ArcRepository();
  late Mission _mission;
  bool _isCompleted = false;
  double _loggedValue = 0;
  final TextEditingController _noteController = TextEditingController();

  // Timer state for timed missions
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _mission = widget.mission;
    _isCompleted = _mission.completed;
    _loggedValue = _mission.target ?? 1.0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isTimerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isTimerRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _secondsElapsed = 0;
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleCompleteMission() async {
    await _arcRepo.toggleMission(_mission.id);

    // Also record activity log with custom value if provided
    final log = ActivityLog(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      arcId: _mission.arcId,
      missionId: _mission.id,
      type: _mission.type,
      value: _loggedValue,
      unit: _mission.unit ?? 'COUNT',
      timestamp: DateTime.now(),
      note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
    );
    await _arcRepo.logActivity(log);

    setState(() {
      _isCompleted = !_isCompleted;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceElevated,
          content: Text(
            _isCompleted ? '✓ MISSION COMPLETE' : 'Mission marked incomplete',
            style: AppTypography.labelUppercaseGold,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTimed = _mission.type == 'workout' ||
        _mission.type == 'study' ||
        (_mission.unit?.toUpperCase().contains('MIN') == true);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'MISSION DETAIL',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderGold),
                ),
                child: Text(
                  _mission.type.toUpperCase(),
                  style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                _mission.title,
                style: AppTypography.titleLarge.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                _mission.description,
                style: AppTypography.subtitle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 28),

              // Target & Frequency Cards
              Row(
                children: [
                  Expanded(
                    child: ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TARGET',
                            style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _mission.target != null
                                ? '${_mission.target!.toInt()} ${_mission.unit ?? ''}'
                                : '1 SESSION',
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.goldLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ArcCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FREQUENCY',
                            style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _mission.frequency,
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Interactive Action Layer based on Mission Type
              if (isTimed) ...[
                // Activity Timer
                ArcCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Text(
                        'ACTIVITY TIMER',
                        style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _formatTimer(_secondsElapsed),
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 48,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isTimerRunning)
                            IconButton(
                              onPressed: _startTimer,
                              iconSize: 42,
                              color: AppColors.gold,
                              icon: const Icon(Icons.play_circle_filled_rounded),
                            )
                          else
                            IconButton(
                              onPressed: _pauseTimer,
                              iconSize: 42,
                              color: AppColors.gold,
                              icon: const Icon(Icons.pause_circle_filled_rounded),
                            ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: _resetTimer,
                            iconSize: 28,
                            color: AppColors.textTertiary,
                            icon: const Icon(Icons.replay_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                // Quantity Logger (Water, reading pages, etc.)
                ArcCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOG AMOUNT',
                        style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_loggedValue > 0.5) {
                                setState(() => _loggedValue -= (_mission.unit == 'L' ? 0.25 : 1.0));
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.gold, size: 28),
                          ),
                          Text(
                            _mission.unit == 'L'
                                ? '${_loggedValue.toStringAsFixed(1)} ${_mission.unit}'
                                : '${_loggedValue.toInt()} ${_mission.unit ?? ''}',
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => _loggedValue += (_mission.unit == 'L' ? 0.25 : 1.0));
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.gold, size: 28),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Notes / Reflection (Optional)
              ArcCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY NOTE (OPTIONAL)',
                      style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Record training weight, thoughts, or reflections...',
                        hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 11),
                        border: InputBorder.none,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Primary Action: COMPLETE MISSION / ✓ MISSION COMPLETE
              ArcButton(
                label: _isCompleted ? '✓ MISSION COMPLETE' : 'COMPLETE MISSION',
                isOutlined: _isCompleted,
                onPressed: _handleCompleteMission,
              ),
              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Consistency beats intensity. No penalties for missed sessions.',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
