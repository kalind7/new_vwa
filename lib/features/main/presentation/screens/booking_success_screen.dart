import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flow_close_header.dart';
import '../../../../shared/widgets/app_success_icon.dart';
import '../../data/booking_flow_mock_data.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Column(
            children: [
              AppFlowCloseHeader(
                onClose: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppSuccessIcon(),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(
                      'Slot has been booked succesfully',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textMdRegular.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.sm,
                  AppSpacing.xxl,
                  AppSpacing.lg,
                ),
                child: AppButton(
                  label: 'Go to my wash',
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainShell,
                    (route) => false,
                    arguments: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingInfoScreen extends StatelessWidget {
  const BookingInfoScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final total = draft.service.price.replaceFirst('Nrs ', 'Rs ');

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Column(
            children: [
              AppFlowCloseHeader(
                onClose: () => Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      const AppSuccessIcon(),
                      const SizedBox(height: AppSpacing.xxxl),
                      Text(
                        'Slot has been booked succesfully',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textMdRegular.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.gray200),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x140D121C),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Booking information',
                                style: AppTextStyles.textXlSemiBold.copyWith(
                                  color: AppColors.gray900,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              _InfoRow(
                                label: 'Station',
                                value: draft.station.name,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _InfoRow(
                                label: 'Vehicle number',
                                value: draft.vehicle?.plate ?? 'Ba-pa -1097',
                              ),
                              const Divider(height: AppSpacing.xxxl),
                              Row(
                                children: [
                                  Text(
                                    'Total',
                                    style: AppTextStyles.textMdSemiBold.copyWith(
                                      color: AppColors.gray900,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    total,
                                    style: AppTextStyles.textMdSemiBold.copyWith(
                                      color: AppColors.gray900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.sm,
                  AppSpacing.xxl,
                  AppSpacing.lg,
                ),
                child: AppButton(
                  label: 'Go to my wash',
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainShell,
                    (route) => false,
                    arguments: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.textMdRegular.copyWith(
              color: AppColors.gray600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.textMdSemiBold.copyWith(
              color: AppColors.gray900,
            ),
          ),
        ),
      ],
    );
  }
}
