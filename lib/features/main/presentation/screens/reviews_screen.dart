import 'package:flutter/material.dart';

import '../../../../config/app_radius.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_screen_header.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Reviews'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(child: _RatingBars()),
                  const SizedBox(width: AppSpacing.xxl),
                  Column(
                    children: [
                      Text(
                        '4.0',
                        style: AppTextStyles.displayXsSemiBold.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFFEC84B), size: 16),
                          Icon(Icons.star, color: Color(0xFFFEC84B), size: 16),
                          Icon(Icons.star, color: Color(0xFFFEC84B), size: 16),
                          Icon(Icons.star, color: Color(0xFFFEC84B), size: 16),
                          Icon(Icons.star_border, color: Color(0xFFFEC84B), size: 16),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '52 Reviews',
                        style: AppTextStyles.textSmRegular.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _ReviewTile(
            name: 'Courtney Henry',
            time: '2 mins ago',
            comment:
                'Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex.',
            rating: 5,
          ),
        ],
      ),
    );
  }
}

class _RatingBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _RatingBarRow(stars: 5, fill: 0.9),
        _RatingBarRow(stars: 4, fill: 0.5),
        _RatingBarRow(stars: 3, fill: 0.2),
        _RatingBarRow(stars: 2, fill: 0.1),
        _RatingBarRow(stars: 1, fill: 0.05),
      ],
    );
  }
}

class _RatingBarRow extends StatelessWidget {
  const _RatingBarRow({required this.stars, required this.fill});

  final int stars;
  final double fill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Text('$stars', style: AppTextStyles.textSmRegular),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.star, size: 14, color: Color(0xFFFEC84B)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fill,
                minHeight: 8,
                backgroundColor: AppColors.gray200,
                color: AppColors.gray400,
              ),
            ),
          ),
        ],
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
              child: Text(name.characters.first),
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
                      for (var i = 0; i < rating; i++)
                        const Icon(Icons.star, size: 14, color: Color(0xFFFEC84B)),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        time,
                        style: AppTextStyles.textSmRegular.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
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
          style: AppTextStyles.textSmRegular.copyWith(
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }
}
