import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../utils/auth_form_validators.dart';
import '../widgets/auth_flow_layout.dart';
import '../widgets/auth_form_section.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock password reset complete.')),
    );
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final password = _newPasswordController.text;

    return AuthFlowLayout(
      title: 'Forget password',
      subtitle: "No worries, we'll send you reset instructions.",
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: AuthFormSection(
          children: [
            AppTextField(
              controller: _newPasswordController,
              label: 'New Password',
              hintText: 'Enter new password',
              obscureText: _obscureNewPassword,
              textInputAction: TextInputAction.next,
              validator: AuthFormValidators.password,
              onChanged: (_) => setState(() {}),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscureNewPassword = !_obscureNewPassword),
                icon: Icon(
                  _obscureNewPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            AppTextField(
              controller: _confirmPasswordController,
              label: 'Confirm password',
              hintText: 'Confirm new password',
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              validator: (value) =>
                  AuthFormValidators.confirmPassword(value, password),
              onFieldSubmitted: (_) => _submit(),
              suffixIcon: IconButton(
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthPasswordRule(
                  label: 'Must be at least 8 characters',
                  isMet: AuthFormValidators.hasMinPasswordLength(password),
                ),
                const SizedBox(height: AppSpacing.sm),
                AuthPasswordRule(
                  label: 'Must contain one special character',
                  isMet: AuthFormValidators.hasPasswordSpecialCharacter(
                    password,
                  ),
                ),
              ],
            ),
            AppButton(label: 'Reset password', onPressed: _submit),
            TextButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
