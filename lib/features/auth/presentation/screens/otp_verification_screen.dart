import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../widgets/auth_flow_layout.dart';
import '../widgets/auth_form_section.dart';
import '../widgets/otp_code_boxes.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  void _showResendMessage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mock OTP code sent again.')));
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowLayout(
      title: 'Check your phone no',
      subtitle: 'We sent a verification code to your phone number',
      showBackButton: true,
      child: AuthFormSection(
        children: [
          const OtpCodeBoxes(),
          AppButton(
            label: 'Verify',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.resetPassword),
          ),
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
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
    );
  }
}
