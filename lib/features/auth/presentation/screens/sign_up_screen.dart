import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock registration details accepted.')),
    );
    Navigator.of(context).pushNamed(AppRoutes.verifyEmail);
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;

    return AuthFlowLayout(
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
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
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
                        validator: (value) => AuthFormValidators.requiredName(
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
                            AuthFormValidators.requiredName(value, 'Last name'),
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
                  hintText: '(454) 726-0592',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
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
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
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
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(label: 'Register', onPressed: _submit),
            const SizedBox(height: AppSpacing.lg),
            AuthLinkRow(
              text: 'Already have an account?',
              actionText: 'Login',
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
