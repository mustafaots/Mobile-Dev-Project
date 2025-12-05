import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/reviews.model.dart' as review_model;
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';

class ReviewsSection extends StatelessWidget {
  final List<review_model.Review>? reviews;
  final Map<int, User>? reviewers;

  const ReviewsSection({super.key, this.reviews, this.reviewers});

  void _navigateToProfile(
    BuildContext context, {
    required String userName,
    required String userEmail,
    required int postsCount,
    required int reviewsCount,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ProfileScreen(
          userName: userName,
          userEmail: userEmail,
          postsCount: postsCount,
          reviewsCount: reviewsCount,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    String name,
    double rating,
    String comment, {
    int postsCount = 0,
    int reviewsCount = 0,
  }) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        _navigateToProfile(
          context,
          userName: name,
          userEmail: '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
          postsCount: postsCount,
          reviewsCount: reviewsCount,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: secondaryTextColor.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reviewer Profile Picture
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // TODO: image
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        _buildStarRating(rating),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      comment,
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.listingDetails_daysAgo(2),
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            i <= rating
                ? Icons.star
                : (i - 0.5 <= rating ? Icons.star_half : Icons.star_border),
            color: AppTheme.neutralColor,
            size: 16,
          ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.neutralColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final cardColor = context.cardColor;

    // Use provided reviews or show defaults
    final reviewsList = reviews ?? [];

    // Build the displayed reviews
    late List<Widget> displayedReviews;

    if (reviewsList.isEmpty) {
      displayedReviews = [
        _buildReviewItem(
          context,
          'Alex Johnson',
          4.5,
          'Absolutely stunning view and the villa was immaculate. Ali was a fantastic host!',
          postsCount: 18,
          reviewsCount: 23,
        ),
        _buildReviewItem(
          context,
          'Maria Garcia',
          5.0,
          'A perfect getaway. The location is unbeatable. Highly recommended.',
          postsCount: 32,
          reviewsCount: 45,
        ),
      ];
    } else {
      displayedReviews = reviewsList.take(2).map((review_model.Review review) {
        final reviewer = reviewers?[review.reviewerId];
        return _buildReviewItem(
          context,
          reviewer!.username,
          review.rating.toDouble(),
          review.comment ?? '',
          postsCount: 0,
          reviewsCount: 0,

        );
      }).toList();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppTheme.neutralColor, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.listingDetails_reviews,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...displayedReviews
              .map(
                (reviewWidget) => Column(
                  children: [reviewWidget, const SizedBox(height: 16)],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
