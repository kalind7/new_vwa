import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';

/// Dev Handoff step tracker: Booking → Washing → Finish (0–2 active index).
class WashBookingProgressCard extends StatelessWidget {
  const WashBookingProgressCard({super.key, required this.activeStep});

  /// 0 = Booking, 1 = Washing, 2 = Finish (all complete when 2).
  final int activeStep;

  static const _labels = ['Booking', 'Washing', 'Finish'];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.gray200),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            for (var i = 0; i < _labels.length; i++) ...[
              if (i > 0) const Expanded(child: _StepConnector()),
              Expanded(
                child: _StepItem(
                  label: _labels[i],
                  index: i,
                  activeStep: activeStep,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Container(height: 1, color: AppColors.gray300),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.label,
    required this.index,
    required this.activeStep,
  });

  final String label;
  final int index;
  final int activeStep;

  bool get _isComplete => index < activeStep;
  bool get _isCurrent => index == activeStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: _isCurrent ? AppColors.brand50 : AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gray500,
              width: _isComplete || _isCurrent ? 1.5 : 1,
            ),
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: _isComplete
                ? const Icon(Icons.check, size: 14, color: AppColors.gray500)
                : _isCurrent
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.gray500,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.textSmMedium.copyWith(color: AppColors.gray700),
        ),
      ],
    );
  }
}
