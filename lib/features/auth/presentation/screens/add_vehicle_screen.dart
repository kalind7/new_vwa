import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_screen.dart';
import '../../../../shared/widgets/app_text_field.dart';
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

  void _showUploadMockMessage() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Picture upload will be connected in a later milestone.'),
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final vehicleCount = _vehicleNumberControllers
        .where((controller) => controller.text.trim().isNotEmpty)
        .length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mock saved $vehicleCount vehicle number(s).')),
    );
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      backgroundColor: AppColors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
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
                              onPressed: _showUploadMockMessage,
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
            hintText: 'Ba-pa 1097',
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
