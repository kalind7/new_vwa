import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../booking/domain/booking_flow_helpers.dart';
import '../../data/booking_flow_mock_data.dart';
import '../providers/booking_flow_provider.dart';
import '../widgets/booking_flow_scaffold.dart';

class SlotSelectionScreen extends StatelessWidget {
  const SlotSelectionScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingFlowProvider(
        station: draft.station,
        vehicle: draft.vehicle,
        initialService: draft.service,
        initialSlot: draft.slot,
      ),
      child: Consumer<BookingFlowProvider>(
        builder: (context, provider, _) {
          final slots = slotsFromStation(draft.station);
          return BookingFlowScaffold(
            title: 'Select Slot',
            bottomBar: AppButton(
              label: 'Review booking',
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.bookingSummary, arguments: provider.draft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SelectedServiceCard(service: provider.selectedService),
                const SizedBox(height: AppSpacing.xxl),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: slots.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.34,
                  ),
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return _SlotCard(
                      slot: slot,
                      isSelected: provider.selectedSlot.id == slot.id,
                      onTap: () => provider.selectSlot(slot),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SelectedServiceCard extends StatelessWidget {
  const _SelectedServiceCard({required this.service});

  final WashServiceMock service;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray900,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            const AppSvgIcon(AppSvgIconName.wash, color: AppColors.white),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                service.title,
                style: AppTextStyles.textMdSemiBold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            Text(
              service.price,
              style: AppTextStyles.textSmMedium.copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  final WashSlotMock slot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand500 : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.brand500 : AppColors.gray200,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvgIcon(
                AppSvgIconName.calendar,
                color: isSelected ? AppColors.white : AppColors.gray500,
              ),
              const Spacer(),
              Text(
                slot.dateLabel,
                style: AppTextStyles.textMdSemiBold.copyWith(
                  color: isSelected ? AppColors.white : AppColors.gray900,
                ),
              ),
              Text(
                '${slot.dayLabel} • ${slot.timeLabel}',
                style: AppTextStyles.textXsMedium.copyWith(
                  color: isSelected ? AppColors.white : AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
