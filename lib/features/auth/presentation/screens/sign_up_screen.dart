import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_config.dart';
import '../../../../config/app_spacing.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/auth_tab_switcher.dart';
import '../utils/auth_form_validators.dart';
import '../widgets/auth_flow_layout.dart';
import '../widgets/auth_form_section.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false) || _isSubmitting) {
      return;
    }

    if (AppConfig.useMockData) {
      setState(() => _isSubmitting = true);
      AppToast.showSuccess(context, 'Mock registration details accepted.');
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.addVehicle, (route) => false);
      return;
    }

    setState(() => _isSubmitting = true);

    final name =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
    final password = _passwordController.text;

    final result = await context.read<AuthRepository>().register(
      name: name,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: password,
      passwordConfirmation: password,
    );

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
        AppToast.showSuccess(context, 'Registration successful.');
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.addVehicle, (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;

    return Stack(
      children: [
        AuthFlowLayout(
          title: 'Get Started now',
          subtitle: 'Create an account or log in to explore about our app',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTabSwitcher(
                  selectedIndex: 1,
                  onChanged: (index) {
                    if (index == 0) {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.login);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                AuthFormSection(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _firstNameController,
                            label: 'First Name',
                            hintText: 'Louis',
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) =>
                                AuthFormValidators.requiredName(
                                  value,
                                  'First name',
                                ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppTextField(
                            controller: _lastNameController,
                            label: 'Last Name',
                            hintText: 'Becket',
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) =>
                                AuthFormValidators.requiredName(
                                  value,
                                  'Last name',
                                ),
                          ),
                        ),
                      ],
                    ),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Louisbecket@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: AuthFormValidators.email,
                    ),
                    AppTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hintText: '9801234567',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: AuthFormValidators.phone,
                    ),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Set Password',
                      hintText: '*******',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: AuthFormValidators.password,
                      onChanged: (_) => setState(() {}),
                      onFieldSubmitted: (_) => _submit(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
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
                          isMet: AuthFormValidators.hasMinPasswordLength(
                            password,
                          ),
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
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppButton(
                  label: 'Register',
                  onPressed: _isSubmitting ? null : _submit,
                ),
                const SizedBox(height: AppSpacing.lg),
                AuthLinkRow(
                  text: 'Already have an account?',
                  actionText: 'Login',
                  onPressed: _isSubmitting
                      ? () {}
                      : () => Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
        if (_isSubmitting) const AppLoadingOverlay(),
      ],
    );
  }
}
