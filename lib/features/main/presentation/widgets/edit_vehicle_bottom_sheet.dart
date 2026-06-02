import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_handoff_bottom_sheet.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/booking_flow_mock_data.dart';

Future<String?> showEditVehicleBottomSheet({
  required BuildContext context,
  required VehicleMock vehicle,
}) {
  return showAppHandoffBottomSheet<String>(
    context: context,
    title: 'Edit vehicle',
    child: _EditVehicleSheetContent(vehicle: vehicle),
  );
}

class _EditVehicleSheetContent extends StatefulWidget {
  const _EditVehicleSheetContent({required this.vehicle});

  final VehicleMock vehicle;

  @override
  State<_EditVehicleSheetContent> createState() =>
      _EditVehicleSheetContentState();
}

class _EditVehicleSheetContentState extends State<_EditVehicleSheetContent> {
  late final TextEditingController _plateController;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.vehicle.plate);
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  void _save() {
    final plate = _plateController.text.trim();
    if (plate.isEmpty) {
      return;
    }
    Navigator.of(context).pop(plate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Update your registered plate number.',
          style: AppTextStyles.textSmRegular.copyWith(color: AppColors.gray600),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Vehicle number',
          hintText: 'Ba-pa 1097',
          controller: _plateController,
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton(label: 'Save vehicle', onPressed: _save),
      ],
    );
  }
}
