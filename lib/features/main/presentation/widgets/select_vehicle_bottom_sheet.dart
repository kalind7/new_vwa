import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_handoff_bottom_sheet.dart';
import '../../../../shared/widgets/shimmers/app_shimmer.dart';
import '../../../profile/domain/repositories/user_repository.dart';
import '../../data/booking_flow_mock_data.dart';

Future<VehicleMock?> showSelectVehicleBottomSheet({
  required BuildContext context,
  VehicleMock? selectedVehicle,
}) {
  return showAppHandoffBottomSheet<VehicleMock>(
    context: context,
    title: 'Select vehicle',
    child: _SelectVehicleSheetContent(initialVehicle: selectedVehicle),
  );
}

class _SelectVehicleSheetContent extends StatefulWidget {
  const _SelectVehicleSheetContent({this.initialVehicle});

  final VehicleMock? initialVehicle;

  @override
  State<_SelectVehicleSheetContent> createState() =>
      _SelectVehicleSheetContentState();
}

class _SelectVehicleSheetContentState
    extends State<_SelectVehicleSheetContent> {
  List<VehicleMock> _vehicles = const [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final repository = context.read<UserRepository>();
    final result = await repository.fetchVehicles();

    if (!mounted) {
      return;
    }

    result.fold((_) => _vehicles = const [], (loaded) => _vehicles = loaded);

    setState(() => _isLoading = false);
  }

  void _openAddVehicle() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(AppRoutes.addVehicle);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: AppShimmerBox(
              width: double.infinity,
              height: 56,
              borderRadius: AppRadius.md,
            ),
          ),
        ),
      );
    }

    if (_vehicles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.directions_bike_outlined, size: 48, color: AppColors.gray400),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No vehicles added yet.\nAdd a vehicle number to book a wash slot.',
              textAlign: TextAlign.center,
              style: AppTextStyles.textMdRegular.copyWith(
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: 'Add vehicle number',
              onPressed: _openAddVehicle,
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final vehicle in _vehicles) ...[
          _VehicleOptionTile(
            vehicle: vehicle,
            isSelected: widget.initialVehicle?.id == vehicle.id,
            onTap: () => Navigator.of(context).pop(vehicle),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
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
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.brand500 : AppColors.gray300,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brand500
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(width: 10, height: 10),
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
