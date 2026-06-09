import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_config.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flow_close_header.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../booking/data/datasources/rating_remote_data_source.dart';

class LeaveReviewScreen extends StatefulWidget {
  const LeaveReviewScreen({super.key, this.bookingId});

  final String? bookingId;

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  var _rating = 0;
  final _commentController = TextEditingController();
  String? _ratingError;
  String? _commentError;
  var _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.mainShell,
      (route) => false,
    );
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

  Future<void> _submit() async {
    if (!_validate()) {
      return;
    }

    if (AppConfig.useMockData) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushNamed(AppRoutes.feedbackThanks);
      return;
    }

    final bookingId = widget.bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      AppToast.showError(context, 'Booking reference missing for this review.');
      return;
    }

    setState(() => _isSubmitting = true);
    final result = await context.read<RatingRemoteDataSource>().submitRating(
      bookingId: bookingId,
      rating: _rating,
      review: _commentController.text.trim(),
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSubmitting = false);

    result.fold((failure) => AppToast.showError(context, failure.message), (_) {
      AppToast.showSuccess(context, 'Thank you for your review.');
      Navigator.of(context).pushNamed(AppRoutes.feedbackThanks);
    });
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
          child: Stack(
            children: [
              Column(
                children: [
                  AppFlowCloseHeader(onClose: _goHome),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xxl,
                        AppSpacing.lg,
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
                            'We\'d love to hear your feedback.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.textSmRegular.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxxl),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final starIndex = index + 1;
                              final isFilled = starIndex <= _rating;
                              return IconButton(
                                onPressed: () =>
                                    setState(() => _rating = starIndex),
                                icon: Icon(
                                  isFilled ? Icons.star : Icons.star_border,
                                  color: const Color(0xFFFEC84B),
                                  size: 36,
                                ),
                              );
                            }),
                          ),
                          if (_ratingError != null) ...[
                            const SizedBox(height: AppSpacing.sm),
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
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Share your experience...',
                              hintStyle: AppTextStyles.textMdRegular.copyWith(
                                color: AppColors.gray400,
                              ),
                              filled: true,
                              fillColor: AppColors.gray50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.gray200,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.gray200,
                                ),
                              ),
                            ),
                          ),
                          if (_commentError != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _commentError!,
                                style: AppTextStyles.textSmRegular.copyWith(
                                  color: AppColors.error500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xxl,
                      AppSpacing.md,
                      AppSpacing.xxl,
                      AppSpacing.xxl,
                    ),
                    child: AppButton(label: 'Submit', onPressed: _submit),
                  ),
                ],
              ),
              if (_isSubmitting) const AppLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}
