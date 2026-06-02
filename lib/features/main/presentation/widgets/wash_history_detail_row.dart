import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_text_styles.dart';

/// Label / value row for Dev Handoff wash history cards.
class WashHistoryDetailRow extends StatelessWidget {
  const WashHistoryDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.textSmRegular.copyWith(
              color: AppColors.handoffLabelMuted,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.textSmMedium.copyWith(
              color: AppColors.gray900,
            ),
          ),
        ),
      ],
    );
  }
}
