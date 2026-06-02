import 'package:flutter/material.dart';

import '../../../../config/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_handoff_bottom_sheet.dart';
import '../../data/booking_flow_mock_data.dart';
import 'wash_booking_summary_card.dart';

Future<bool?> showBookingSummaryBottomSheet({
  required BuildContext context,
  required BookingDraft draft,
}) {
  return showAppHandoffBottomSheet<bool>(
    context: context,
    title: 'Booking summary',
    child: _BookingSummarySheetContent(draft: draft),
  );
}

class _BookingSummarySheetContent extends StatelessWidget {
  const _BookingSummarySheetContent({required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final vehicle = draft.vehicle?.plate ?? '—';
    final total = checkoutTotalLabel(draft);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WashBookingSummaryCard(
          title: 'Your Booking information',
          stationName: draft.station.name,
          vehicleNumber: vehicle,
          total: total,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Confirm booking',
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
