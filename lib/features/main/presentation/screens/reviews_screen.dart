import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_radius.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/empty_state_view.dart';
import '../../../../shared/widgets/shimmers/app_shimmer.dart';
import '../../../booking/data/datasources/rating_remote_data_source.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Map<String, dynamic>> _ratings = const [];
  var _isLoading = true;
  var _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final result = await context
        .read<RatingRemoteDataSource>()
        .fetchUserRatings();
    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        _ratings = const [];
        _hasError = true;
        AppToast.showError(
          context,
          failure.message.isNotEmpty
              ? failure.message
              : 'Could not load reviews. Complete a wash booking to leave your first review.',
        );
      },
      (ratings) {
        _ratings = ratings;
        _hasError = false;
      },
    );

    setState(() => _isLoading = false);
  }

  double get _averageRating {
    if (_ratings.isEmpty) {
      return 0;
    }
    final total = _ratings.fold<double>(0, (sum, rating) {
      final value = rating['rating'];
      if (value is num) {
        return sum + value.toDouble();
      }
      return sum + (double.tryParse('$value') ?? 0);
    });
    return total / _ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Reviews'),
      body: _isLoading
          ? ListView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              children: List.generate(
                4,
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AppShimmerBox(
                    width: double.infinity,
                    height: 96,
                    borderRadius: AppRadius.md,
                  ),
                ),
              ),
            )
          : _ratings.isEmpty
          ? EmptyStateView(
              title: _hasError ? 'Reviews unavailable' : 'No reviews yet',
              message: _hasError
                  ? 'We could not load your reviews right now. Book and complete a wash, then share your experience.'
                  : 'After you complete a wash booking, you can leave a review from the wash detail screen.',
              icon: Icons.rate_review_outlined,
            )
          : RefreshIndicator(
              onRefresh: _loadRatings,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                children: [
                  _RatingSummaryCard(
                    average: _averageRating,
                    count: _ratings.length,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  for (final rating in _ratings) ...[
                    _ReviewTile(
                      name:
                          '${rating['user_name'] ?? rating['station_name'] ?? 'You'}',
                      time: '${rating['created_at'] ?? rating['date'] ?? ''}',
                      comment:
                          '${rating['review'] ?? rating['comment'] ?? 'No comment'}',
                      rating: rating['rating'] is int
                          ? rating['rating'] as int
                          : int.tryParse('${rating['rating']}') ?? 0,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ],
              ),
            ),
    );
  }
}

class _RatingSummaryCard extends StatelessWidget {
  const _RatingSummaryCard({required this.average, required this.count});

  final double average;
  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your reviews',
                    style: AppTextStyles.textMdSemiBold.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$count review${count == 1 ? '' : 's'} submitted',
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  average.toStringAsFixed(1),
                  style: AppTextStyles.displayXsSemiBold.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < average.round() ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFEC84B),
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.name,
    required this.time,
    required this.comment,
    required this.rating,
  });

  final String name;
  final String time;
  final String comment;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.gray200,
              child: Text(
                name.isNotEmpty ? name.characters.first : '?',
                style: AppTextStyles.textSmMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.textMdSemiBold.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < rating.clamp(0, 5); i++)
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFFEC84B),
                        ),
                      if (time.isNotEmpty) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.textSmRegular.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          comment,
          style: AppTextStyles.textSmRegular.copyWith(color: AppColors.gray900),
        ),
      ],
    );
  }
}
