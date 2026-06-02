import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../utils/auth_form_validators.dart';
import '../widgets/auth_flow_layout.dart';
import '../widgets/auth_form_section.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    AppToast.showNeutral(context, 'Mock OTP sent to this phone number.');
    Navigator.of(context).pushNamed(AppRoutes.verifyOtp);
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowLayout(
      title: 'Forget password',
      subtitle: "No worries, we'll send you reset instructions.",
      showBackButton: true,
      bottom: AuthLinkRow(
        text: 'Remember Password?',
        actionText: 'Login',
        onPressed: () => Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false),
      ),
      child: Form(
        key: _formKey,
        child: AuthFormSection(
          children: [
            AppTextField(
              controller: _phoneController,
              label: 'Phone no',
              hintText: '9801234567',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: AuthFormValidators.phone,
              onFieldSubmitted: (_) => _submit(),
            ),
            AppButton(label: 'Next', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
