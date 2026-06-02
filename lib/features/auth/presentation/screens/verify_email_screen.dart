import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../utils/auth_form_validators.dart';
import '../widgets/auth_flow_layout.dart';
import '../widgets/auth_form_section.dart';
import '../widgets/otp_code_boxes.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  void _showResendMessage(BuildContext context) {
    AppToast.showNeutral(context, 'Mock verification email sent again.');
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    AppToast.showSuccess(context, 'Mock email verified.');
    Navigator.of(context).pushNamed(AppRoutes.addVehicle);
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowLayout(
      title: 'Check your email',
      subtitle: 'We sent a 6-digit verification code to louisbecket@gmail.com',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: AuthFormSection(
          children: [
            const AuthFeaturedIcon(icon: Icons.mark_email_unread_outlined),
            OtpCodeBoxes(validator: AuthFormValidators.otp),
            AppButton(label: 'Continue', onPressed: _submit),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "Didn't receive email? ",
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showResendMessage(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Resend',
                      style: AppTextStyles.textSmMedium.copyWith(
                        color: AppColors.indigo600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
