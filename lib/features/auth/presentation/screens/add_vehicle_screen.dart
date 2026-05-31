import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
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
  final _vehicleNumberController = TextEditingController();

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mock vehicle number saved.')));
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
                        'Upload your picture and vehicle number',
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
                      AppTextField(
                        controller: _vehicleNumberController,
                        label: 'Enter your vehicle number',
                        hintText: 'Ba-pa 1097',
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.done,
                        validator: AuthFormValidators.vehicleNumber,
                        onFieldSubmitted: (_) => _submit(),
                      ),
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
