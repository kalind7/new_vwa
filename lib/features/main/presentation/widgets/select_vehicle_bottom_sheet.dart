import 'package:flutter/material.dart';

import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../data/booking_flow_mock_data.dart';

Future<VehicleMock?> showSelectVehicleBottomSheet({
  required BuildContext context,
  VehicleMock? selectedVehicle,
}) {
  return showModalBottomSheet<VehicleMock>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _SelectVehicleBottomSheet(initialVehicle: selectedVehicle);
    },
  );
}

class _SelectVehicleBottomSheet extends StatefulWidget {
  const _SelectVehicleBottomSheet({this.initialVehicle});

  final VehicleMock? initialVehicle;

  @override
  State<_SelectVehicleBottomSheet> createState() =>
      _SelectVehicleBottomSheetState();
}

class _SelectVehicleBottomSheetState extends State<_SelectVehicleBottomSheet> {
  late VehicleMock _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = widget.initialVehicle ?? vehicles[2];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppBreakpoints.horizontalPadding(width),
              0,
              AppBreakpoints.horizontalPadding(width),
              AppSpacing.lg + bottomInset,
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select vehicle',
                      style: AppTextStyles.textXlSemiBold.copyWith(
                        color: AppColors.gray950,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    for (final vehicle in vehicles) ...[
                      _VehicleOptionTile(
                        vehicle: vehicle,
                        isSelected: _selectedVehicle.id == vehicle.id,
                        onTap: () {
                          setState(() => _selectedVehicle = vehicle);
                          Navigator.of(context).pop(vehicle);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleOptionTile extends StatelessWidget {
  const _VehicleOptionTile({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  final VehicleMock vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand25 : AppColors.gray25,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.gray500 : AppColors.gray200,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  vehicle.plate,
                  style: AppTextStyles.textMdMedium.copyWith(
                    color: isSelected ? AppColors.gray700 : AppColors.gray600,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.gray500 : AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected ? AppColors.gray500 : AppColors.gray300,
                  ),
                ),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.white,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
