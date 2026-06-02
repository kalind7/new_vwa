import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_config.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_screen.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../profile/domain/repositories/user_repository.dart';
import '../utils/auth_form_validators.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _vehicleNumberControllers = [
    TextEditingController(),
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final controller in _vehicleNumberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addVehicleField() {
    setState(() {
      _vehicleNumberControllers.add(TextEditingController());
    });
  }

  void _removeVehicleField(int index) {
    if (_vehicleNumberControllers.length == 1) {
      _vehicleNumberControllers.first.clear();
      return;
    }

    final controller = _vehicleNumberControllers.removeAt(index);
    controller.dispose();
    setState(() {});
  }

  void _showUploadUnavailableMessage() {
    FocusScope.of(context).unfocus();
    AppToast.showNeutral(
      context,
      'Profile photo upload is not available on the server yet.',
    );
  }

  List<String> _collectVehicleNumbers() {
    return _vehicleNumberControllers
        .map((controller) => controller.text.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  bool _validateNepaliPlates(List<String> plates) {
    for (final plate in plates) {
      if (!AuthFormValidators.isValidNepaliPlate(plate)) {
        AppToast.showError(
          context,
          'Invalid plate "$plate". Use format like Ba Pa 2446.',
        );
        return false;
      }
      if (plate.length > 20) {
        AppToast.showError(
          context,
          'Plate "$plate" must be 20 characters or less.',
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false) || _isSubmitting) {
      return;
    }

    final plates = _collectVehicleNumbers();
    if (plates.isEmpty) {
      AppToast.showError(context, 'Add at least one vehicle number.');
      return;
    }

    if (!_validateNepaliPlates(plates)) {
      return;
    }

    setState(() => _isSubmitting = true);

    if (AppConfig.useMockData) {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      AppToast.showSuccess(
        context,
        'Mock saved ${plates.length} vehicle number(s).',
      );
      _goToMainShell();
      return;
    }

    final result = await context.read<UserRepository>().addVehicles(plates);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() => _isSubmitting = false);
        AppToast.showError(context, failure.message);
      },
      (_) {
        setState(() => _isSubmitting = false);
        AppToast.showSuccess(
          context,
          plates.length == 1
              ? 'Vehicle added successfully.'
              : '${plates.length} vehicles added successfully.',
        );
        _goToMainShell();
      },
    );
  }

  void _goToMainShell() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppScreen(
          backgroundColor: AppColors.white,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxl,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Setup your profile',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.gray800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Upload your picture and vehicle numbers',
                            style: AppTextStyles.textSmRegular.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxxl),
                          Center(
                            child: Column(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.gray100,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 4,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x1F101828),
                                        blurRadius: 16,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const SizedBox(
                                    width: 96,
                                    height: 96,
                                    child: Icon(
                                      Icons.person_outline_rounded,
                                      color: AppColors.gray500,
                                      size: 42,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                TextButton(
                                  onPressed: _showUploadUnavailableMessage,
                                  child: Text(
                                    'Upload picture',
                                    style: AppTextStyles.textMdMedium.copyWith(
                                      color: AppColors.indigo600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxxl),
                          for (
                            var index = 0;
                            index < _vehicleNumberControllers.length;
                            index++
                          ) ...[
                            _VehicleNumberField(
                              controller: _vehicleNumberControllers[index],
                              index: index,
                              canRemove: _vehicleNumberControllers.length > 1,
                              onAdd: _addVehicleField,
                              onRemove: () => _removeVehicleField(index),
                              onSubmit: _submit,
                            ),
                            if (index < _vehicleNumberControllers.length - 1)
                              const SizedBox(height: AppSpacing.lg),
                          ],
                          const SizedBox(height: AppSpacing.xxxl),
                          AppButton(label: 'Done', onPressed: _submit),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isSubmitting) const AppLoadingOverlay(),
      ],
    );
  }
}

class _VehicleNumberField extends StatelessWidget {
  const _VehicleNumberField({
    required this.controller,
    required this.index,
    required this.canRemove,
    required this.onAdd,
    required this.onRemove,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final int index;
  final bool canRemove;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AppTextField(
            controller: controller,
            label: index == 0
                ? 'Enter your vehicle number'
                : 'Vehicle number ${index + 1}',
            hintText: 'Ba Pa 2446',
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            validator: AuthFormValidators.vehicleNumber,
            onFieldSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _VehicleFieldButton(
          tooltip: 'Add vehicle number',
          icon: Icons.add_rounded,
          onPressed: onAdd,
        ),
        const SizedBox(width: AppSpacing.xs),
        _VehicleFieldButton(
          tooltip: canRemove ? 'Remove vehicle number' : 'Clear vehicle number',
          icon: Icons.remove_rounded,
          onPressed: onRemove,
        ),
      ],
    );
  }
}

class _VehicleFieldButton extends StatelessWidget {
  const _VehicleFieldButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.gray100,
          foregroundColor: AppColors.gray700,
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: const BorderSide(color: AppColors.gray200),
          ),
        ),
        icon: Icon(icon),
      ),
    );
  }
}
