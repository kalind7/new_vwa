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
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../profile/domain/repositories/user_repository.dart';
import '../utils/auth_form_validators.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key, this.fromProfile = false});

  /// When opened from Profile → My vehicle, hides profile-photo onboarding UI.
  final bool fromProfile;

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
      _finishSuccess();
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
        _finishSuccess();
      },
    );
  }

  void _finishSuccess() {
    if (widget.fromProfile) {
      Navigator.of(context).pop(true);
      return;
    }

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final form = _VehicleForm(
      formKey: _formKey,
      controllers: _vehicleNumberControllers,
      fromProfile: widget.fromProfile,
      onAddField: _addVehicleField,
      onRemoveField: _removeVehicleField,
      onSubmit: _submit,
    );

    if (widget.fromProfile) {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.white,
            appBar: buildAppScreenHeader(context, title: 'Add vehicle'),
            body: form,
          ),
          if (_isSubmitting) const AppLoadingOverlay(),
        ],
      );
    }

    return Stack(
      children: [
        AppScreen(
          backgroundColor: AppColors.white,
          child: form,
        ),
        if (_isSubmitting) const AppLoadingOverlay(),
      ],
    );
  }
}

class _VehicleForm extends StatelessWidget {
  const _VehicleForm({
    required this.formKey,
    required this.controllers,
    required this.fromProfile,
    required this.onAddField,
    required this.onRemoveField,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final List<TextEditingController> controllers;
  final bool fromProfile;
  final VoidCallback onAddField;
  final void Function(int index) onRemoveField;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: fromProfile ? AppSpacing.lg : AppSpacing.xxl,
            bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xxl,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: fromProfile ? 0 : constraints.maxHeight,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!fromProfile) ...[
                    Text(
                      'Setup your profile',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.gray800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Add your vehicle numbers to get started',
                      style: AppTextStyles.textSmRegular.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ] else ...[
                    Text(
                      'Enter your bike plate number',
                      style: AppTextStyles.textSmRegular.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  for (var index = 0; index < controllers.length; index++) ...[
                    _VehicleNumberField(
                      controller: controllers[index],
                      index: index,
                      canRemove: controllers.length > 1,
                      onAdd: onAddField,
                      onRemove: () => onRemoveField(index),
                      onSubmit: onSubmit,
                    ),
                    if (index < controllers.length - 1)
                      const SizedBox(height: AppSpacing.lg),
                  ],
                  const SizedBox(height: AppSpacing.xxxl),
                  AppButton(
                    label: fromProfile ? 'Save vehicle' : 'Done',
                    onPressed: onSubmit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
