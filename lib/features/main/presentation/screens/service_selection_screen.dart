import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../data/booking_flow_mock_data.dart';
import '../providers/booking_flow_provider.dart';
import '../widgets/booking_flow_scaffold.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key, required this.args});

  final StationBookingArgs args;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          BookingFlowProvider(station: args.station, vehicle: args.vehicle),
      child: Consumer<BookingFlowProvider>(
        builder: (context, provider, _) {
          return BookingFlowScaffold(
            title: 'Select Service',
            bottomBar: AppButton(
              label: 'Continue',
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.slotSelection, arguments: provider.draft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final service in washServices) ...[
                  _ServiceOption(
                    service: service,
                    isSelected: provider.selectedService.id == service.id,
                    onTap: () => provider.selectService(service),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ServiceOption extends StatelessWidget {
  const _ServiceOption({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  final WashServiceMock service;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand25 : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.gray500 : AppColors.gray200,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              AppSvgIcon(
                AppSvgIconName.wash,
                color: isSelected ? AppColors.brand500 : AppColors.gray500,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: AppTextStyles.textMdSemiBold.copyWith(
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      service.subtitle,
                      style: AppTextStyles.textSmRegular.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      service.duration,
                      style: AppTextStyles.textXsMedium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                service.price,
                style: AppTextStyles.textSmMedium.copyWith(
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
