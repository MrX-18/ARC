import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/arc_button.dart';
import '../../shared/widgets/arc_card.dart';

class BodyProgressScreen extends StatefulWidget {
  const BodyProgressScreen({super.key});

  @override
  State<BodyProgressScreen> createState() => _BodyProgressScreenState();
}

class _BodyProgressScreenState extends State<BodyProgressScreen> {
  final TextEditingController _weightController = TextEditingController(text: '76.4');
  final TextEditingController _chestController = TextEditingController(text: '102');
  final TextEditingController _waistController = TextEditingController(text: '82');
  final TextEditingController _armsController = TextEditingController(text: '37');

  void _saveMeasurements() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.surfaceElevated,
        content: Text('✓ Measurements updated privately', style: TextStyle(color: AppColors.gold)),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _armsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'BODY & TRANSFORMATION',
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
              Text(
                'OPTIONAL & PRIVATE',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 11, letterSpacing: 2.0),
              ),
              const SizedBox(height: 6),
              Text(
                'PHYSICAL TRANSFORMATION',
                style: AppTypography.titleLarge.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Your data is encrypted locally. Measure at your own pace without pressure.',
                style: AppTypography.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Visual: Before / Current Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('DAY 01 (BEFORE)', style: AppTypography.labelUppercase.copyWith(fontSize: 9)),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo_outlined, color: AppColors.textTertiary, size: 36),
                              SizedBox(height: 8),
                              Text('Private photo', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderGold),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('CURRENT', style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9)),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo_outlined, color: AppColors.gold, size: 36),
                              SizedBox(height: 8),
                              Text('Add check-in photo', style: TextStyle(color: AppColors.goldLight, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Measurements Grid
              Text(
                'MEASUREMENTS (OPTIONAL)',
                style: AppTypography.labelUppercaseGold.copyWith(fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _buildMetricField('WEIGHT (KG)', _weightController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMetricField('CHEST (CM)', _chestController)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildMetricField('WAIST (CM)', _waistController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMetricField('ARMS (CM)', _armsController)),
                ],
              ),
              const SizedBox(height: 24),

              ArcButton(
                label: 'UPDATE MEASUREMENTS',
                onPressed: _saveMeasurements,
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricField(String label, TextEditingController controller) {
    return ArcCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: AppTypography.titleSmall.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
