import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_svg_icon.dart';

class LeaveReviewScreen extends StatefulWidget {
  const LeaveReviewScreen({super.key});

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  var _rating = 0;
  final _commentController = TextEditingController();
  String? _ratingError;
  String? _commentError;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool _validate() {
    final comment = _commentController.text.trim();
    var isValid = true;

    setState(() {
      _ratingError = _rating == 0 ? 'Please select a star rating.' : null;
      _commentError = comment.isEmpty ? 'Please leave a comment.' : null;
      isValid = _ratingError == null && _commentError == null;
    });

    return isValid;
  }

  void _submit() {
    if (!_validate()) {
      return;
    }

    Navigator.of(context).pushNamed(AppRoutes.feedbackThanks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    AppSpacing.xxxl * 2,
                    AppSpacing.xxl,
                    AppSpacing.xxl,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'How\'s your experience so far?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textXlSemiBold.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'We\'d love to know!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textMdRegular.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isFilled = starIndex <= _rating;
                          return IconButton(
                            onPressed: () => setState(() {
                              _rating = starIndex;
                              _ratingError = null;
                            }),
                            icon: AppSvgIcon(
                              AppSvgIconName.star,
                              size: 36,
                              color: isFilled
                                  ? const Color(0xFFFEC84B)
                                  : AppColors.gray300,
                            ),
                          );
                        }),
                      ),
                      if (_ratingError != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _ratingError!,
                          style: AppTextStyles.textSmRegular.copyWith(
                            color: AppColors.error500,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxxl),
                      TextField(
                        controller: _commentController,
                        maxLines: 6,
                        onChanged: (_) {
                          if (_commentError != null) {
                            setState(() => _commentError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Leave your comment here',
                          hintStyle: AppTextStyles.textMdRegular.copyWith(
                            color: AppColors.gray500,
                          ),
                          errorText: _commentError,
                          contentPadding: const EdgeInsets.all(AppSpacing.lg),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            borderSide: const BorderSide(color: AppColors.gray300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            borderSide: const BorderSide(color: AppColors.gray300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            borderSide: const BorderSide(color: AppColors.gray500),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            borderSide: const BorderSide(color: AppColors.error500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.gray200),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                  AppSpacing.lg,
                ),
                child: AppButton(
                  label: 'Submit',
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
