import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/logic/cubit/booked_post_cubit.dart';
import 'package:easy_vacation/logic/cubit/booked_post_state.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/screens/BookingsWidgets/bookings_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/main.dart';

class BookedPostBottomInfo extends StatelessWidget {
  final int postId;
  final VoidCallback? onBookingCanceled;

  const BookedPostBottomInfo({
    super.key,
    required this.postId,
    this.onBookingCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookedPostCubit(
        bookingRepository: appRepos['bookingRepo'] as BookingRepository,
        postRepository: appRepos['postRepo'] as PostRepository,
        reviewRepository: appRepos['reviewRepo'] as ReviewRepository,
        userRepository: appRepos['userRepo'] as UserRepository,
        imagesRepository: appRepos['imageRepo'] as PostImagesRepository,
      )..loadPostDetails(postId),
      child: _BookedPostBottomInfoContent(
        postId: postId,
        onBookingCanceled: onBookingCanceled,
      ),
    );
  }
}

class _BookedPostBottomInfoContent extends StatelessWidget {
  final int postId;
  final VoidCallback? onBookingCanceled;

  const _BookedPostBottomInfoContent({
    required this.postId,
    this.onBookingCanceled,
  });

  Future<void> _handleCancelBooking(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(loc.bookings_cancelBooking),
        content: Text(loc.bookings_cancelConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.common_no),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.common_yes),
            style: TextButton.styleFrom(foregroundColor: AppTheme.failureColor),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (context.mounted) {
      context.read<BookedPostCubit>().cancelBooking(postId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = context.cardColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return BlocListener<BookedPostCubit, BookedPostState>(
      listener: (context, state) {
        if (state is BookedPostCanceled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.bookings_canceledSuccessfully,
              ),
              backgroundColor: AppTheme.successColor,
            ),
          );

          // Notify parent of cancellation and pop screen
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (context.mounted) {
              onBookingCanceled?.call();
              Navigator.of(context).pop();
            }
          });
        } else if (state is BookedPostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.failureColor,
            ),
          );
        }
      },
      child: BlocBuilder<BookedPostCubit, BookedPostState>(
        builder: (context, state) {
          if (state is BookedPostLoading) {
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: const SizedBox(
                  height: 56,
                  child: Center(child: AppProgressIndicator(strokeWidth: 2)),
                ),
              ),
            );
          }

          // Handle both BookedPostLoaded and BookedPostCanceling states
          // The cubit preserves all data during cancellation
          if (state is BookedPostLoaded || state is BookedPostCanceling) {
            // Extract shared data from either state using getters
            final bookingDates = state is BookedPostLoaded
                ? state.bookingDates
                : (state as BookedPostCanceling).bookingDates;

            final bookingStatus = state is BookedPostLoaded
                ? state.bookingStatus
                : (state as BookedPostCanceling).bookingStatus;

            final isCanceling = state is BookedPostCanceling;

            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.bookings_yourBooking,
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bookingDates,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: BookingsHelper.getStatusColor(
                                bookingStatus,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: BookingsHelper.getStatusColor(
                                  bookingStatus,
                                ).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              BookingsHelper.getStatusLabel(
                                context,
                                bookingStatus,
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: BookingsHelper.getStatusColor(
                                  bookingStatus,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (bookingStatus != 'rejected')
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: ElevatedButton.icon(
                          onPressed: isCanceling
                              ? null
                              : () => _handleCancelBooking(context),
                          icon: isCanceling
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: AppProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.close, size: 16),
                          label: Text(
                            AppLocalizations.of(context)!.bookings_cancel,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.failureColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
