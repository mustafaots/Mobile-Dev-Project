import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/reviews.model.dart' as review_model;
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/logic/cubit/reviews_cubit.dart';
import 'package:easy_vacation/logic/cubit/reviews_state.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';

class ReviewsSection extends StatelessWidget {
  final List<review_model.Review>? reviews;
  final Map<String, User>? reviewers;
  final int? postId;
  final ReviewsCubit? cubit;

  const ReviewsSection({
    super.key,
    this.reviews,
    this.reviewers,
    this.postId,
    this.cubit,
  });

  void _navigateToProfile(
    BuildContext context, {
    required String userName,
    required int postsCount,
    required int reviewsCount,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ProfileScreen(
          userName: userName,
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
    String? profilePictureUrl,
  }) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        _navigateToProfile(
          context,
          userName: name,
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
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                  image: profilePictureUrl != null
                      ? DecorationImage(
                          image: NetworkImage(profilePictureUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
                child: profilePictureUrl == null
                    ? Center(
                        child: Text(
                          _getInitials(name),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : null,
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

  /// Extract initials from reviewer name for avatar
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final cardColor = context.cardColor;

    // If cubit is provided, use BlocBuilder to listen to state changes
    if (cubit != null) {
      return BlocBuilder<ReviewsCubit, ReviewsState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is ReviewsLoading) {
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
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
            );
          }

          if (state is ReviewsError) {
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
              child: Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state is ReviewsLoaded) {
            final displayedReviews = state.reviews.take(2).map((review) {
              final reviewer = state.reviewers[review.reviewerId];
              return _buildReviewItem(
                context,
                reviewer?.username ?? 'Unknown User',
                review.rating.toDouble(),
                review.comment ?? '',
                postsCount: 0,
                reviewsCount: 0,
                profilePictureUrl:
                    null, // Can be set if profile picture URL is added to User model
              );
            }).toList();

            if (displayedReviews.isEmpty) {
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
                child: Center(
                  child: Text(
                    'No reviews yet',
                    style: TextStyle(color: textColor),
                  ),
                ),
              );
            }

            return _buildReviewsContainer(
              context,
              displayedReviews,
              cardColor,
              textColor,
            );
          }

          return const SizedBox.shrink();
        },
      );
    }

    // Fallback: Use provided reviews or show defaults
    final reviewsList = reviews ?? [];

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
          profilePictureUrl: null,
        ),
        _buildReviewItem(
          context,
          'Maria Garcia',
          5.0,
          'A perfect getaway. The location is unbeatable. Highly recommended.',
          postsCount: 32,
          reviewsCount: 45,
          profilePictureUrl: null,
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
          profilePictureUrl: null,
        );
      }).toList();
    }

    return _buildReviewsContainer(
      context,
      displayedReviews,
      cardColor,
      textColor,
    );
  }

  Widget _buildReviewsContainer(
    BuildContext context,
    List<Widget> displayedReviews,
    Color cardColor,
    Color textColor,
  ) {
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
