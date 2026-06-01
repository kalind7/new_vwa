import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/auth_tab_switcher.dart';
import '../utils/auth_form_validators.dart';
import '../widgets/auth_flow_layout.dart';
import '../widgets/auth_form_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _rememberMe
              ? 'Mock login successful. Remember me enabled.'
              : 'Mock login successful.',
        ),
      ),
    );
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowLayout(
      title: 'Sign in to your Account',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTabSwitcher(
              selectedIndex: 0,
              onChanged: (index) {
                if (index == 1) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.signUp);
                }
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            AuthFormSection(
              children: [
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: AuthFormValidators.email,
                ),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Enter password',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: AuthFormValidators.password,
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
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) =>
                      setState(() => _rememberMe = value ?? false),
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Remember me',
                  style: AppTextStyles.textXsMedium.copyWith(
                    color: AppColors.secondary400,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password ?',
                    style: AppTextStyles.textXsMedium.copyWith(
                      color: AppColors.indigo600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(label: 'Login', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
