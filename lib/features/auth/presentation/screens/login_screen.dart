import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_config.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
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
  bool _isSubmitting = false;
  bool _rememberMeLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_rememberMeLoaded) {
      return;
    }
    _rememberMeLoaded = true;
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final localStorage = context.read<AppDependencies>().localStorage;
    final rememberMe = await localStorage.isRememberMeEnabled();
    if (!rememberMe || !mounted) {
      return;
    }

    final login = await localStorage.readRememberedLogin();
    final password = await localStorage.readRememberedPassword();
    if (!mounted) {
      return;
    }

    setState(() {
      _rememberMe = true;
      if (login != null) {
        _emailController.text = login;
      }
      if (password != null) {
        _passwordController.text = password;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false) || _isSubmitting) {
      return;
    }

    final login = _emailController.text.trim();
    final password = _passwordController.text;
    final localStorage = context.read<AppDependencies>().localStorage;

    setState(() => _isSubmitting = true);

    if (AppConfig.useMockData) {
      await _persistRememberMe(localStorage, login: login, password: password);
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      _showSuccessAndNavigate('Mock login successful.');
      return;
    }

    final result = await context.read<AuthRepository>().login(
      login: login,
      password: password,
    );

    if (!mounted) {
      return;
    }

    await result.fold(
      (failure) async {
        setState(() => _isSubmitting = false);
        AppToast.showError(context, failure.message);
      },
      (_) async {
        await _persistRememberMe(
          localStorage,
          login: login,
          password: password,
        );
        if (!mounted) {
          return;
        }
        setState(() => _isSubmitting = false);
        _showSuccessAndNavigate('Login successful.');
      },
    );
  }

  Future<void> _persistRememberMe(
    LocalStorageService localStorage, {
    required String login,
    required String password,
  }) async {
    if (_rememberMe) {
      await localStorage.saveRememberMe(login: login, password: password);
      return;
    }
    await localStorage.clearRememberMe();
  }

  void _showSuccessAndNavigate(String message) {
    AppToast.showSuccess(context, message);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false);
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showAppConfirmationDialog(
      context: context,
      title: 'Exit app?',
      message: 'Do you want to exit the app?',
      confirmLabel: 'Yes',
      cancelLabel: 'No',
    );

    if (shouldExit && context.mounted) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _confirmExit();
        }
      },
      child: Stack(
        children: [
          AuthFlowLayout(
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
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.signUp);
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
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: _isSubmitting
                            ? null
                            : (value) =>
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
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.forgotPassword),
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
                  AppButton(
                    label: 'Login',
                    onPressed: _isSubmitting ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
          if (_isSubmitting) const AppLoadingOverlay(),
        ],
      ),
    );
  }
}
