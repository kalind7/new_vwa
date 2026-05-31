import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';

class OtpCodeBoxes extends StatelessWidget {
  const OtpCodeBoxes({super.key, this.code = '333333'});

  final String code;

  @override
  Widget build(BuildContext context) {
    final digits = code.padRight(6).split('').take(6).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final digit in digits)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: _OtpBox(digit: digit.trim()),
            ),
          ),
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.digit});

  final String digit;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.78,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.indigo500)),
          boxShadow: [
            BoxShadow(
              color: Color(0x14233247),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.indigo500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
